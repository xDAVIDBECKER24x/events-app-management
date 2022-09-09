import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../utils/date_utils.dart';

class EventEditScreen extends StatelessWidget {
  late Map<String, dynamic> event;

  EventEditScreen({required this.event, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background:  FadeInImage.memoryNetwork(
                width: MediaQuery.of(context).size.width,
                placeholder: kTransparentImage,
                image: event['downloadUrl'],
                fit: BoxFit.cover,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)
                  )
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(8),
                child: Column(
              children: [
                Text(
                  event['name'],
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8,),
                Row(
                  children: [
                    Icon(Icons.event_available),
                    Text(
                      timestampToDateFormatted(event['dateStart']),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4,),
                Row(
                  children: [
                    Icon(Icons.timer),
                    Text(
                      timestampToTimeFormatted(event['dateStart']),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4,),
                Row(
                  children: [
                    Icon(Icons.pin_drop_rounded),
                    Text(
                      event['address'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4,),
                Divider(),
              ],
            )),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum dictum magna nec purus congue, eu tempor tellus tempor. In volutpat nunc dolor, non vestibulum lorem condimentum eu. Pellentesque a arcu lectus. Cras sagittis mollis gravida. Donec et maximus magna. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Praesent pharetra id tortor ac ultrices. Vivamus porta, libero eget ornare bibendum, ligula neque bibendum dolor, at posuere est felis sit amet est.'
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum dictum magna nec purus congue, eu tempor tellus tempor. In volutpat nunc dolor, non vestibulum lorem condimentum eu. Pellentesque a arcu lectus. Cras sagittis mollis gravida. Donec et maximus magna. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Praesent pharetra id tortor ac ultrices. Vivamus porta, libero eget ornare bibendum, ligula neque bibendum dolor, at posuere est felis sit amet est.'

                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum dictum magna nec purus congue, eu tempor tellus tempor. In volutpat nunc dolor, non vestibulum lorem condimentum eu. Pellentesque a arcu lectus. Cras sagittis mollis gravida. Donec et maximus magna. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Praesent pharetra id tortor ac ultrices. Vivamus porta, libero eget ornare bibendum, ligula neque bibendum dolor, at posuere est felis sit amet est.',

                // event['info'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
