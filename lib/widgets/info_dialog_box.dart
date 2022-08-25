import 'package:flutter/material.dart';

class InfoDialogBox extends StatelessWidget {
  String infoText;
  InfoDialogBox({Key? key, required this.infoText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Tela de Midias'),
      content: Text(
          infoText
        ),
      actions: [
        ElevatedButton(
          child: Icon(Icons.check),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
