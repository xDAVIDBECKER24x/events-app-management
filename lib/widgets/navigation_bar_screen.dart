import 'package:events_app_management/modules/codes/screens/code_scan_screen.dart';
import 'package:events_app_management/modules/codes/screens/code_settings_screen.dart';
import 'package:events_app_management/modules/events/screens/event_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../modules/settings/screens/settings_screen.dart';



class NavigationBarScreen extends StatefulWidget {
  const NavigationBarScreen({Key? key}) : super(key: key);

  @override
  _NavigationBarScreenState createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen> {
  int _index = 1;

  final List<AppBar> _appbars = [
    AppBar(),
    AppBar(),
    AppBar(),
  ];


  final List<Widget> _screens = const [
    CodesSettingsScreen(),
    EventsSettingsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: _appbars[_index],
      body: _screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner),
            label: ''
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.airplane_ticket),
              label: ''
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: ''
          ),
        ],
      ),
      floatingActionButton: _index == 0 ? FloatingActionButton(
          backgroundColor: Colors.amber,
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QrcodeScanScreen()),
            );
        },
          child:  const Icon(Icons.qr_code,size: 34,)
      ) : null
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _index = index;
    });
  }
}
