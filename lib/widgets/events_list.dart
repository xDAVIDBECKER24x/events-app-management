import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app_management/constants.dart';
import 'package:events_app_management/widgets/button_add.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../modules/events/screens/event_edit_screen.dart';

class EventsList extends StatelessWidget {
  final AsyncSnapshot<Object?> snapshot;

  EventsList({
    Key? key,
    required this.snapshot,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final events = snapshot.data as List;
    return Container(
      margin: EdgeInsets.only(bottom: 46),
      padding: EdgeInsets.all(12),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ButtonAdd(),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            childCount: events.length,
            (BuildContext context, int index) {
              final Map<String, dynamic> event = events[index];

              return GestureDetector(
                onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  EventEditScreen(url : event['url'],)),
                    );
                 },
                child: Card(
                  elevation: 2,
                  child: Container(
                    child: Row(
                      children: [
                        // ClipRRect(
                        //   borderRadius: BorderRadius.circular(5),
                        //   child: Container(
                        //     child: FadeInImage.memoryNetwork(
                        //       height: 80,
                        //       width: MediaQuery.of(context).size.width / 2.5,
                        //       placeholder: kTransparentImage,
                        //       image: event['banner'],
                        //       fit: BoxFit.fill,
                        //     ),
                        //   ),
                        // ),
                        Container(
                          padding: const EdgeInsets.only(left: 8.0),
                          width: MediaQuery.of(context).size.width / 2,
                          height: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                maxLines: 1,
                                '24 Outubro',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  event['name'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: Text(
                                  'teste',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ))
        ],
      ),
    );
  }
}
