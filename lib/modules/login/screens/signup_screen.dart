import 'dart:async';
import 'dart:math';

import 'package:events_app_management/models/account_message.dart';
import 'package:events_app_management/modules/home/screens/home_screen.dart';
import 'package:events_app_management/modules/login/blocs/login_bloc.dart';
import 'package:events_app_management/modules/login/blocs/signup_bloc.dart';
import 'package:events_app_management/modules/login/screens/login_screen.dart';
import 'package:events_app_management/modules/welcome/screens/welcome_screen.dart';
import 'package:events_app_management/widgets/input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../components/background_images.dart';
import '../../../responsive.dart';
import '../../../widgets/info_dialog_box.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _signUpBloc = SignUpBloc();
  int currentStep = 0;
  bool isEmailVerified = false;
  Timer? timer;
  User? user = FirebaseAuth.instance.currentUser;

  late String email ='';
  late String password ='';
  late String passwordConfirm ='';



  @override
  void initState() {
    super.initState();

    isEmailVerified ? isEmailVerified = user!.emailVerified : isEmailVerified = false;

    if(!isEmailVerified){
      timer = Timer.periodic(Duration(seconds: 3), (timer) {
        checkEmailVerified();
      });
      
    }

    _signUpBloc.outState.listen((state) {
      switch (state) {
        case SignUpState.SUCCESS:
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginScreen()));
          break;
        case SignUpState.FAIL:
          showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                    title: Text("Erro"),
                    content: Text("Erro ao criar conta"),
                  ));
          break;
        case SignUpState.LOADING:
        case SignUpState.IDLE:
      }
    });
  }

  @override
  void dispose() {
    _signUpBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Responsive(
        mobile: StreamBuilder<SignUpState>(
            stream: _signUpBloc.outState,
            initialData: SignUpState.LOADING,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data) {
                  case SignUpState.LOADING:
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.amber),
                      ),
                    );
                  case SignUpState.FAIL:
                  case SignUpState.SUCCESS:
                  case SignUpState.IDLE:
                    return Theme(
                      data: ThemeData(
                          canvasColor: Colors.transparent,
                          colorScheme: Theme.of(context)
                              .colorScheme
                              .copyWith(primary: Colors.amber)),
                      child: Stepper(
                        elevation: 0,
                        type: StepperType.horizontal,
                        currentStep: currentStep,
                        steps: getSteps(),
                        onStepContinue: () async {
                          final isLastStep = currentStep == getSteps().length - 1;
                          if (isLastStep) {
                            print('Finalizado');

                          }
                          setState(() {
                            currentStep = currentStep + 1;
                          });


                          if(currentStep == 1){
                            print('Criar Conta');
                            AccountMessage accountMessage = await _signUpBloc.signUp();
                            print('-------------------');
                            print(accountMessage.message);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return  InfoDialogBox(title:'',infoText: accountMessage.message,);
                              },
                            );
                            if(accountMessage.code != 0){
                              setState(() {
                                currentStep = 0;
                              });
                            }

                          }

                          if(currentStep == 2){
                            print('Finalizar Conta');

                          }

                          print(currentStep);
                        },
                        onStepCancel: () {
                          if(currentStep == 0){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                            );
                          }else{
                            setState(() {
                              currentStep = currentStep-1;
                            });
                          }
                          print(currentStep);
                        },
                        controlsBuilder:
                            (BuildContext context, ControlsDetails controls) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: StreamBuilder<bool>(
                                  stream: _signUpBloc.outSubmitValidAccount,
                                  builder: (context, snapshot) {
                                    return ElevatedButton(
                                      onPressed: controls.onStepCancel,
                                      child: const Icon(
                                          Icons.arrow_back_sharp,
                                          size: 32
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          primary: Colors.grey,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 40, vertical: 15),
                                          textStyle: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(40))),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: StreamBuilder<bool>(
                                  stream:   _signUpBloc.outSubmitValidAccount,
                                  builder: (context, snapshot) {
                                    return ElevatedButton(
                                      onPressed: snapshot.hasData ?  controls.onStepContinue : null,
                                      child: const Icon(
                                          Icons.check,
                                          size: 32
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          primary: Colors.amberAccent,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 40, vertical: 15),
                                          textStyle: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(40))),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                }
              }
              return CircularProgressIndicator();
            }),
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
    );
  }

  Dialog alertDialog(String text) {
    return Dialog(
      backgroundColor: Colors.white70,
      child: AlertDialog(
        title: Text(text),
      ),
    );
  }

  Dialog loadingDialog(){
    return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
        height: 80.0,
        width: 80,
        alignment: FractionalOffset.center,
        child: CircularProgressIndicator()
      ),
    );

  }

  Future checkEmailVerified() async{
    await user?.reload();
    setState(() async {
      isEmailVerified = await _signUpBloc.checkEmailVerified();
    });
    if(isEmailVerified) timer?.cancel();
  }

  List<Step> getSteps() {
    return [
      Step(
        isActive: currentStep >= 0,
        title: Text('Conta'),
        content: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InputField(
                  label: 'Email',
                  icon: Icons.email,
                  hint: "Email",
                  obscure: false,
                  stream: _signUpBloc.outEmail,
                  onChanged: _signUpBloc.changeEmail,
                ),
                SizedBox(
                  height: 20,
                ),
                InputField(
                  label: 'Senha',
                  icon: Icons.lock_outline,
                  hint: "Senha",
                  obscure: true,
                  stream: _signUpBloc.outPassword,
                  onChanged: _signUpBloc.changePassword,
                ),
                SizedBox(
                  height: 20,
                ),
                InputField(
                  label: 'Confirmar Senha',
                  icon: Icons.lock_outline,
                  hint: "Confirmar Senha",
                  obscure: true,
                  stream: _signUpBloc.outConfirmPassword,
                  onChanged: _signUpBloc.changeConfirmPassword,
                ),
              ],
            ),
          ),
        ),
      ),
      Step(
        isActive: currentStep >= 1,
        title: Text('Dados'),
        content: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InputField(
                  label: '',
                  icon: Icons.email,
                  hint: "Email",
                  obscure: false,
                  stream: _signUpBloc.outEmail,
                  onChanged: _signUpBloc.changeEmail,
                ),
                SizedBox(
                  height: 20,
                ),
                InputField(
                  label: '',
                  icon: Icons.lock_outline,
                  hint: "Senha",
                  obscure: true,
                  stream: _signUpBloc.outPassword,
                  onChanged: _signUpBloc.changePassword,

                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
      // Step(
      //   isActive: currentStep >= 1,
      //   title: Text('Email'),
      //   content: SingleChildScrollView(
      //     child: Padding(
      //       padding: const EdgeInsets.all(16.0),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.stretch,
      //         children: [
      //           InputField(
      //             icon: Icons.email,
      //             hint: "Email",
      //             obscure: false,
      //             stream: _signUpBloc.outEmail,
      //             onChanged: _signUpBloc.changeEmail,
      //           ),
      //           SizedBox(
      //             height: 20,
      //           ),
      //           InputField(
      //             icon: Icons.person_outline,
      //             hint: "Usuário",
      //             obscure: false,
      //             stream: _signUpBloc.outEmail,
      //             onChanged: _signUpBloc.changeEmail,
      //           ),
      //           SizedBox(
      //             height: 20,
      //           ),
      //           InputField(
      //             icon: Icons.location_city,
      //             hint: "CNPJ",
      //             obscure: true,
      //             stream: _signUpBloc.outPassword,
      //             onChanged: _signUpBloc.changePassword,
      //           ),
      //           SizedBox(
      //             height: 20,
      //           ),
      //           InputField(
      //             icon: Icons.lock_outline,
      //             hint: "Senha",
      //             obscure: true,
      //             stream: _signUpBloc.outPassword,
      //             onChanged: _signUpBloc.changePassword,
      //           ),
      //           SizedBox(
      //             height: 20,
      //           ),
      //           InputField(
      //             icon: Icons.lock_outline,
      //             hint: "Confirmar Senha",
      //             obscure: true,
      //             stream: _signUpBloc.outPassword,
      //             onChanged: _signUpBloc.changePassword,
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
      // Step(
      //   isActive: currentStep >= 2,
      //   title: Text('Dados'),
      //   content: SingldeChildScrollView(
      //     child: Padding(
      //       padding: const EdgeInsets.all(16.0),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.stretch,
      //         children: [
      //           InputField(
      //             icon: Icons.email,
      //             hint: "Email",
      //             obscure: false,
      //             stream: _signUpBloc.outEmail,
      //             onChanged: _signUpBloc.changeEmail,
      //           ),
      //           SizedBox(
      //             height: 20,
      //           ),
      //           InputField(
      //             icon: Icons.person_outline,
      //             hint: "Usuário",
      //             obscure: false,
      //             stream: _signUpBloc.outEmail,
      //             onChanged: _signUpBloc.changeEmail,
      //           ),
      //           SizedBox(
      //             height: 20,
      //           ),
      //           InputField(
      //             icon: Icons.location_city,
      //             hint: "CNPJ",
      //             obscure: true,
      //             stream: _signUpBloc.outPassword,
      //             onChanged: _signUpBloc.changePassword,
      //           ),
      //           SizedBox(
      //             height: 20,
      //           ),
      //           InputField(
      //             icon: Icons.lock_outline,
      //             hint: "Senha",
      //             obscure: true,
      //             stream: _signUpBloc.outPassword,
      //             onChanged: _signUpBloc.changePassword,
      //           ),
      //           SizedBox(
      //             height: 20,
      //           ),
      //           InputField(
      //             icon: Icons.lock_outline,
      //             hint: "Confirmar Senha",
      //             obscure: true,
      //             stream: _signUpBloc.outPassword,
      //             onChanged: _signUpBloc.changePassword,
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    ];
  }

}
