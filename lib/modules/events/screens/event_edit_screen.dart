import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class EventEditScreen extends StatelessWidget {
  late String? url;
  EventEditScreen({required  this.url,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            child: FadeInImage.memoryNetwork(
              height: MediaQuery.of(context).size.width/2,
              width: MediaQuery.of(context).size.width,
              placeholder: kTransparentImage,
              image: url!,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }
}
