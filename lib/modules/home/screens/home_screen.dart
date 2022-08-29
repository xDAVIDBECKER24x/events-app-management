import 'package:events_app_management/models/settings_model.dart';
import 'package:events_app_management/modules/login/screens/login_screen.dart';
import 'package:events_app_management/widgets/settings_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {





  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop(context),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body  : Container(
          color: Colors.white70,
          child: Column(
            children: [
              // Padding(
              //   padding:  EdgeInsets.all(15),
              //   child: Text(
              //     'Gerenciar',
              //     style: TextStyle(
              //       fontSize: 22,
              //       fontWeight: FontWeight.bold
              //     ),
              //   ),
              // ),
              SettingsTile(),
            ]
          ),
        ),
      ),
    );
  }
}

Future<bool> onWillPop(context) async {
  return (await showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      title: new Text('Deslogar ?'),
      content: new Text('Vc quer sair da conta?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: new Text('Não'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: new Text('Sair'),
        ),
      ],
    ),
  )) ?? false;
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
                        fontSize: 26,
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
      ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.white
          ),
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          child: Icon(
            Icons.exit_to_app,
            color: Colors.grey,
            size: 34,
          ),
        ),
      )
    ],
  );
}
