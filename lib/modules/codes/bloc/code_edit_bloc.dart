import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import '../../../core/auth/event_validators.dart';
import '../../../models/account_message.dart';

enum CodeEditState {IDLE, LOADING, SUCCESS, FAIL}

class CodeEditBloc extends BlocBase with EventValidators{

  final _stateController = BehaviorSubject<CodeEditState>();

  Stream<CodeEditState> get outState => _stateController.stream;


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
  var eventData;



  CodeEditBloc(){
    _stateController.add(CodeEditState.IDLE);
  }

  Future<ReportMessage> uploadCode() async {
    return ReportMessage(code: 0, message: 'Código atualizado com sucesso!');
  }

  Future getEventByCodeId(String codeId) async {
    _stateController.add(CodeEditState.LOADING);
    try {
      await FirebaseFirestore.instance
          .collection('users').doc(currentUser?.uid).collection('events').doc(codeId)
          .get()
          .then((value) {
        eventData = value;
        _stateController.add(CodeEditState.IDLE);
        return eventData;
      });
    } on FirebaseException catch (error) {
      print(error.message);
      _stateController.add(CodeEditState.IDLE);
    }

  }


  @override
  void dispose(){
    _nameController.close();
    _infoController.close();
    _streamSubscription.cancel();
  }

}