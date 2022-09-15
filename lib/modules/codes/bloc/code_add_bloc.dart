import 'dart:async';
import 'dart:io';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app_management/core/auth/event_validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import '../../../models/account_message.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:events_app_management/constants.dart';
import 'package:events_app_management/models/account_message.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../services/storage_service.dart';


enum CodeAddState {IDLE, LOADING, SUCCESS, FAIL}

class CodeAddBloc extends BlocBase with EventValidators{

  StorageService storageService = StorageService();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final _stateController = BehaviorSubject<CodeAddState>();

  Stream<CodeAddState> get outState => _stateController.stream;

  final _nameController = BehaviorSubject<String>();
  final _infoController = BehaviorSubject<String>();

  Stream<String> get outName =>
      _nameController.stream.transform(validateName);

  Stream<String> get outInfo =>
      _infoController.stream.transform(validateInfo);

  Function(String) get changeName => _nameController.sink.add;

  Function(String) get changeInfo => _infoController.sink.add;


  late StreamSubscription _streamSubscription;

  Stream<bool> get outSubmitValidCode =>
      CombineLatestStream.combine2(
          outName,
          outInfo,
              (a, b) {
            return true;
          });


  User? currentUser = FirebaseAuth.instance.currentUser;



  CodeAddBloc(){
    _stateController.add(CodeAddState.IDLE);
  }

  Future<String?> uploadFile(File file) async {

    String? downloadUrl = await storageService.uploadFileGetDonwloadUrl(
        file, 'banners');
    print("$downloadUrl");
    return downloadUrl;

  }

  Future<ReportMessage> uploadCode(File file,String? idEvent) async {

    _stateController.add(CodeAddState.LOADING);



    final name = _nameController.value;
    final info = _infoController.value;


    String? donwloadUrl = await uploadFile(file);
    if(donwloadUrl == null){
      _stateController.add(CodeAddState.IDLE);
      return ReportMessage(code: 1, message: 'Erro no upload do cupom');
    }

    try {

      print('Current UID : $currentUID');
      print(name);
      print(info);
      print(donwloadUrl);

      if(idEvent == ''){
        firestore.collection('codes').add({
          'idUser' :currentUID,
          'name': name,
          'info': info,
          'downloadUrl': donwloadUrl,
        }).then((value) {
          _stateController.add(CodeAddState.SUCCESS);
          return ReportMessage(code: 0, message: 'Evento criado');
        } ).catchError((e) => print(e));
        _stateController.add(CodeAddState.IDLE);
        return ReportMessage(code: 2, message: 'Erro no cadastro do código');
      }

      firestore.collection('codes').add({
        'idUser' :currentUID,
        'name': name,
        'info': info,
        'downloadUrl': donwloadUrl,
        'idEvent' : idEvent,
      }).then((value) {
        _stateController.add(CodeAddState.SUCCESS);
        return ReportMessage(code: 0, message: 'Evento criado');
      } ).catchError((e) => print(e));
      _stateController.add(CodeAddState.IDLE);
      return ReportMessage(code: 2, message: 'Erro no cadastro do código');

    } on FirebaseException catch (e) {
      print(e);
      _stateController.add(CodeAddState.IDLE);
      return ReportMessage(code: 2, message: 'Erro no cadastro do código');
    }

  }



  @override
  void dispose() {
    _nameController.close();
    _infoController.close();
    _streamSubscription.cancel();
  }


}