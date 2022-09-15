import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app_management/modules/codes/screens/code_settings_screen.dart';
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
  var eventData;

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

  Future getEventByCodeId(String codeId) async {
    print(codeId);

    try {
      eventData = await FirebaseFirestore.instance
          .collection('users').doc(currentUser?.uid).collection('events').doc(codeId)
          .get();
      return eventData;
    } on FirebaseException catch (error) {
      print(error.message);
    }

  }


  @override
  void dispose() {
    _codeEditBloc.dispose();
    super.dispose();
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
                    valueColor:
                    AlwaysStoppedAnimation(Colors.amberAccent),
                  ),
                );
              case CodeEditState.FAIL:
              case CodeEditState.SUCCESS:
              case CodeEditState.IDLE:

                print(widget.code);
                if(!widget.code.containsKey('idEvent')){
                  return _buildWidgetCode();
                }
                else{
                  print("ID EVENT : ${widget.code['idEvent']}");
                  return  FutureBuilder(
                    future : getEventByCodeId(widget.code['idEvent']),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      final event = snapshot.data;
                      if(!snapshot.hasData){
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.amberAccent),
                          ),
                        );
                      }
                      return _buildWidgetCodeEvent(event);
                    },
                  );
                }
            }
          }
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.amberAccent),
            ),
          );
        });
  }

  Widget _buildWidgetCode(){
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        height: MediaQuery.of(context).size.height - 15,
        child: Column(
          children: [
            Container(padding: const EdgeInsets.all(8.0),child: Text(widget.code['name'])),
            Divider(),
            Container(
              height: 200,
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(widget.code['downloadUrl']),
              ),
            ),
            Container(padding: const EdgeInsets.all(8.0),child: Text(widget.code['info'])),
          ],
        ));
  }

  Widget _buildWidgetCodeEvent(event) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        height: MediaQuery.of(context).size.height - 15,
        child: Column(
          children: [
            Container(padding: const EdgeInsets.all(8.0),child: Text(widget.code['name'])),
            Divider(),
            Container(
              height: 200,
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(widget.code['downloadUrl']),
              ),
            ),
            Container(padding: const EdgeInsets.all(8.0),child: Text(widget.code['info'])),
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    height: 150,
                    child: Image.network(
                      event['downloadUrl'],
                     ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          event['name'],
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8,),
                        Row(
                          children: [
                            Icon(Icons.event_available),
                            Text(
                              timestampToDateFormatted(event['dateStart']),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4,),
                        Row(
                          children: [
                            Icon(Icons.timer),
                            Text(
                              timestampToTimeFormatted(event['dateStart']),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4,),
                        Row(
                          children: [
                            Icon(Icons.pin_drop_rounded),
                            Text(
                              event['address'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                  )
                ],
              ),
            ),
          ],
        ));
  }

}
