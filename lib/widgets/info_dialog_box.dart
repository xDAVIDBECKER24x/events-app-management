import 'package:flutter/material.dart';

class InfoDialogBox extends StatelessWidget {
  String? title;
  String? infoText;
  InfoDialogBox({Key? key,required this.title, required this.infoText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title!),
      content:  Text(
        infoText!,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Icon(Icons.check),
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: Colors.amberAccent,
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              textStyle: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)
              )
          ),
        ),
      ],
    );
  }
}
