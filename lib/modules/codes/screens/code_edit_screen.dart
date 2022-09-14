import 'package:events_app_management/modules/codes/screens/code_settings_screen.dart';
import 'package:flutter/material.dart';

import '../bloc/code_edit_bloc.dart';

class CodeEditScreen extends StatefulWidget {
  final Map<String, dynamic> code;

  const CodeEditScreen({Key? key, required this.code}) : super(key: key);

  @override
  State<CodeEditScreen> createState() => _CodeEditScreenState();
}


class _CodeEditScreenState extends State<CodeEditScreen> {

  final _codeEditBloc = CodeEditBloc();

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
            switch (snapshot.data) {
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
                return  FutureBuilder(
                  future : true,
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if(snapshot.hasData){
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
                                height: 100,
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(widget.code['downloadUrl']),
                                ),
                              ),
                            ],
                          ));

                    }
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.amberAccent),
                      ),
                    );
                  },
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
        });



  }
}
