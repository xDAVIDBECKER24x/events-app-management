import 'dart:async';
import 'dart:io';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:events_app_management/blocs/application_bloc.dart';
import 'package:events_app_management/constants.dart';
import 'package:events_app_management/models/account_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../core/auth/signup_validators.dart';
import '../../../services/storage_service.dart';

enum EventBlocState { IDLE, LOADING, SUCCESS, FAIL }

class EventBloc extends BlocBase with SignupValidators {
  final _stateController = BehaviorSubject<EventBlocState>();
  ApplicationBloc aplicationBloc = ApplicationBloc();
  StorageService storageService = StorageService();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<EventBlocState> get outState => _stateController.stream;

  //First Step Sign Up
  final _nameController = BehaviorSubject<String>();
  final _addressController = BehaviorSubject<String>();
  final _dateStartController = BehaviorSubject<String>();
  final _infosController = BehaviorSubject<String>();

  Stream<String> get outName =>
      _nameController.stream.transform(validateNameField);

  Stream<String> get outAddress =>
      _addressController.stream.transform(validateNameField);

  Stream<String> get outDateStart =>
      _dateStartController.stream.transform(validateNameField);

  Stream<String> get outInfos =>
      _infosController.stream.transform(validateNameField);

  Function(String) get changeName => _nameController.sink.add;

  Function(String) get changeAddress => _addressController.sink.add;

  Function(String) get changeDateStart => _dateStartController.sink.add;

  Function(String) get changeInfos => _infosController.sink.add;

  late StreamSubscription _streamSubscription;

  Stream<bool> get outSubmitValidEvent =>
      CombineLatestStream.combine4(
          outName,
          outAddress,
          outDateStart,
          outInfos,
              (a, b, c, d) {
            return true;
          });

  EventBloc() {
    FirebaseAuth.instance.signOut();
    _stateController.add(EventBlocState.IDLE);
  }

  Future<String?> uploadFile(File file) async {
    try {
      String? donwloadUrl = await storageService.uploadFileGetDonwloadUrl(
          file, 'banners');
      print(donwloadUrl);
      return donwloadUrl;
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future uploadEvent(File file, DateTime dateTimeStart,DateTime dateTimeEnd) async {

    final name = _nameController.value;
    final address = _addressController.value;
    final dateStart = dateTimeStart;
    final dateEnd = dateTimeEnd;
    final info = _infosController;

    try {
      String? donwloadUrl = await uploadFile(file);
      firestore.collection('$currentUID/events').add({
        'name': name,
        'address': address,
        'dateStart': dateStart,
        'dateEnd': dateEnd,
        'info': info,
        'donwloadUrl': donwloadUrl,
      }).then((value) => null)
          .catchError((e) => print(e));

      print(donwloadUrl);
    } on FirebaseException catch (e) {
      print(e);
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
