
import 'package:events_app_management/modules/welcome/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog(BuildContext context, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title:  Text('Deslogar'),
        content:  Text('Vc quer sair da conta?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              return Navigator.of(context).pop(false);
            },
            child: Text(
              'Não',
              style:  TextStyle(
                  color: Colors.grey
              ),
            ),
          ),
          TextButton(
            onPressed: (){
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const WelcomeScreen(),
                ),
              );
            },
            child:  Text(
              'Sair',
              style:  TextStyle(
                  color:  Colors.redAccent
              ),
            ),
          ),
        ],
      );
    }
}
