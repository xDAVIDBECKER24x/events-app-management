import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app_management/core/auth/signup_validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import '../../../models/account_message.dart';

enum CodeState {IDLE, LOADING, SUCCESS, FAIL}

class CodeBloc extends BlocBase with SignupValidators{

  final _stateController = BehaviorSubject<CodeState>();

  Stream<CodeState> get outState => _stateController.stream;

  User? currentUser = FirebaseAuth.instance.currentUser;

  CodeBloc(){
  }

  Future<ReportMessage> uploadCode() async {
    return ReportMessage(code: 0, message: 'QRCode criado com sucesso!');
  }



  @override
  void dispose() {
  }


}