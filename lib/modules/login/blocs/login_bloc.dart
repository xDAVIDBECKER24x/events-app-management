import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:events_app_management/core/auth/login_validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

enum LoginState {IDLE, LOADING, SUCCESS, FAIL}

class LoginBloc extends BlocBase with LoginValidators{

  final _emailController = BehaviorSubject<String>();
  final _passwordController =BehaviorSubject<String>();
  final _stateController = BehaviorSubject<LoginState>();

  Stream<String> get outEmail => _emailController.stream.transform(validateEmail);
  Stream<String> get outPassword => _passwordController.stream.transform(validatePassword);
  Stream<LoginState> get outState => _stateController.stream;

  Stream<bool> get outSubmitValid => CombineLatestStream.combine2(outEmail, outPassword,(a,b) => true);

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  late StreamSubscription _streamSubscription;

  LoginBloc(){
    FirebaseAuth.instance.signOut();
    _streamSubscription = FirebaseAuth.instance.authStateChanges().listen((user) async {
      print(user?.email);

      if(user != null){
        if(await verifyPrivileges(user)){
          _stateController.add(LoginState.SUCCESS);
        } else {
          FirebaseAuth.instance.signOut();
          _stateController.add(LoginState.FAIL);
        }
      } else {
        _stateController.add(LoginState.IDLE);
      }
    });
  }

  Future submit() async{

    _stateController.add(LoginState.LOADING);

    final email = _emailController.value;
    final password = _passwordController.value;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    } on FirebaseException catch (error) {
      print(error.message);
      _stateController.add(LoginState.FAIL);

    }
  }

  Future<bool> verifyPrivileges(User user) async {
    return await FirebaseFirestore.instance.collection("users").doc(user.uid).get().then((document){
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