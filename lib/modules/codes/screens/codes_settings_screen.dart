import 'package:events_app_management/modules/codes/screens/scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../widgets/info_dialog_box.dart';

class CodesSettingsScreen extends StatefulWidget {
  const CodesSettingsScreen({Key? key}) : super(key: key);

  @override
  State<CodesSettingsScreen> createState() => _CodesSettingsScreenState();
}

class _CodesSettingsScreenState extends State<CodesSettingsScreen> {

  final String data = "https://www.google.com/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.grey,
                size: 30,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              "Cupons",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Colors.black),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.info_outline,
                  color: Colors.grey,
                  size: 30,
                ),
                onPressed: () {
                  openInfoDialog(context);
                },
              )
            ],
          )
        ],
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Código gerado com o texto:\n $data",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 16,),
                    Container(
                      width: 250,
                      height: 250,
                      child: Center(
                        child: QrImage(
                          data: data,
                          gapless: true,
                          errorCorrectionLevel: QrErrorCorrectLevel.H,
                        ),
                      ),
                    )
                   ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InfoDialogBox(
            title:"Tela de Cupons",
            infoText : "Nesta tela o administrador , definirá os cupons promocionais"
        );
      },
    );
  }

}
