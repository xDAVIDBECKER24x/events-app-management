import 'package:events_app_management/modules/home/screens/home_screen.dart';
import 'package:events_app_management/modules/login/blocs/login_bloc.dart';
import 'package:events_app_management/widgets/input_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _loginBloc = LoginBloc();

  @override
  void initState() {
    super.initState();

    _loginBloc.outState.listen((state){
      switch(state){
        case LoginState.SUCCESS:
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context)=> const HomeScreen())
          );
          break;
        case LoginState.FAIL:
          showDialog(context: context, builder: (context)=>const AlertDialog(
            title: Text("Erro"),
            content: Text("Você não possui os privilégios necessários"),
          ));
          break;
        case LoginState.LOADING:
        case LoginState.IDLE:
      }
    });
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: const Text('Login Plataforma Administrativa'),
      // ),
      backgroundColor: Colors.white,
      body: StreamBuilder<LoginState>(
        stream: _loginBloc.outState,
        initialData: LoginState.LOADING,

        builder: (context,snapshot) {
          if(snapshot.hasData){
            switch(snapshot.data) {
              case LoginState.LOADING:
                return const Center(child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.blueAccent),),);
              case LoginState.FAIL:
              case LoginState.SUCCESS:
              case LoginState.IDLE:
              return Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Container(
                            //   child: Lottie.asset(
                            //       fit: BoxFit.fill,
                            //       "assets/animation/login_party.json",
                            //       frameRate: FrameRate.max),
                            // ),
                            InputField(
                              icon: Icons.person_outline,
                              hint: "Usuário",
                              obscure: false,
                              stream: _loginBloc.outEmail,
                              onChanged: _loginBloc.changeEmail,
                            ),
                            InputField(
                              icon: Icons.lock_outline,
                              hint: "Senha",
                              obscure: true,
                              stream: _loginBloc.outPassword,
                              onChanged: _loginBloc.changePassword,
                            ),
                            Padding(
                              padding:  const EdgeInsets.all(20),
                              child: StreamBuilder<bool>(
                                stream: _loginBloc.outSubmitValid,
                                builder: (context, snapshot) {
                                  return ElevatedButton(
                                    onPressed:
                                    snapshot.hasData ? _loginBloc.submit : null,
                                    child: const Text(
                                      "Login",
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.amber,
                                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                      textStyle: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40)
                                      )
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
              }
          }
          return CircularProgressIndicator();
        }
      ),
    );
  }
}
