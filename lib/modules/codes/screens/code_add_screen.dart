import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:events_app_management/modules/codes/screens/code_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/account_message.dart';
import '../../../widgets/info_dialog_box.dart';
import '../../../constants.dart';
import '../../../widgets/input_field.dart';
import '../bloc/code_add_bloc.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';

class CodeAddScreen extends StatefulWidget {
  const CodeAddScreen({Key? key}) : super(key: key);

  @override
  State<CodeAddScreen> createState() => _CodeAddScreenState();
}

class _CodeAddScreenState extends State<CodeAddScreen> {
  final _codeAddBloc = CodeAddBloc();
  File? file;
  bool _hasFile = false;
  String _selected = '';
  String _selectedIdEvent = '';
  var _eventsList;


  Future _loadEvents() async {

    print(currentUID);

    final ref = await FirebaseFirestore.instance
        .collection("events")
        .where("idUser", isEqualTo: currentUID).get();


    final _eventsList = ref.docs.map((doc) => {'id' : doc.id,'data' : doc.data()}).toList();

    return _eventsList;
  }

  Future selectGalleryFile() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      final imageShow = File(image!.path);
      setState(() {
        file = imageShow;
        _hasFile = true;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future submitCode() async {
    if (true) {
      ReportMessage reportMessage = await _codeAddBloc.uploadCode(file! , _selectedIdEvent);
      showDialog(
        context: context,
        builder: (context) => InfoDialogBox(
          title: '',
          infoText: reportMessage.message,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _codeAddBloc.outState.listen((state) {
      switch (state) {
        case CodeAddState.SUCCESS:
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const CodesSettingsScreen()));
          break;
        case CodeAddState.FAIL:
          showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                    title: Text("Erro"),
                    content: Text("Erro ao adicionar evento"),
                  ));
          break;
        case CodeAddState.LOADING:
        case CodeAddState.IDLE:
      }
    });
  }

  List teste = ['1', '2'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50), topRight: Radius.circular(50)),
        child: SingleChildScrollView(
          child: StreamBuilder<CodeAddState>(
              stream: _codeAddBloc.outState,
              initialData: CodeAddState.LOADING,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data) {
                    case CodeAddState.LOADING:
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation(Colors.amberAccent),
                        ),
                      );
                    case CodeAddState.FAIL:
                    case CodeAddState.SUCCESS:
                    case CodeAddState.IDLE:
                      return Container(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 16, bottom: 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: EdgeInsets.all(16),
                              //padding of outer Container
                              child: GestureDetector(
                                onTap: () => selectGalleryFile(),
                                child: file != null
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                            const Text(
                                              'Cupom',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24,
                                                  color: Colors.black54),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              child: Container(
                                                height: 220,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                  color: Colors.amberAccent,
                                                ),
                                                child: FittedBox(
                                                  child: Image.file(
                                                    file!,
                                                    fit: BoxFit.fill,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            2.5,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ])
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Cupom',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24,
                                                color: Colors.black54),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          DottedBorder(
                                            color: Colors.grey,
                                            //color of dotted/dash line
                                            strokeWidth: 3,
                                            //thickness of dash/dots
                                            dashPattern: [10, 6],
                                            //dash patterns, 10 is dash width, 6 is space width
                                            child: SizedBox(
                                              height: 240,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: ClipRRect(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      height: 200,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      child: Image.asset(
                                                        'assets/icons/upload_icon.png',
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            InputField(
                                label: 'Nome',
                                icon: Icons.festival,
                                hint: "Nome",
                                obscure: false,
                                stream: _codeAddBloc.outName,
                                onChanged: _codeAddBloc.changeName,
                                minLines: 1,
                                maxLines: 1),
                            const SizedBox(
                              height: 16,
                            ),
                            InputField(
                                label: 'Descrição',
                                icon: Icons.location_on_outlined,
                                hint: "Descrição",
                                obscure: false,
                                stream: _codeAddBloc.outInfo,
                                onChanged: _codeAddBloc.changeInfo,
                                minLines: 4,
                                maxLines: 8,),
                            const SizedBox(
                              height: 8,
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  RaisedButton(
                                    child: Text('Vincular Evento'),
                                    onPressed: () => showEventSelectModal(context),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(_selected == '' ? 'Evento não vinculado': 'Evento : $_selected')
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            StreamBuilder<bool>(
                              stream: _codeAddBloc.outSubmitValidCode,
                              builder: (context, snapshot) {
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      primary: Colors.amberAccent,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15),
                                      textStyle: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(40))),
                                  onPressed: snapshot.hasData ? submitCode : null,

                                  child: const Text(
                                    "Adicionar",
                                  ),
                                );
                              },
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

  void showEventSelectModal(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return FutureBuilder(
            future: _loadEvents(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              _eventsList = snapshot.data as List;
              double containerHeight = (_eventsList.length * 40).toDouble();
              if (!snapshot.hasData) {
                return CircularProgressIndicator(
                  color: Colors.amber,
                );
              }
              else{
                if(snapshot.data != null){
                  return Container(
                    padding: EdgeInsets.all(8),
                    height:  containerHeight,
                    alignment: Alignment.center,
                    child: ListView.separated(
                        itemCount: _eventsList.length,
                        separatorBuilder: (context, int) {
                          return Divider();
                        },
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              child: Text(_eventsList[index]['data']['name']),
                              onTap: () {
                                setState(() {
                                  _selected = _eventsList[index]['data']['name'];
                                  _selectedIdEvent = _eventsList[index]['id'];
                                });
                                Navigator.of(context).pop();
                              });
                        }),
                  );
                }
                return Container(
                  padding: EdgeInsets.all(8),
                  height:  50,
                  alignment: Alignment.center,
                  child: Text('Nenhum evento')
                );
              }

            },

          );

        });
  }
}
