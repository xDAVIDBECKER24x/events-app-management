import 'package:flutter/material.dart';

class LogsSettingsScreen extends StatefulWidget {
  const LogsSettingsScreen({Key? key}) : super(key: key);

  @override
  State<LogsSettingsScreen> createState() => _LogsSettingsScreenState();
}

class _LogsSettingsScreenState extends State<LogsSettingsScreen> {
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
                  "Logs",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: Colors.black),
                ),
                actions: [])
          ],
          body: CustomScrollView(slivers: [
          ])),
    );
  }
}
