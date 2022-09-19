import 'package:events_app_management/modules/codes/screens/code_scan_screen.dart';
import 'package:events_app_management/modules/codes/screens/code_settings_screen.dart';
import 'package:events_app_management/modules/events/screens/event_settings_screen.dart';
import 'package:flutter/material.dart';

import '../modules/settings/screens/settings_screen.dart';



class NavigationBarScreen extends StatefulWidget {
  @override
  _NavigationBarScreenState createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen> {
  int _index = 0;

  final List<AppBar> _appbars = [
    AppBar(),
    AppBar(),
    AppBar(),
  ];


  final List<Widget> _screens = [
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
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
            label: ''
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket),
              label: ''
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: ''
          ),
        ],
      ),
      floatingActionButton: _index == 0 ? FloatingActionButton(
          child: const Icon(Icons.qr_code,size: 34,),
          backgroundColor: Colors.amber,
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QrcodeScanScreen()),
            );
        }
      ) : null
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _index = index;
    });
  }
}

AppBar _buildAppBar(context){
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.white,
    title: Row(
      children: [
        Container(
          height: 45 ,
          width: 45,
          child :ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset('assets/images/teste_image.png',fit: BoxFit.fill,),
          ),
        ),
        SizedBox(width: 10,),
        Flexible(
          child: RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
                children: [
                  TextSpan(
                    text: "Bem vindo de Volta!",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  TextSpan(
                    text: "Burguinhosss sssss",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ]
            ),
          ),
        ),
      ],
    ) ,
    actions: [
    ],
  );
}