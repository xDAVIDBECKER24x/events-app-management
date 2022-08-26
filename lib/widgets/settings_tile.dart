import 'package:events_app_management/models/settings_model.dart';
import 'package:events_app_management/modules/events/screens/events_settings_screen.dart';
import 'package:events_app_management/modules/geral/screens/geral_settings_screen.dart';
import 'package:events_app_management/modules/midias/screens/midias_settings_screen.dart';
import 'package:flutter/material.dart';

import '../modules/codes/screens/codes_settings_screen.dart';

class SettingsTile extends StatelessWidget {
  SettingsTile({Key? key}) : super(key: key);

  final settingsList = Settings.generateSettings();


  @override
  Widget build(BuildContext context) {
    List<Widget> pageRoutes = [
      GeralSettingsScreen(),
      PhotoSettingsScreen(),
      EventsSettingsScreen(),
      CodesSettingsScreen(),
    ];
    return Expanded(
      child: Container(
        color: Colors.white70,
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
                child: Card(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary : settingsList[index].bgColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => pageRoutes[index])
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(36.0),
                      child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
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
                                    color: Colors.black,
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
                ),
              );
            },
          ),
        ),
    );
  }
}
