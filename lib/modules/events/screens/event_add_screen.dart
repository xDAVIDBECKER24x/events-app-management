import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../widgets/input_field.dart';
import '../bloc/event_bloc.dart';

class EventAddScreen extends StatefulWidget {
  const EventAddScreen({Key? key}) : super(key: key);

  @override
  State<EventAddScreen> createState() => _EventAddScreenState();
}

class _EventAddScreenState extends State<EventAddScreen> {
  final _eventBloc = EventBloc();

  DateTime dateTimeStart = DateTime.now();
  DateTime dateTimeEnd = DateTime.now();
  @override
  Widget build(BuildContext context) {

    return Container(
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InputField(
                  label: 'Nome',
                  icon: Icons.festival,
                  hint: "Nome",
                  obscure: false,
                  stream: _eventBloc.outName,
                  onChanged: _eventBloc.changeName,
                ),
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
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  child: Row(
                    children: [
                      ElevatedButton(
                          onPressed: (){
                            dateTimeStart = pickDateTime() as DateTime;
                          },
                          child: Text(DateFormat('MM-dd-yyyy HH:mm').format(dateTimeStart))
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      ElevatedButton(
                          onPressed: (){
                            dateTimeEnd = pickDateTime() as DateTime;
                          },
                          child: Text(DateFormat('MM-dd-yyyy HH:mm').format(dateTimeEnd))
                      )
                      ],
                  ),
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
                ),
                const SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Colors.amberAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      textStyle: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40))),
                  onPressed: () {print(dateTimeStart);},
                  child: const Text(
                    "Adicionar",
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future pickDateTime() async {
    DateTime currentDateTime = DateTime.now();
    DateTime? date = await pickDate(currentDateTime);
    if(date == null ) return;

    TimeOfDay? time = await pickTime(currentDateTime);
    if(time == null ) return;

    return  DateTime(
      time.hour,
      time.minute,
      date.day,
      date.month,
      date.year
    );
  }

  Future<DateTime?> pickDate(DateTime dateTime) => showDatePicker(
      context: context, initialDate: dateTime, firstDate: DateTime(2022), lastDate: DateTime(2100)
  );

  Future<TimeOfDay?> pickTime(DateTime dateTime) => showTimePicker(
      context: context, initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute)
  );

}
