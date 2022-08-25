import 'package:flutter/material.dart';

class MediaList extends StatelessWidget {
  final List<Map<String, dynamic>> snapshot;

   MediaList({
    Key? key,
    required this.snapshot,
   }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
            padding: EdgeInsets.all(16),
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.length,
              itemBuilder: (BuildContext context, int index) {
                final Map<String, dynamic> image = snapshot[index];
                return GestureDetector(
                  // onTap: () => print(contentList[index].name),
                  child: ClipRRect(
                    borderRadius:BorderRadius.circular(30),
                    child: Card(
                      elevation: 10,
                      child: Container(
                        child: Image.network(
                          image['url'],
                          height: 250,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }
}
