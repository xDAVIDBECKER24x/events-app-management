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

