import 'dart:io';
import 'package:events_app_management/blocs/application_bloc.dart';
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

  Future<List<Map<String, dynamic>>> _loadImages() async {
    List<Map<String, dynamic>> files = [];

    final ListResult result =
        await FirebaseStorage.instance.ref('test/teste/images').list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
        "description":
            fileMeta.customMetadata?['description'] ?? 'No description'
      });
    });

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
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                "Mídias",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: Colors.black),
              ),
            )
          ],
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  height: 350,
                  width: MediaQuery.of(context).size.width,
                  child: FutureBuilder(
                    future: _loadImages(),
                    builder: (context,
                        AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTitle(title: 'Fotos',),
                            MediaList(snapshot: snapshot.data!),
                          ],
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.only(8),
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.circular(30),
                //     child: Container(
                //       color: Colors.grey.withOpacity(0.5),
                //       padding: EdgeInsets.all(8),
                //       child: Text(
                //         title,
                //         style: const TextStyle(
                //           color: Colors.black,
                //           fontSize: 20.0,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ),
              SliverToBoxAdapter(
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
                        : Text('Selecione Imagem'),
                    SizedBox(
                      height: 100,
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
              ) //
            ],
          ),
        ),
      ),
    );
  }
}
