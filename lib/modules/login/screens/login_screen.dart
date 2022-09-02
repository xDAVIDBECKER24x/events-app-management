import 'package:events_app_management/modules/home/screens/home_screen.dart';
import 'package:events_app_management/modules/login/blocs/login_bloc.dart';
import 'package:events_app_management/modules/login/screens/signup_screen.dart';
import 'package:events_app_management/widgets/input_field.dart';
import 'package:flutter/material.dart';

import '../../../components/background_images.dart';
import '../../../responsive.dart';
import '../components/login_image.dart';

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
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: StreamBuilder<LoginState>(
              stream: _loginBloc.outState,
              initialData: LoginState.LOADING,
              builder: (context,snapshot) {
                if(snapshot.hasData){
                  switch(snapshot.data) {
                    case LoginState.LOADING:
                      return const Center(child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.amberAccent),),);
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
                                const LoginImage(),
                                InputField(
                                  label: 'Usuário',
                                  icon: Icons.person_outline,
                                  hint: "Usuário",
                                  obscure: false,
                                  stream: _loginBloc.outEmail,
                                  onChanged: _loginBloc.changeEmail,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                InputField(
                                  label: 'Senha',
                                  icon: Icons.lock_outline,
                                  hint: "Senha",
                                  obscure: true,
                                  stream: _loginBloc.outPassword,
                                  onChanged: _loginBloc.changePassword,
                                ),
                                const  SizedBox(
                                  height: 12,
                                ),
                                StreamBuilder<bool>(
                                  stream: _loginBloc.outSubmitValid,
                                  builder: (context, snapshot) {
                                    return ElevatedButton(
                                      onPressed:
                                      snapshot.hasData ? _loginBloc.submit : null,
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          primary: Colors.amberAccent,
                                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                          textStyle: const TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold
                                          ),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(40)
                                          )
                                      ),
                                      child: const Text(
                                        "Login",
                                      ),
                                    );
                                  },
                                ),
                                const  SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const  Text(
                                      "Não possui conta? ",
                                      style: TextStyle(
                                          color: Colors.blueGrey
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return SignUpScreen();
                                            },
                                          ),
                                        );
                                      },
                                      child:const  Text(
                                        'Sign Up',
                                        style: TextStyle(
                                            color: Colors.amber,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                  }
                }
                return const Center(child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.amberAccent),),);
              }
          ),
          desktop: Row(
            children: [
              const Expanded(
                child: LoginImage(),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      width: 450,
                      child: CircularProgressIndicator(),
                      // child: LoginForm(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}