import 'package:events_app_management/modules/events/screens/event_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../../widgets/confirm_dialog_box.dart';
import '../../../utils/date_utils.dart';

class EventCard extends StatelessWidget {
  const EventCard({Key? key, required this.event}) : super(key: key);
  final Map<String, dynamic>  event;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Column(
        children: [
          ListTile(
            visualDensity: VisualDensity(vertical: -2),
            title: Container(
              padding: EdgeInsets.all(4),
              alignment: Alignment.center,
              child: Text(
                event['name'],
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            subtitle: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.timer,
                    size: 16,
                  ),
                  Text(
                      '${timestampToDateFormatted(event['dateStart'])} ${timestampToTimeFormatted(event['dateStart'])}'),
                ],
              ),
            ),
            trailing: PopupMenuButton<String>(
                onSelected: (item) => onSelect(context, item, event),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: 'delete',
                      child: Text("Excluir"),
                    ),
                    PopupMenuItem(
                      value: 'close',
                      child: Text("Encerrar"),
                    )
                  ];
                }),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EventEditScreen(event: event)),
              );
            },
            child: Container(
              child: FadeInImage.memoryNetwork(
                height: 240,
                width: MediaQuery.of(context).size.width,
                placeholder: kTransparentImage,
                image: event['downloadUrl'],
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
  onSelect(BuildContext context, String item,Map<String, dynamic> event) async {
    bool action;

    switch (item) {
      case 'delete':
        action = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return ConfirmDialogBox(
              title: "Excluir evento",
              infoText: 'Tem certeza que deseja excluir evento ${event["name"]}',
            );
          },
        );
        if(action == true){

        }
        print(action);
        break;
      case 'close':
        print('Foi');
        break;

    }
  }

}
