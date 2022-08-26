
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/info_dialog_box.dart';

class GeralSettingsScreen extends StatefulWidget {
  const GeralSettingsScreen({Key? key}) : super(key: key);

  @override
  State<GeralSettingsScreen> createState() => _GeralSettingsScreenState();
}

class _GeralSettingsScreenState extends State<GeralSettingsScreen> {
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
              "Geral",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Colors.black),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.info_outline,
                  color: Colors.grey,
                  size: 30,
                ),
                onPressed: () {
                  openInfoDialog(context);
                },
              )
            ],
          )
        ],
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(   ),
            ),
          ],
        ),
      ),
    );
  }

  void openInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InfoDialogBox(
            title:"Tela de Configurações Gerais",
            infoText : "Nesta tela o administrador , definirá as informaçoes gerais que aparecerão no applicativo"
        );
      },
    );
  }

}

