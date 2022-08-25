import 'package:events_app_management/models/settings_model.dart';
import 'package:events_app_management/modules/geral/screens/geral_settings_screen.dart';
import 'package:events_app_management/modules/photos/screens/photos_settings_screen.dart';
import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  SettingsTile({Key? key}) : super(key: key);

  final settingsList = Settings.generateSettings();


  @override
  Widget build(BuildContext context) {
    List<Widget> pageRoutes = [
      GeralSettingsScreen(),
      PhotoSettingsScreen(),
    ];
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10),
         child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
            ),
            itemCount: settingsList.length,
            itemBuilder: (context, index){
              return ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary : settingsList[index].bgColor,
                    alignment: Alignment(-1.2,0),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => pageRoutes[index])
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          settingsList[index].icon,
                          color: settingsList[index].iconColor,
                          size: 35,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          settingsList[index].title!,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        // SizedBox(
                        //   height: 22,
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
    );
  }
}
