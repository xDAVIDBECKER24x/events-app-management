import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app_management/constants.dart';
import 'package:events_app_management/modules/settings/blocs/settings_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../widgets/info_dialog_box.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  final _settingsBloc = SettingsBloc();

  @override
  void initState() {
    super.initState();
    _settingsBloc.outState.listen((state){
      switch(state){
        case SettingsState.SUCCESS:
        case SettingsState.FAIL:
        case SettingsState.LOADING:
        case SettingsState.IDLE:
      }
    });

  }

  @override
  void dispose() {
    _settingsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
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
              "Settings",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Colors.black),
            ),
            actions: [],
          )
        ],
        body: StreamBuilder<SettingsState>(
            stream: _settingsBloc.outState,
            initialData: SettingsState.LOADING,
            builder: (context,snapshot) {
              if(snapshot.hasData){
                switch(snapshot.data) {
                  case SettingsState.LOADING:
                    return const Center(child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.amberAccent),),);
                  case SettingsState.FAIL:
                  case SettingsState.SUCCESS:
                  case SettingsState.IDLE:
                    print('tttttttttttttttttttt');
                    print(currentUID);
                    return Padding(
                        padding: const EdgeInsets.all(10),
                        child: ListView(
                          children: [
                            // User card
                            SmallUserCard(
                              cardColor: Colors.blueGrey,
                              userName: _settingsBloc.userData['establishment'],
                              userProfilePic: AssetImage("assets/images/teste_image.png"),
                              onTap: () {
                                print("OK");
                              },
                            ),
                            SettingsGroup(
                              items: [
                                SettingsItem(
                                  onTap: () {},
                                  icons: Icons.perm_identity_outlined,
                                  iconStyle: IconStyle(
                                    backgroundColor: Colors.blueAccent,
                                  ),
                                  title: 'Nome',
                                  subtitle: _settingsBloc.userData['name'],
                                ),
                                SettingsItem(
                                  onTap: () {},
                                  icons: Icons.email,
                                  iconStyle: IconStyle(
                                    backgroundColor: Colors.grey,
                                  ),
                                  title: 'Email',
                                  subtitle: _settingsBloc.userData['email'],
                                ),

                                // SettingsItem(
                                //   onTap: () {},
                                //   icons: Icons.dark_mode_rounded,
                                //   iconStyle: IconStyle(
                                //     iconsColor: Colors.white,
                                //     withBackground: true,
                                //     backgroundColor: Colors.deepPurpleAccent,
                                //   ),
                                //   title: 'Dark mode',
                                //   subtitle: "Automático",
                                //   trailing: Switch.adaptive(
                                //     value: false,
                                //     onChanged: (value) {},
                                //   ),
                                // ),
                              ],
                            ),
                            Divider(),
                            SettingsGroup(
                              items:[
                                SettingsItem(
                                  onTap: () {},
                                  icons: Icons.location_city_outlined,
                                  iconStyle: IconStyle(
                                    backgroundColor: Colors.grey,
                                  ),
                                  title: 'Localização',
                                  subtitle: _settingsBloc.userData['address'],
                                ),
                                SettingsItem(
                                  onTap: () {},
                                  icons: Icons.star,
                                  iconStyle: IconStyle(
                                    backgroundColor: Colors.amberAccent,
                                  ),
                                  title: 'Preferências',
                                  subtitle: _settingsBloc.userData['address'],
                                ),

                              ]
                            ),
                            Divider(),
                            SettingsGroup(
                              items: [
                                SettingsItem(
                                  onTap: () {},
                                  icons: Icons.exit_to_app_rounded,
                                  title: "Deslogar",
                                  iconStyle: IconStyle(
                                    iconsColor: Colors.white,
                                    withBackground: true,
                                    backgroundColor: Colors.grey,
                                  ),
                                  subtitle: 'Deslogar/Trocar de Usuário',
                                ),
                                SettingsItem(
                                  onTap: () {},
                                  icons: Icons.phonelink_erase,
                                  iconStyle: IconStyle(
                                    iconsColor: Colors.white,
                                    withBackground: true,
                                    backgroundColor: Colors.redAccent,
                                  ),
                                  title: "Deletar conta",
                                  titleStyle: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  subtitle: 'Deletar permanentemente',
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                }
              }
              return const Center(child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.amberAccent),),);
            }
        ),
      ),
    );
  }

  void openInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InfoDialogBox(
            title: "Tela de Configurações Gerais",
            infoText:
                "Nesta tela o administrador , definirá as informaçoes gerais que aparecerão no applicativo");
      },
    );
  }


}
