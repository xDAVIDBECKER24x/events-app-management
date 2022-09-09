import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:events_app_management/models/account_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rxdart/rxdart.dart';
import '../../../core/auth/signup_validators.dart';

enum SignUpState { IDLE, LOADING, SUCCESS, FAIL }

class SignUpBloc extends BlocBase with SignupValidators {
  final _stateController = BehaviorSubject<SignUpState>();

  Stream<SignUpState> get outState => _stateController.stream;

  //First Step Sign Up
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _passwordConfirmController = BehaviorSubject<String>();
  final _nameController = BehaviorSubject<String>();
  final _addressController = BehaviorSubject<String>();
  final _establishmentNameController = BehaviorSubject<String>();

  Stream<String> get outEmail =>
      _emailController.stream.transform(validateEmail);

  Stream<String> get outPassword =>
      _passwordController.stream.transform(validatePassword);

  Stream<String> get outConfirmPassword =>
      _passwordConfirmController.stream.transform(validatePassword);

  Stream<String> get outName =>
      _nameController.stream.transform(validateNameField);

  Stream<String> get outAddress =>
      _addressController.stream.transform(validateNameField);

  Stream<String> get outEstablishmentName =>
      _establishmentNameController.stream.transform(validateNameField);

  Function(String) get changeEmail => _emailController.sink.add;

  Function(String) get changePassword => _passwordController.sink.add;

  Function(String) get changeConfirmPassword =>
      _passwordConfirmController.sink.add;

  Function(String) get changeName => _nameController.sink.add;

  Function(String) get changeAddress => _addressController.sink.add;

  Function(String) get changeEstablishmentName =>
      _establishmentNameController.sink.add;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamSubscription _streamSubscription;
  late User currentUser;

  Stream<bool> get outSubmitValidAccount =>
      CombineLatestStream.combine3(outEmail, outPassword, outConfirmPassword,
          (a, b, c) {
        return true;
      });

  Stream<bool> get outSubmitValidData => CombineLatestStream.combine3(
      outName, outAddress, outEstablishmentName, (a, b, c) => true);

  SignUpBloc() {
    FirebaseAuth.instance.signOut();
    _stateController.add(SignUpState.IDLE);
  }

  Future<ReportMessage> signUp() async {
    _stateController.add(SignUpState.LOADING);
    final email = _emailController.value;
    final password = _passwordController.value;
    final passwordConfirm = _passwordConfirmController.value;

    print(email);
    print(password);
    print(passwordConfirm);

    if (password != passwordConfirm) {
      _stateController.add(SignUpState.IDLE);
      return ReportMessage(code: 1, message: 'Senhas tem que ser iguais');
    }
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      sendEmailVerification(email);
      currentUser = FirebaseAuth.instance.currentUser!;
      return ReportMessage(
          code: 0, message: 'Verificar email enviado para : ${email}');
    } on FirebaseException catch (error) {
      _stateController.add(SignUpState.IDLE);
      return ReportMessage(code: 2, message: error.message!);
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

  Future addInfoSignup() async {
    _stateController.add(SignUpState.LOADING);
    String uid = currentUser.uid;
    String? email = currentUser.email;
    String? address = _addressController.value;
    String? name = _nameController.value;
    String? establishment = _establishmentNameController.value;

    print(email);
    print(uid);
    print(address);
    print(name);
    print(establishment);

    await firestore.collection('partners').add({
      'uid': uid,
      'email': email,
      'address': address,
      'name': name,
      'establishment': establishment,
    })
        .then((value) {
      _stateController.add(SignUpState.IDLE);
      return ReportMessage(
          code: 0, message: 'Infromações atualizadas');
    })
        .catchError((error) {
      _stateController.add(SignUpState.FAIL);
      return ReportMessage(code: 2, message: error.message!);
    });

  }

  Future finalizeSignup() async {}

  bool checkEmailVerified() {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && user.emailVerified) {
        _stateController.add(SignUpState.IDLE);
        return true;
      }
    } catch (error) {
      print(error);
    }
    return false;
  }

  Future<bool> verifyAdmin(User user) async {
    return await FirebaseFirestore.instance
        .collection("admins")
        .doc(user.uid)
        .get()
        .then((document) {
      if (document.exists) {
        return true;
      } else {
        return false;
      }
    }).catchError((e) {
      return false;
    });
  }

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _passwordConfirmController.close();
    _nameController.close();
    _addressController.close();
    _establishmentNameController.close();
    _stateController.close();
    _streamSubscription.cancel();
  }
}
