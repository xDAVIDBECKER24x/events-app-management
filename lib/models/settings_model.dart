import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Settings{
  Color? bgColor;
  Color? iconColor;
  Color? btnColor;
  IconData? icon;
  String? title;



  Settings({required this.bgColor,required this.iconColor,required this.btnColor,required this.icon, required this.title});


  static List<Settings> generateSettings(){
    return [
      Settings(
          bgColor: Colors.white,
          iconColor: Colors.blueGrey,
          btnColor: Colors.white,
          icon: Icons.settings,
          title: 'Configs'
      ),
      // Settings(
      //     bgColor: Colors.white,
      //     iconColor: Colors.grey,
      //     btnColor: Colors.white,
      //     icon: Icons.photo,
      //     title: 'Midias'
      // ),
      Settings(
          bgColor: Colors.white,
          iconColor: Colors.blueGrey,
          btnColor: Colors.white,
          icon: Icons.event_available,
          title: 'Eventos'
      ),
      Settings(
          bgColor: Colors.white,
          iconColor: Colors.blueGrey,
          btnColor: Colors.white,
          icon: Icons.qr_code,
          title: 'Cupons'
      ),
      // Settings(
      //     bgColor: Colors.grey,
      //     iconColor: Colors.blueGrey,
      //     btnColor: Colors.grey,
      //     icon: Icons.star_outline,
      //     title: 'Destaques'
      // ),
      // Settings(
      //     bgColor: Colors.grey,
      //     iconColor: Colors.blueGrey,
      //     btnColor: Colors.grey,
      //     icon: Icons.menu_book,
      //     title: 'Cardápio'
      // ),
      // Settings(
      //     bgColor: Colors.grey,
      //     iconColor: Colors.blueGrey,
      //     btnColor: Colors.grey,
      //     icon: Icons.event_available,
      //     title: 'Cardápio'
      // ),
    ];
  }

}