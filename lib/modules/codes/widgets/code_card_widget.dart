import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:ticket_material/ticket_material.dart';
import '../screens/code_edit_screen.dart';

class CodeCard extends StatelessWidget {
  const CodeCard({Key? key, required this.code}) : super(key: key);
  final Map<String, dynamic>  code;

  @override
  Widget build(BuildContext context) {
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
  }

}
