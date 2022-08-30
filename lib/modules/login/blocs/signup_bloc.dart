import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:events_app_management/core/auth/login_validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import '../../../core/auth/signup_validators.dart';

enum SignUpState {IDLE, LOADING, SUCCESS, FAIL}

class SignUpBloc extends BlocBase with SignupValidators{

  final _emailController = BehaviorSubject<String>();
  final _passwordController =BehaviorSubject<String>();
  final _stateController = BehaviorSubject<SignUpState>();

  Stream<String> get outEmail => _emailController.stream.transform(validateEmail);
  Stream<String> get outPassword => _passwordController.stream.transform(validatePassword);
  Stream<SignUpState> get outState => _stateController.stream;

  Stream<bool> get outSubmitValid => CombineLatestStream.combine2(outEmail, outPassword,(a,b) => true);

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  late StreamSubscription _streamSubscription;

  SignUpBloc(){
    FirebaseAuth.instance.signOut();
    _streamSubscription = FirebaseAuth.instance.authStateChanges().listen((user) async {
      if(user != null){
        if(await verifyPrivileges(user)){
          _stateController.add(SignUpState.SUCCESS);
        } else {
          FirebaseAuth.instance.signOut();
          _stateController.add(SignUpState.FAIL);
        }
      } else {
        _stateController.add(SignUpState.IDLE);
      }
    });
  }

  void submit(){
    final email = _emailController.value;
    final password = _passwordController.value;

    _stateController.add(SignUpState.LOADING);


    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    ).catchError((e){
      _stateController.add(SignUpState.FAIL);
    });
  }

  Future<bool> verifyPrivileges(User user) async {
    return await FirebaseFirestore.instance.collection("admins").doc(user.uid).get().then((document){
      if(document.exists){
        return true;
      }else{
        return false;
      }
    }).catchError((e){
      return false;
    });
  }

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _stateController.close();
    _streamSubscription.cancel();
  }
}