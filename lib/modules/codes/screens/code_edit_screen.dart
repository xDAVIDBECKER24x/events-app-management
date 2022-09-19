import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app_management/modules/codes/screens/code_settings_screen.dart';
import 'package:events_app_management/modules/codes/widgets/event_code_card_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../utils/date_utils.dart';
import '../bloc/code_edit_bloc.dart';

class CodeEditScreen extends StatefulWidget {
  final Map<String, dynamic> code;

  const CodeEditScreen({Key? key, required this.code}) : super(key: key);

  @override
  State<CodeEditScreen> createState() => _CodeEditScreenState();
}

class _CodeEditScreenState extends State<CodeEditScreen> {
  final _codeEditBloc = CodeEditBloc();
  User? currentUser = FirebaseAuth.instance.currentUser;
  var event;

  @override
  void initState() {
    super.initState();

    _codeEditBloc.outState.listen((state) {
      switch (state) {
        case CodeEditState.SUCCESS:
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const CodesSettingsScreen()));
          break;
        case CodeEditState.FAIL:
          showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                    title: Text("Erro"),
                    content: Text("Erro ao atualizar código"),
                  ));
          break;
        case CodeEditState.LOADING:
        case CodeEditState.IDLE:
      }
    });
  }

  Future getEventById(String codeId) async {
    try {
      event = await FirebaseFirestore.instance
          .collection('events')
          .doc(codeId)
          .get();
      return event;
    } on FirebaseException catch (error) {
      print(error.message);
    }
  }

  Future getEventById2(String codeId) async {
    try {
      final event = await FirebaseFirestore.instance
          .collection('events')
          .doc(codeId)
          .get();

      return {'id' : event.id, 'data' : event};
    } on FirebaseException catch (error) {
      print(error.message);
    }
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CodeEditState>(
        stream: _codeEditBloc.outState,
        initialData: CodeEditState.LOADING,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data!) {
              case CodeEditState.LOADING:
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.amberAccent),
                  ),
                );
              case CodeEditState.FAIL:
              case CodeEditState.SUCCESS:
              case CodeEditState.IDLE:
                return _buildWidgetCode(context, widget.code);
            }
          }
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.amberAccent),
            ),
          );
        });
  }

  _buildWidgetCode(BuildContext context, Map<String, dynamic> code) {
    print('-----------------------------------');
    print(code.containsKey('idEvent'));

    return Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        height: MediaQuery.of(context).size.height - 15,
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(8.0), child: Text(code['name'])),
            Divider(),
            Container(
              height: 200,
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(code['downloadUrl']),
              ),
            ),
            Container(
                padding: const EdgeInsets.all(8.0), child: Text(code['info'])),
            Container(
                child: !code.containsKey('idEvent')
                    ? Text('Nenhum evento vinculado')
                    : FutureBuilder(
                        future:getEventById(code['idEvent']),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          print(snapshot.data);
                          if (snapshot.hasError) {
                            return Text("Erro ao carregar evento");
                          }
                          if (snapshot.hasData && !snapshot.data!.exists) {
                            return Text("Evento finalizado/inexistente");
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Map<String, dynamic> event =
                                snapshot.data!.data() as Map<String, dynamic>;
                            return _buildWidgetCodeEvent(event);
                          }
                          return Container(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                color: Colors.amber,
                              ));
                        }))
          ],
        ));
  }

  Widget _buildWidgetCodeEvent(Map<String, dynamic> event) {
    return EventCodeCard(event: event);
  }
}


