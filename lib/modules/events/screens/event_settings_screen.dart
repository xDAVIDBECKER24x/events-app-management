import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app_management/modules/events/widgets/event_card_widget.dart';
import 'package:events_app_management/widgets/button_add.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../widgets/confirm_dialog_box.dart';
import 'event_add_screen.dart';
import 'dart:core';


class EventsSettingsScreen extends StatefulWidget {
  const EventsSettingsScreen({Key? key}) : super(key: key);

  @override
  State<EventsSettingsScreen> createState() => _EventsSettingsScreenState();
}

class _EventsSettingsScreenState extends State<EventsSettingsScreen> {
  Future _loadEvents() async {
    print(currentUID);

    final ref = await FirebaseFirestore.instance
        .collection("events")
        .where("idUser", isEqualTo: currentUID)
        .get();

    final events = ref.docs.map((doc) => doc.data()).toList();

    return events;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                    pinned: true,
                    snap: false,
                    floating: false,
                    centerTitle: true,
                    elevation: 0,
                    backgroundColor: Colors.white,
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                        size: 30,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    title: Text(
                      "Eventos",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          color: Colors.black),
                    ),
                    actions: [])
              ],
          body: CustomScrollView(slivers: [
            SliverToBoxAdapter(
                child: ButtonAdd(
              widget: EventAddScreen(),
            )),
            FutureBuilder(
                future: _loadEvents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final events = snapshot.data as List;
                    return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount: events.length,
                              (BuildContext context, int index) {
                            final Map<String, dynamic> event = events[index];
                            return Container(
                              padding: EdgeInsets.all(8),
                              child: EventCard(event: event)
                            );
                          },
                        ));
                  }
                  return SliverToBoxAdapter(
                      child: Container(
                    height: MediaQuery.of(context).size.height - 300,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ));
                })
          ])),
    );
  }
  
}
