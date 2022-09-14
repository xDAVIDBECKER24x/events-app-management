import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app_management/modules/codes/screens/code_add_screen.dart';
import 'package:events_app_management/modules/codes/screens/code_scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../constants.dart';
import '../../../widgets/button_add.dart';
import '../../../widgets/codes_list.dart';


class CodesSettingsScreen extends StatefulWidget {
  const CodesSettingsScreen({Key? key}) : super(key: key);

  @override
  State<CodesSettingsScreen> createState() => _CodesSettingsScreenState();
}

class _CodesSettingsScreenState extends State<CodesSettingsScreen> {

  final String data = "https://www.google.com/";

  Future _loadCodes() async {
    print(currentUID);

    final ref = await FirebaseFirestore.instance
        .collection("users")
        .doc("${currentUID}")
        .collection('codes')
        .get();

    final codes = ref.docs.map((doc) => doc.data()).toList();

    print(codes);
    print(codes.runtimeType);
    return codes;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : NestedScrollView(
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
                actions: [])
          ],
          body: FutureBuilder(
            future: _loadCodes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CodesList(snapshot: snapshot);
              }
              return Container(
                margin: EdgeInsets.only(bottom: 46),
                padding: EdgeInsets.all(12),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: CustomScrollView(slivers: [
                  SliverToBoxAdapter(
                      child: ButtonAdd(widget: CodeAddScreen(),)
                  ),
                  SliverToBoxAdapter(
                      child: Container(
                        height: MediaQuery.of(context).size.height - 300,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ))
                ]),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QrcodeScanScreen()),
            );
            print('snac');
          },
          backgroundColor: Colors.amber,
          child: const Icon(
            Icons.qr_code,
            size: 36,
          ),
        ),
    );
  }

  // _buildCodesView() {
  //   return Center(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         SizedBox(height: 32,),
  //         Text('Example QR CODE'),
  //         Container(
  //           height: 300,
  //           width: 300,
  //           child: QrImage(
  //             data: data,
  //             gapless: true,
  //             errorCorrectionLevel: QrErrorCorrectLevel.H,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
