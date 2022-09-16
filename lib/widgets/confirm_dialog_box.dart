import 'package:flutter/material.dart';


class ConfirmDialogBox extends StatelessWidget {
  String? title;
  String? infoText;
  ConfirmDialogBox({Key? key,required this.title, required this.infoText}) : super(key: key);

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
          child: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context, false);
          },
          style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: Colors.grey,
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
        ElevatedButton(
          child: Icon(Icons.check),
          onPressed: () {
            Navigator.pop(context, true);
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
