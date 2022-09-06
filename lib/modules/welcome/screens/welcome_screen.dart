import 'package:events_app_management/widgets/welcome_button.dart';
import 'package:flutter/material.dart';

import '../../../components/background_images.dart';
import '../../../constants.dart';
import '../../../responsive.dart';
import '../../login/screens/login_screen.dart';
import '../../login/screens/signup_screen.dart';
import '../components/welcome_image.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Responsive(
            desktop: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                 Expanded(
                  child: WelcomeImage(),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        width: 450,
                        child: WebWelcomeScreen(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            mobile: const MobileWelcomeScreen(),
          ),
        ),
      ),
    );
  }
}

class MobileWelcomeScreen extends StatelessWidget {
  const MobileWelcomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const WelcomeImage(),
        Row(
          children:  [
            Spacer(),
            Expanded(
              flex: 8,
              child:  Column(
                children: [
                  WelcomeButton(text: 'Login', color: Colors.amberAccent,route : LoginScreen(), textColor: Colors.white,),
                  const SizedBox(height: 16),
                  WelcomeButton(text: 'Criar Conta', color: kPrimaryLightColor,route : SignUpScreen(), textColor: Colors.grey,),
                ],
              ),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}

class WebWelcomeScreen extends StatelessWidget{
  const WebWelcomeScreen({
    Key? key,
  }) : super(key: key);


  Widget build(BuildContext context){
    return  Column(
      children: [
        WelcomeButton(text: 'Login', color: Colors.amberAccent,route : LoginScreen(), textColor: Colors.white,),
        const SizedBox(height: 16),
        WelcomeButton(text: 'Sign Up', color: kPrimaryLightColor,route : SignUpScreen(), textColor: Colors.grey,),
      ],
    );
  }

}

