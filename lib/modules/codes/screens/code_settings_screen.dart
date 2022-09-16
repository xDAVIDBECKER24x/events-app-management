import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app_management/modules/codes/screens/code_add_screen.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../widgets/button_add.dart';
import '../widgets/code_card_widget.dart';


class CodesSettingsScreen extends StatefulWidget {
  const CodesSettingsScreen({Key? key}) : super(key: key);

  @override
  State<CodesSettingsScreen> createState() => _CodesSettingsScreenState();
}

class _CodesSettingsScreenState extends State<CodesSettingsScreen> {

  final String data = "https://www.google.com/";

  Future _loadCodes() async {
    final ref = await FirebaseFirestore.instance
        .collection("codes")
        .where("idUser", isEqualTo: currentUID).get();

    final codes = ref.docs.map((doc) => doc.data()).toList();

    return codes;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) =>
          [
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
          body: CustomScrollView(slivers: [
            SliverToBoxAdapter(
                child: ButtonAdd(
                  widget: CodeAddScreen(),
                )),
            FutureBuilder(
                future: _loadCodes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final codes = snapshot.data as List;
                    return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount: codes.length,
                              (BuildContext context, int index) {
                            final Map<String, dynamic> code = codes[index];
                            return Container(
                                padding: EdgeInsets.all(8),
                                child: CodeCard(code: code)
                            );
                          },
                        ));
                  }
                  return SliverToBoxAdapter(
                      child: Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height - 300,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ));
                })
          ])),
    );
  }
}
