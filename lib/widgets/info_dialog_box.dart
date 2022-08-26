import 'package:flutter/material.dart';

class InfoDialogBox extends StatelessWidget {
  String title;
  String infoText;
  InfoDialogBox({Key? key,required this.title, required this.infoText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: AlertDialog(
        title: new Text(title),
        content: new Text(infoText),
        actions: <Widget>[
          ElevatedButton(
            child: new Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
