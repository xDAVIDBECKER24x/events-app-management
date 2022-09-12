import 'package:events_app_management/modules/welcome/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          showBackButton: false,
          showSkipButton: true,
          skip: const Text("Skip"),
          done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
          onDone: (){
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) =>  WelcomeScreen()));
          },
          pages: [
            PageViewModel(
              image: Image.network('https://cdn2.iconfinder.com/data/icons/dj-1/500/vab833_2_party_dj_isometric_cartoon_music_silhouette_person-512.png'),
              title: 'Aqui vc vai administrar seus eventos com praticidade',
              body: 'is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dumm'
            ),
            PageViewModel(
                image: Image.network('https://img.freepik.com/premium-vector/isometric-style-illustration-about-musicians-performing-music_529804-318.jpg?w=2000'),
                title: 'Aqui vc vai administrar seus eventos com praticidade',
                body: 'is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dumm'
            ),
            PageViewModel(
                image: Image.network('https://img.freepik.com/free-vector/content-creator-concept-illustration_114360-3881.jpg?w=360'),
                title: 'Aqui vc vai administrar seus eventos com praticidade',
                body: 'is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dumm'
            )
          ],
        ),
      ),
    );
  }
}
