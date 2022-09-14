import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../models/account_message.dart';
import '../../../widgets/info_dialog_box.dart';
import '../../../constants.dart';
import '../bloc/code_add_bloc.dart';

class CodeAddScreen extends StatefulWidget {
  const CodeAddScreen({Key? key}) : super(key: key);

  @override
  State<CodeAddScreen> createState() => _CodeAddScreenState();
}

class _CodeAddScreenState extends State<CodeAddScreen> {
  final _codeBloc = CodeBloc();

  Future _loadEvents() async {
    print(currentUID);

    final ref = await FirebaseFirestore.instance
        .collection("users")
        .doc("${currentUID}")
        .collection('events')
        .where("isActive", isEqualTo: true)
        .get();

    final events = ref.docs.map((doc) => doc.data()).toList();

    return events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50), topRight: Radius.circular(50)),
        child: SingleChildScrollView(
          child: StreamBuilder<CodeState>(
              stream: _codeBloc.outState,
              initialData: CodeState.LOADING,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data) {
                    case CodeState.LOADING:
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation(Colors.amberAccent),
                        ),
                      );
                    case CodeState.FAIL:
                    case CodeState.SUCCESS:
                    case CodeState.IDLE:
                      return Container(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 16, bottom: 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Text(_dateTimeStart.toString()),
                                Column(
                                  children: [
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  primary: Colors.amberAccent,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 15),
                                  textStyle: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40))),
                              onPressed: () {
                                submitCode('id');
                              },
                              child: const Text(
                                "Adicionar",
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      );
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.amberAccent),
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.amberAccent),
                  ),
                );
              }),
        ),
      ),
    );
  }

  Future submitCode(String id) async {
    if (true) {
      ReportMessage reportMessage = await _codeBloc.uploadCode();
      showDialog(
        context: context,
        builder: (context) => InfoDialogBox(
          title: '',
          infoText: reportMessage.message,
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => InfoDialogBox(
          title: '',
          infoText: 'Selecione um evento',
        ),
      );
    }
  }
}
