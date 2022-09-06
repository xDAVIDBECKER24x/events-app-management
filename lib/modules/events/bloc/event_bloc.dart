import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:events_app_management/models/account_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rxdart/rxdart.dart';
import '../../../core/auth/signup_validators.dart';

enum EventBlocState { IDLE, LOADING, SUCCESS, FAIL }

class EventBloc extends BlocBase with SignupValidators {
  final _stateController = BehaviorSubject<EventBlocState>();

  Stream<EventBlocState> get outState => _stateController.stream;

  //First Step Sign Up
  final _nameController = BehaviorSubject<String>();
  final _addressController = BehaviorSubject<String>();
  final _dateStartController = BehaviorSubject<String>();
  final _dateEndController = BehaviorSubject<String>();
  final _bannerUrlController = BehaviorSubject<String>();
  final _infosController = BehaviorSubject<String>();

  Stream<String> get outName =>
      _nameController.stream.transform(validateNameField);

  Stream<String> get outAddress =>
      _addressController.stream.transform(validateNameField);

  Stream<String> get outDateStart =>
      _dateStartController.stream.transform(validateNameField);

  Stream<String> get outDateEnd =>
      _dateEndController.stream.transform(validateNameField);

  Stream<String> get outBannerUrl =>
      _bannerUrlController.stream.transform(validateNameField);

  Stream<String> get outInfos =>
      _infosController.stream.transform(validateNameField);


  Function(String) get changeEmail => _nameController.sink.add;

  Function(String) get changePassword => _addressController.sink.add;

  Function(String) get changeConfirmPassword =>
      _dateStartController.sink.add;

  Function(String) get changeName => _dateEndController.sink.add;

  Function(String) get changeAddress => _bannerUrlController.sink.add;

  Function(String) get changeInfos =>
      _infosController.sink.add;

  late StreamSubscription _streamSubscription;

  Stream<bool> get outSubmitValidAccount =>
      CombineLatestStream.combine6(outName, outAddress, outDateStart,outDateEnd,outBannerUrl,outInfos,
              (a,b,c,d,e,f) {
            return true;
          });


  EventBloc() {
    FirebaseAuth.instance.signOut();
    _stateController.add(EventBlocState.IDLE);
  }


  @override
  void dispose() {
    _bannerUrlController.close();
    _dateEndController.close();
    _dateStartController.close();
    _nameController.close();
    _addressController.close();
    _stateController.close();
    _streamSubscription.cancel();
  }
}
