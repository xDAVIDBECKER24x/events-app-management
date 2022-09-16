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
import '../../../services/firestorage_services.dart';

enum EventSettingsState { IDLE, LOADING, SUCCESS, FAIL }

class EventSettingsBloc extends BlocBase with SignupValidators {
  final _stateController = BehaviorSubject<EventSettingsState>();
  StorageService storageService = StorageService();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<EventSettingsState> get outState => _stateController.stream;

  late StreamSubscription _streamSubscription;


  EventSettingsBloc() {
    _stateController.add(EventSettingsState.IDLE);
  }


  Future deleteEvent(Map<String, dynamic> event) async {

    _stateController.add(EventSettingsState.LOADING);

    if(currentUID == null){
      currentUID = FirebaseAuth.instance.currentUser?.uid;
      return ReportMessage(code: 2, message: 'Erro autenticação de usuário');
    }

    try {
      await storageService.deleteFile(event['data']['eventBannerName'], 'events').then((value){
        firestore.collection('events').doc(event['id']).delete().then((value) {
          _stateController.add(EventSettingsState.SUCCESS);
        });
      });
    } on FirebaseException catch (e) {
      print(e);
      _stateController.add(EventSettingsState.IDLE);
    }
  }

  @override
  void dispose() {
    _stateController.close();
    _streamSubscription.cancel();
  }
}
