import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app_management/core/auth/signup_validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import '../../../constants.dart';

enum SettingsState {IDLE, LOADING, SUCCESS, FAIL}

class SettingsBloc extends BlocBase with SignupValidators{

  final _stateController = BehaviorSubject<SettingsState>();

  Stream<SettingsState> get outState => _stateController.stream;

  User? currentUser = FirebaseAuth.instance.currentUser;
  var userData;

  SettingsBloc(){
    currentUser = FirebaseAuth.instance.currentUser;
    getCurrentUserData();
  }

  Future getCurrentUserData() async{
    _stateController.add(SettingsState.LOADING);
    print(currentUser?.uid);
    try {
      await FirebaseFirestore.instance
          .collection('users').doc(currentUser?.uid).get().then((value) {
        userData = value;
        _stateController.add(SettingsState.IDLE);
      });
    } on FirebaseException catch (error) {
      print(error.message);
      _stateController.add(SettingsState.IDLE);
    }
  }

  @override
  void dispose() {
  }
}