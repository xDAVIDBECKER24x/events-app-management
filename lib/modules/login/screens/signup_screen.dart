import 'package:events_app_management/modules/home/screens/home_screen.dart';
import 'package:events_app_management/modules/login/blocs/login_bloc.dart';
import 'package:events_app_management/widgets/input_field.dart';
import 'package:flutter/material.dart';

import '../../../components/background_images.dart';
import '../../../responsive.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

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
                                InputField(
                                  icon: Icons.email,
                                  hint: "Email",
                                  obscure: false,
                                  stream: _loginBloc.outEmail,
                                  onChanged: _loginBloc.changeEmail,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                InputField(
                                  icon: Icons.person_outline,
                                  hint: "Usuário",
                                  obscure: false,
                                  stream: _loginBloc.outEmail,
                                  onChanged: _loginBloc.changeEmail,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                InputField(
                                  icon: Icons.location_city,
                                  hint: "CNPJ",
                                  obscure: true,
                                  stream: _loginBloc.outPassword,
                                  onChanged: _loginBloc.changePassword,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                InputField(
                                  icon: Icons.lock_outline,
                                  hint: "Senha",
                                  obscure: true,
                                  stream: _loginBloc.outPassword,
                                  onChanged: _loginBloc.changePassword,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                InputField(
                                  icon: Icons.lock_outline,
                                  hint: "Confirmar Senha",
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
                                          "Criar Conta",
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.amberAccent,
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
          desktop: Row(
            children: [
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
