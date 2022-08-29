import 'package:events_app_management/modules/login/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class WelcomeButton extends StatelessWidget {
  const WelcomeButton({Key? key, required this.text,required this.color, required this.route, required this.textColor}) : super(key: key);

  final Widget route;
  final String text;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return route;
              },
            ),
          );
        },
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            color: textColor
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
            primary: color,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            textStyle: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40)
            )
        ),
      ),
    );
  }
}
