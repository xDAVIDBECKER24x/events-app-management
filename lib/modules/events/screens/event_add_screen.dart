import 'package:dotted_border/dotted_border.dart';
import 'package:events_app_management/widgets/date_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../widgets/info_dialog_box.dart';
import '../../../widgets/input_field.dart';
import '../bloc/event_bloc.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class EventAddScreen extends StatefulWidget {
  const EventAddScreen({Key? key}) : super(key: key);

  @override
  State<EventAddScreen> createState() => _EventAddScreenState();
}

class _EventAddScreenState extends State<EventAddScreen> {
  final _eventBloc = EventBloc();
  File? file;
  bool _hasFile = false;
  DateTime currentDate = DateTime.now();
  DateTime _dateTimeStart = DateTime.now();
  DateTime _dateTimeEnd = DateTime.now();
  bool _dateTimeStartPicked = false;
  bool _dateTimeEndPicked = false;

  Future selectGalleryFile() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      final imageShow = File(image!.path);
      setState(() {
        this.file = imageShow;
        _hasFile = true;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectDateTime(BuildContext context, DateTime dateTime) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(
              hour: DateTime.now().hour, minute: DateTime.now().minute));

      if (pickedTime != null)
        setState(() {
          dateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
              pickedTime.hour, pickedTime.minute);
        });
    }
    print(dateTime.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50), topRight: Radius.circular(50)),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.all(16), //padding of outer Container
                    child: GestureDetector(
                      onTap: () => selectGalleryFile(),
                      child: file != null
                          ? ClipRRect(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Banner',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                          color: Colors.black54),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Container(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                          color: Colors.amberAccent,
                                        ),
                                        child: FittedBox(
                                          child: Image.file(
                                            file!,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2.5,
                                          ),
                                        ),
                                      ),
                                    )
                                  ]),
                            )
                          : DottedBorder(
                              color: Colors.grey,
                              //color of dotted/dash line
                              strokeWidth: 3,
                              //thickness of dash/dots
                              dashPattern: [10, 6],
                              //dash patterns, 10 is dash width, 6 is space width
                              child: ClipRRect(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Banner',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                          color: Colors.black54),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  2.5,
                                              child: Container(
                                                padding: EdgeInsets.all(64),
                                                child: Image.asset(
                                                    'assets/icons/upload_icon.png'),
                                              ))),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                  InputField(
                      label: 'Nome',
                      icon: Icons.festival,
                      hint: "Nome",
                      obscure: false,
                      stream: _eventBloc.outName,
                      onChanged: _eventBloc.changeName,
                      minLines: 1,
                      maxLines: 2),
                  const SizedBox(
                    height: 16,
                  ),
                  InputField(
                      label: 'Endereço',
                      icon: Icons.location_on_outlined,
                      hint: "Endereço",
                      obscure: false,
                      stream: _eventBloc.outAddress,
                      onChanged: _eventBloc.changeAddress,
                      minLines: 1,
                      maxLines: 2),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text(_dateTimeStart.toString()),
                      Column(
                        children: [
                          Text(
                            "Data Inicial",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.black54),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width-100,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    primary: Colors.amberAccent,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 15),
                                    textStyle: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(40))),
                                onPressed: () {
                                  _dateTimeStartPicked = true;
                                  _selectDateTime(
                                      context, _dateTimeStart);
                                 },
                                child: _dateTimeStartPicked
                                    ? Container(
                                  child: Text(
                                    DateFormat("dd/MM/yyyy")
                                        .format(_dateTimeStart),
                                    style: TextStyle(fontSize: 22),
                                  ),
                                )
                                    : Container(
                                  child:
                                  Icon(Icons.event_available,size: 40,),
                                ) // Icon(Icons.event_available),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Data Final",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.black54),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width-100,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    primary: Colors.amberAccent,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 15),
                                    textStyle: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(40))),
                                onPressed: () {
                                  _dateTimeEndPicked = true;
                                  _selectDateTime(context, _dateTimeEnd);
                                },
                                child: _dateTimeEndPicked
                                    ? Container(
                                  child: Text(
                                    DateFormat("dd/MM/yyyy")
                                        .format(_dateTimeStart),
                                    style: TextStyle(fontSize: 22),
                                  ),
                                )
                                    : Container(
                                  child: Icon(Icons.event_available,size: 40,),
                                ) // Icon(Icons.event_available),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  InputField(
                    label: 'Descrição',
                    icon: Icons.info_outline,
                    hint: "Descrição",
                    obscure: false,
                    stream: _eventBloc.outInfos,
                    onChanged: _eventBloc.changeInfos,
                    minLines: 4,
                    maxLines: 8,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  StreamBuilder<bool>(
                    stream: _eventBloc.outSubmitValidEvent,
                    builder: (context, snapshot) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: Colors.amberAccent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            textStyle: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40))),
                        onPressed: () {
                          print('$_dateTimeStart \n $_dateTimeEnd');
                          if (file != null && _dateTimeStartPicked == true && _dateTimeEndPicked == true) {
                            _eventBloc.uploadEvent(
                                file!, _dateTimeStart, _dateTimeEnd);
                          }
                          showDialog(
                            context: context,
                            builder: (context) => InfoDialogBox(
                              title: '',
                              infoText: 'Preencha todos os campos',
                            ),
                          );

                        },
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
            ),
          ),
        ),
      ),
    );
  }
}
