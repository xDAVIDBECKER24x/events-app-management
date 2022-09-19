
import 'package:events_app_management/widgets/logout_dialog.dart';
import 'package:events_app_management/widgets/settings_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/navigation_bar_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => LogoutDialog(context),
    )) ?? false;
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: NavigationBarScreen()
    );
  }
}


