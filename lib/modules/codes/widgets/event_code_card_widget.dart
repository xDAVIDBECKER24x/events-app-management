import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../utils/date_utils.dart';
import '../../events/screens/event_edit_screen.dart';


class EventCodeCard extends StatelessWidget {
  const EventCodeCard({Key? key, required this.event}) : super(key: key);
  final Map<String, dynamic> event;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(24))
      ),
      margin: EdgeInsets.symmetric(horizontal: 32),
      padding: EdgeInsets.all(16),
      child: Card(
        elevation: 12,
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
                      Icons.event_available,
                      size: 16,
                    ),
                    Text(
                        '${timestampToDateFormatted(event['dateStart'])} ${timestampToTimeFormatted(event['dateStart'])}'),
                  ],
                ),
              ),
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
                child: Expanded(
                  child: FadeInImage.memoryNetwork(
                    width: MediaQuery.of(context).size.width,
                    height: 160,
                    placeholder: kTransparentImage,
                    image: event['downloadUrl'],
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
