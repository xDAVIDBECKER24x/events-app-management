import 'dart:core';
import 'package:events_app_management/modules/codes/screens/code_edit_screen.dart';
import 'package:events_app_management/modules/codes/screens/code_settings_screen.dart';
import 'package:events_app_management/widgets/button_add.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:ticket_material/ticket_material.dart';
import '../modules/codes/screens/code_add_screen.dart';

class CodesList extends StatelessWidget {
  final AsyncSnapshot<Object?> snapshot;

  CodesList({
    Key? key,
    required this.snapshot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final codes = snapshot.data as List;
    return Container(
      margin: EdgeInsets.only(bottom: 46),
      padding: EdgeInsets.all(12),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ButtonAdd(
              widget: CodeAddScreen(),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            childCount: codes.length,
            (BuildContext context, int index) {
              final Map<String, dynamic> code = codes[index];
              return Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: TicketMaterial(
                  radiusBorder: 8,
                  height: 150,
                  colorBackground: Colors.white70,
                  leftChild: GestureDetector(
                    onTap: () =>showModalBottomSheet(
                      isScrollControlled:true,
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      builder: (context) => CodeEditScreen(code: code),
                    ),
                    onLongPress: () {
                      print('longPress');
                    },
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.amberAccent, spreadRadius: 4),
                            ],
                          ),
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              code['downloadUrl'],
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        //Text(code['name']),
                      ],
                    ),
                  ),
                  rightChild:  Container(
                    child: PrettyQr(
                      typeNumber: 3,
                      size: 200,
                      data:  code['name'] ,
                      errorCorrectLevel: QrErrorCorrectLevel.M,
                      roundEdges: true,
                    ),
                  ),
                ),
              );
            },
          ))
        ],
      ),
    );
  }
}
