import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app_management/widgets/button_add.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../widgets/events_list.dart';
import 'event_add_screen.dart';

class EventsSettingsScreen extends StatefulWidget {
  const EventsSettingsScreen({Key? key}) : super(key: key);

  @override
  State<EventsSettingsScreen> createState() => _EventsSettingsScreenState();
}

class _EventsSettingsScreenState extends State<EventsSettingsScreen> {


  Future _loadEvents() async {
    print(currentUID);

    final ref = await FirebaseFirestore.instance
        .collection("users")
        .doc("${currentUID}")
        .collection('events')
        .where("isActive", isEqualTo: true).get();

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
        body: FutureBuilder(
          future: _loadEvents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return EventsList(snapshot: snapshot);
            }
            return Container(
              margin: EdgeInsets.only(bottom: 46),
              padding: EdgeInsets.all(12),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: CustomScrollView(slivers: [
                SliverToBoxAdapter(
                  child: ButtonAdd(widget: EventAddScreen(),)
                ),
                SliverToBoxAdapter(
                    child: Container(
                  height: MediaQuery.of(context).size.height - 300,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ))
              ]),
            );
          },
        ),
      ),
    );
  }


}
