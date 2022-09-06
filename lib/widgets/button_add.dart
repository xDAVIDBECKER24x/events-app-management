import 'package:events_app_management/modules/events/screens/event_add_screen.dart';
import 'package:flutter/material.dart';

class ButtonAdd extends StatelessWidget {
  const ButtonAdd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(8),
      child: SizedBox(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: EdgeInsets.symmetric(
                    horizontal: 50, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            child: Icon(Icons.add),
            onPressed: () => showModalBottomSheet(
              isScrollControlled:true,
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              builder: (context) => Container(height : MediaQuery.of(context).size.height-15,child: EventAddScreen(),),
            )
        ),
      ),
    );
  }
}
