import 'dart:async';
import 'dart:io';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:events_app_management/blocs/application_bloc.dart';
import 'package:events_app_management/constants.dart';
import 'package:events_app_management/models/account_message.dart';
import 'package:events_app_management/modules/events/screens/event_add_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../core/auth/signup_validators.dart';
import '../../../services/storage_service.dart';

enum EventAddState { IDLE, LOADING, SUCCESS, FAIL }

class EventAddBloc extends BlocBase with SignupValidators {
  final _stateController = BehaviorSubject<EventAddState>();
  ApplicationBloc aplicationBloc = ApplicationBloc();
  StorageService storageService = StorageService();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<EventAddState> get outState => _stateController.stream;


  final _nameController = BehaviorSubject<String>();
  final _addressController = BehaviorSubject<String>();
  final _dateStartController = BehaviorSubject<String>();
  final _infosController = BehaviorSubject<String>();

  Stream<String> get outName =>
      _nameController.stream.transform(validateNameField);

  Stream<String> get outAddress =>
      _addressController.stream.transform(validateNameField);


  Stream<String> get outInfos =>
      _infosController.stream.transform(validateNameField);

  Function(String) get changeName => _nameController.sink.add;

  Function(String) get changeAddress => _addressController.sink.add;

  Function(String) get changeInfos => _infosController.sink.add;

  late StreamSubscription _streamSubscription;

  Stream<bool> get outSubmitValidEvent =>
      CombineLatestStream.combine3(
          outName,
          outAddress,
          outInfos,
              (a, b, c) {
            return true;
          });

  EventAddBloc() {
    _stateController.add(EventAddState.IDLE);
  }

  Future<String?> uploadFile(File file) async {

    String? downloadUrl = await storageService.uploadFileGetDonwloadUrl(
        file, 'banners');
    print("BLOC : $downloadUrl");
    return downloadUrl;

  }

  Future<ReportMessage> uploadEvent(File file, DateTime dateTimeStart,DateTime dateTimeEnd) async {

    _stateController.add(EventAddState.LOADING);
    final name = _nameController.value;
    final address = _addressController.value;
    final dateStart = dateTimeStart;
    final dateEnd = dateTimeEnd;
    final info = _infosController.value;

    if(currentUID == null){
      currentUID = FirebaseAuth.instance.currentUser?.uid;
      return ReportMessage(code: 2, message: 'Erro autenticação de usuário');
    }
    String? donwloadUrl = await uploadFile(file);
    if(donwloadUrl == null){
      _stateController.add(EventAddState.IDLE);
      return ReportMessage(code: 1, message: 'Erro no upload do banner');
    }
    try {

      print('Current UID : $currentUID');
      print(name);
      print(address);
      print(dateStart);
      print(dateEnd);
      print(info);
      print(donwloadUrl);

      firestore.collection('events').add({
        'name': name,
        'address': address,
        'dateStart': dateStart,
        'dateEnd': dateEnd,
        'info': info,
        'downloadUrl': donwloadUrl,
        'isActive' : true,
        'idUser' : currentUID
      }).then((value) {
        _stateController.add(EventAddState.SUCCESS);
        return ReportMessage(code: 0, message: 'Evento criado');
      } ).catchError((e) => print(e));
      _stateController.add(EventAddState.IDLE);
      return ReportMessage(code: 2, message: 'Erro no cadastro do evento');
    } on FirebaseException catch (e) {
      print(e);
      _stateController.add(EventAddState.IDLE);
      return ReportMessage(code: 2, message: 'Erro no cadastro do evento');
    }
  }

  @override
  void dispose() {
    _nameController.close();
    _addressController.close();
    _stateController.close();
    _streamSubscription.cancel();
  }
}
