import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class EventsList extends StatelessWidget {
  final List<Map<String, dynamic>> snapshot;

  EventsList({
    Key? key,
    required this.snapshot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 46),
      padding: EdgeInsets.all(12),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        itemCount: snapshot.length,
        itemBuilder: (BuildContext context, int index) {
          final Map<String, dynamic> image = snapshot[index];
          return Card(
            elevation: 2,
            child: Container(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      child: FadeInImage.memoryNetwork(
                        height: 80,
                        width: MediaQuery.of(context).size.width / 2.5,
                        placeholder: kTransparentImage,
                        image: image['url'],
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0),
                    width: MediaQuery.of(context).size.width / 2,
                    height: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          maxLines: 1,
                          '24 Outubro',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            maxLines: 2,
                            'Nome fodaaa aaaaaaaa aaaa  aaaa',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Text(
                            maxLines: 1,
                            'Lugaraaaaaaaaaaaaaaa',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
