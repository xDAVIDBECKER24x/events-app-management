import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:events_app_management/blocs/application_bloc.dart';
import 'package:events_app_management/widgets/info_dialog_box.dart';
import 'package:events_app_management/widgets/list_title.dart';
import 'package:events_app_management/widgets/midia_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class PhotoSettingsScreen extends StatefulWidget {
  const PhotoSettingsScreen({Key? key}) : super(key: key);

  @override
  State<PhotoSettingsScreen> createState() => _PhotoSettingsScreenState();
}

class _PhotoSettingsScreenState extends State<PhotoSettingsScreen> {
  File? file;

  Future selectPhoto(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      final imageShow = File(image!.path);
      setState(() {
        this.file = imageShow;
      });
    } on PlatformException catch (e) {
      print("error");
    }
  }

  @override
  void initState() {
    super.initState();
  }


  Future<List<Map<String, dynamic>>> _loadImages(String category) async {
    List<Map<String, dynamic>> files = [];

    // final ListResult result =
    //     await FirebaseStorage.instance.ref('test/teste/${category}').list();
    // final List<Reference> allFiles = result.items;
    //
    // await Future.forEach<Reference>(allFiles, (file) async {
    //   final String fileUrl = await file.getDownloadURL();
    //   final FullMetadata fileMeta = await file.getMetadata();
    //   files.add({
    //     "url": fileUrl,
    //     "path": file.fullPath,
    //     "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
    //     "description":
    //         fileMeta.customMetadata?['description'] ?? 'No description'
    //   });
    // });

    return files;
  }

  @override
  Widget build(BuildContext context) {
    ApplicationBloc applicationBloc = ApplicationBloc();
    return Center(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              snap: true,
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
                "Mídias",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: Colors.black),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    color: Colors.grey,
                    size: 30,
                  ),
                  onPressed: () {
                    openInfoDialog;
                  },
                )
              ],
            )
          ],
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(

                  padding: EdgeInsets.all(20), //padding of outer Container
                  child: DottedBorder(
                    color: Colors.grey,//color of dotted/dash line
                    strokeWidth: 2, //thickness of dash/dots
                    dashPattern: [10,6],
                    //dash patterns, 10 is dash width, 6 is space width
                    child: ClipRRect(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          
                          file != null
                              ? Container(
                            padding: EdgeInsets.all(30),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(file!),
                            ),
                          )
                              : Padding(
                              padding: EdgeInsets.all(26),
                              child : Text('Selecione Imagem')
                          ),
                          Container(
                              padding: EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () =>
                                          selectPhoto(ImageSource.gallery),
                                      child: Icon(Icons.image)),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  ElevatedButton(
                                      onPressed: () =>
                                          selectPhoto(ImageSource.camera),
                                      child: Icon(Icons.camera_alt)),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  ElevatedButton(
                                      onPressed: () =>
                                          applicationBloc.uploadFile(file!),
                                      child: Icon(Icons.upload))
                                ],
                              ))
                        ],
                      ),

                    ),
                  ),

                ),
              ),
              SliverToBoxAdapter(
                child: Divider(
                  height: 5,
                  thickness: 1,
                  endIndent: 0,
                  color: Colors.grey,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 350,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTitle(title: 'Fotos',),
                      FutureBuilder(
                        future: _loadImages('images'),
                        builder: (context,
                            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return MediaList(snapshot: snapshot.data!);
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Divider(
                  height: 5,
                  thickness: 1,
                  endIndent: 0,
                  color: Colors.grey,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 350,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTitle(title: 'Capas',),
                      FutureBuilder(
                        future: _loadImages('images'),
                        builder: (context,
                            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return MediaList(snapshot: snapshot.data!);
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ), //
            ],
          ),
        ),
      ),
    );
  }

  void openInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Alert!!"),
          content: new Text("You are awesome!"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    // return InfoDialogBox( info : "Nesta tela o administrador , definirá as midias que aparecerão no applicativo");
  }
}
