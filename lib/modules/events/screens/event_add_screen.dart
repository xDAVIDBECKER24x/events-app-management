import 'package:dotted_border/dotted_border.dart';
import 'package:events_app_management/models/account_message.dart';
import 'package:events_app_management/modules/events/screens/event_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../widgets/info_dialog_box.dart';
import '../../../widgets/input_field.dart';
import '../bloc/event_bloc.dart';
import 'dart:io';

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
        file = imageShow;
        _hasFile = true;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    _eventBloc.outState.listen((state) {
      switch (state) {
        case EventState.SUCCESS:
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const EventsSettingsScreen()));
          break;
        case EventState.FAIL:
          showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                    title: Text("Erro"),
                    content: Text("Erro ao adicionar evento"),
                  ));
          break;
        case EventState.LOADING:
        case EventState.IDLE:
      }
    });
  }

  Future<void> _selectDateTimeStart(BuildContext context) async {
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

      if (pickedTime != null) {
        setState(() {
          _dateTimeStart = DateTime(pickedDate.year, pickedDate.month,
              pickedDate.day, pickedTime.hour, pickedTime.minute);
        });
      }
    }
  }

  Future<void> _selectDateTimeEnd(BuildContext context) async {
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

      if (pickedTime != null) {
        setState(() {
          _dateTimeEnd = DateTime(pickedDate.year, pickedDate.month,
              pickedDate.day, pickedTime.hour, pickedTime.minute);
        });
      }
    }
  }

  @override
  void dispose() {
    _eventBloc.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50), topRight: Radius.circular(50)),
        child: SingleChildScrollView(
          child: StreamBuilder<EventState>(
              stream: _eventBloc.outState,
              initialData: EventState.LOADING,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data) {
                    case EventState.LOADING:
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation(Colors.amberAccent),
                        ),
                      );
                    case EventState.FAIL:
                    case EventState.SUCCESS:
                    case EventState.IDLE:
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
                                              'Banner',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24,
                                                  color: Colors.black54),
                                            ),
                                          const SizedBox(
                                              height: 4,
                                            ),
                                            ClipRRect(
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(10)),
                                              child: Container(
                                                height: 240,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration:const BoxDecoration(
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
                                            'Banner',
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
                                                      const EdgeInsets.all(8),
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
                                stream: _eventBloc.outName,
                                onChanged: _eventBloc.changeName,
                                minLines: 1,
                                maxLines: 1),
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
                                maxLines: 1),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Text(_dateTimeStart.toString()),
                                Column(
                                  children: [
                                    const Text(
                                      "Data Inicial",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          color: Colors.black54),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          100,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              primary: Colors.amberAccent,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 40,
                                                      vertical: 15),
                                              textStyle: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          40))),
                                          onPressed: () {
                                            _selectDateTimeStart(context);
                                            _dateTimeStartPicked = true;
                                          },
                                          child: _dateTimeStartPicked
                                              ? Text(
                                                DateFormat(
                                                        "dd/MM/yyyy - HH:mm")
                                                    .format(_dateTimeStart),
                                                style:
                                                const TextStyle(fontSize: 22),
                                              )
                                              : const Icon(
                                                Icons.event_available,
                                                size: 40,
                                              ) // Icon(Icons.event_available),
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                      "Data Final",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                          color: Colors.black54),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          100,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              primary: Colors.amberAccent,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 40,
                                                      vertical: 15),
                                              textStyle: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          40))),
                                          onPressed: () {
                                            _selectDateTimeEnd(context);
                                            _dateTimeEndPicked = true;
                                          },
                                          child: _dateTimeEndPicked
                                              ? Container(
                                                  child: Text(
                                                    DateFormat(
                                                            "dd/MM/yyyy - HH:mm")
                                                        .format(_dateTimeEnd),
                                                    style:
                                                        TextStyle(fontSize: 22),
                                                  ),
                                                )
                                              : const Icon(
                                                Icons.event_available,
                                                size: 40,
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
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40))),
                                  onPressed: snapshot.hasData ? submitEvent : null,

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

  Future submitEvent() async {
    if (file != null &&
        _dateTimeStartPicked == true &&
        _dateTimeEndPicked == true) {
      ReportMessage reportMessage = await _eventBloc.uploadEvent(
          file!, _dateTimeStart, _dateTimeEnd) ;
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
          infoText: 'Preencha todos os campos',
        ),
      );
    }
  }

}
