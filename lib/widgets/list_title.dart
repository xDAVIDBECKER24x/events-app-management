import 'package:flutter/material.dart';

class ListTitle extends StatelessWidget {
  final String title;

  const ListTitle({Key? key,required this.title,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16,left: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius:
          BorderRadius.all(Radius.circular(20))),
      child:  Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

}
