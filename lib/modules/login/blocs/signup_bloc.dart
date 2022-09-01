import 'dart:async';
import 'dart:convert';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:events_app_management/models/account_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import '../../../core/auth/signup_validators.dart';

enum SignUpState {IDLE, LOADING, SUCCESS, FAIL}

class SignUpBloc extends BlocBase with SignupValidators{

  final _stateController = BehaviorSubject<SignUpState>();
  Stream<SignUpState> get outState => _stateController.stream;

  //First Step Sign Up
  final _emailController = BehaviorSubject<String>();
  final _passwordController =BehaviorSubject<String>();
  final _passwordConfirmController =BehaviorSubject<String>();
  Stream<String> get outEmail => _emailController.stream.transform(validateEmail);
  Stream<String> get outPassword => _passwordController.stream.transform(validatePassword);
  Stream<String> get outConfirmPassword => _passwordConfirmController.stream.transform(validatePassword);


  Stream<bool> get outSubmitValidAccount => CombineLatestStream.combine3(
      outEmail,outPassword,outConfirmPassword,(a,b,c){
        return true;
    }
  );

  //Second Step Sign Up
  // final _nameController =BehaviorSubject<String>();
  // final _establishmentController =BehaviorSubject<String>();
  // Stream<String> get outName => _nameController;
  // Stream<String> get outEstablishment => _establishmentController;
  // Stream<bool> get outSubmitValidData => CombineLatestStream.combine3(
  //     outEmail,outPassword,outConfirmPassword,(a,b,c) => true
  // );


  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeConfirmPassword => _passwordConfirmController.sink.add;

  late StreamSubscription _streamSubscription;

  SignUpBloc(){
    FirebaseAuth.instance.signOut();
    _stateController.add(SignUpState.IDLE);
  }

  Future<AccountMessage> signUp() async {
    _stateController.add(SignUpState.LOADING);
    final email = _emailController.value;
    final password = _passwordController.value;
    final passwordConfirm = _passwordConfirmController.value;

    print(email);
    print(password);
    print(passwordConfirm);

    if (password != passwordConfirm) {
      _stateController.add(SignUpState.IDLE);
      return AccountMessage(code: 1, message :'Senhas tem que ser iguais');
    }
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      sendEmailVerification(email);
      return AccountMessage(code : 0 ,message :'Verificar email enviado para : ${email}');
    } on FirebaseException catch (error) {
      _stateController.add(SignUpState.IDLE);
      return AccountMessage(code : 2 ,message :error.message!);
    }

  }


  Future sendEmailVerification(String email) async {

    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (error) {
      print(error);
    }

  }

  Future<bool> checkEmailVerified() async {

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user!= null && user.emailVerified) {
        _stateController.add(SignUpState.IDLE);
        return true;
      }
    } catch (error) {
      print(error);
    }
    return false;
  }

  Future<bool> verifyAdmin(User user) async {
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
    _passwordConfirmController.close();
    _stateController.close();
    _streamSubscription.cancel();
  }
}