import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app_management/modules/events/bloc/event_settings_bloc.dart';
import 'package:events_app_management/modules/events/widgets/event_card_widget.dart';
import 'package:events_app_management/widgets/button_add.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../../constants.dart';
import '../../../utils/date_utils.dart';
import '../../../widgets/confirm_dialog_box.dart';
import 'event_add_screen.dart';
import 'dart:core';

import 'event_edit_screen.dart';

class EventsSettingsScreen extends StatefulWidget {
  const EventsSettingsScreen({Key? key}) : super(key: key);

  @override
  State<EventsSettingsScreen> createState() => _EventsSettingsScreenState();
}

class _EventsSettingsScreenState extends State<EventsSettingsScreen> {
  final _eventSettingsBloc = EventSettingsBloc();

  Future _loadEvents() async {
    print(currentUID);

    final ref = await FirebaseFirestore.instance
        .collection("events")
        .where("idUser", isEqualTo: currentUID)
        .get();

    final _eventsList =
        ref.docs.map((doc) => {'id': doc.id, 'data': doc.data()}).toList();

    return _eventsList;
  }

  @override
  void initState() {
    super.initState();

    _eventSettingsBloc.outState.listen((state) {
      switch (state) {
        case EventSettingsState.SUCCESS:
        case EventSettingsState.FAIL:
        case EventSettingsState.LOADING:
        case EventSettingsState.IDLE:
      }
    });
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
            StreamBuilder(
                stream: _eventSettingsBloc.outState,
                initialData: EventSettingsState.LOADING,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data) {
                      case EventSettingsState.LOADING:
                        return SliverToBoxAdapter(
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(Colors.amberAccent),
                            ),
                          ),
                        );
                      case EventSettingsState.FAIL:
                      case EventSettingsState.SUCCESS:
                      case EventSettingsState.IDLE:
                        return FutureBuilder(
                            future: _loadEvents(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                final events = snapshot.data as List;
                                return SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                  childCount: events.length,
                                  (BuildContext context, int index) {
                                    final Map<String, dynamic> event =
                                        events[index];
                                    return Container(
                                        padding: EdgeInsets.all(8),
                                        child: Card(
                                          elevation: 3,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 4),
                                                    child: Text(
                                                      event['data']['name'],
                                                      style: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                              onPressed: () {},
                                                              icon: Icon(
                                                                  Icons.share)),
                                                          IconButton(
                                                              onPressed: () {
                                                                _deleteEvent(
                                                                    event);
                                                              },
                                                              icon: Icon(Icons
                                                                  .delete)),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EventEditScreen(
                                                                event: event)),
                                                  );
                                                },
                                                child: Container(
                                                  child:
                                                      FadeInImage.memoryNetwork(
                                                    height: 240,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    placeholder:
                                                        kTransparentImage,
                                                    image: event['data']
                                                        ['downloadUrl'],
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(4),
                                                child: Row(
                                                  children: [
                                                    Column(children: [
                                                      Row(
                                                        children: [
                                                          Icon(Icons
                                                              .pin_drop_rounded),
                                                          Text(
                                                            event['data']
                                                                ['address'],
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black87,
                                                              fontSize: 20.0,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ]),
                                                    Spacer(),
                                                    Column(
                                                      children: [],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ));
                                  },
                                ));
                              }
                              return SliverToBoxAdapter(
                                  child: Container(
                                height:
                                    MediaQuery.of(context).size.height - 300,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ));
                            });
                    }
                  }
                  return SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.amberAccent),
                      ),
                    ),
                  );
                })
          ])),
    );
  }

  _deleteEvent(Map<String, dynamic> event) {
    print(event);
  _eventSettingsBloc.deleteEvent(event);
  }
}
