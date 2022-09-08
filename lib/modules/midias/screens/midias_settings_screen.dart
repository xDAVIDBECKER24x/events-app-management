import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:events_app_management/blocs/application_bloc.dart';
import 'package:events_app_management/constants.dart';
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
  bool _hasFile = false;
  String? midiaType;
  String dropdownValue = midiaCategories.first;
  final midiaTypes = [
    {'label': 'Fotos', 'value': 'pictures'},
    {'value': 'banners', 'label': 'Capas'}
  ];

  Future selectFile(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      final imageShow = File(image!.path);
      setState(() {
        this.file = imageShow;
        _hasFile = true;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }


  Future<List<Map<String, dynamic>>> _loadImages(String category) async {
    List<Map<String, dynamic>> files = [];

    final ListResult result =
    await FirebaseStorage.instance.ref('root/users/$currentUID/$category')
        .list();
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

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) =>
        [
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
              "Mídias",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Colors.black),
            ),
            actions: [
            ],
          )
        ],
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(16), //padding of outer Container
                child: DottedBorder(
                  color: Colors.grey, //color of dotted/dash line
                  strokeWidth: 3, //thickness of dash/dots
                  dashPattern: [10, 6],
                  //dash patterns, 10 is dash width, 6 is space width
                  child: ClipRRect(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StatefulBuilder(builder: (BuildContext context,
                            StateSetter setState) {
                          return DropdownButton<String>(
                            value: dropdownValue,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(color: Colors.black),
                            underline: Container(
                              height: 2,
                              color: Colors.amberAccent,
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                dropdownValue = value!;
                              });
                            },
                            items: midiaCategories.map<DropdownMenuItem<String>>((
                                String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Container(
                                  height: 25,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                        ),

                        file != null ?
                        Container(
                          padding: EdgeInsets.all(8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              file!,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height / 2.5,
                            ),
                          ),
                        )
                            :
                        StatefulBuilder(builder: (BuildContext context,
                            StateSetter setState) {
                          return Container(
                            padding: EdgeInsets.all(8),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height / 2.5,
                                    child: Container(
                                      padding: EdgeInsets.all(64),
                                      child: Image.asset(
                                          'assets/icons/upload_icon.png'),
                                    )
                                )
                            ),
                          );
                        }),

                        Container(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed: () =>
                                        selectFile(ImageSource.gallery),
                                    child: Icon(Icons.image)),
                                SizedBox(
                                  width: 20,
                                ),
                                ElevatedButton(
                                    onPressed: () =>
                                        selectFile(ImageSource.camera),
                                    child: Icon(Icons.camera_alt)),
                                SizedBox(
                                  width: 20,
                                ),
                                ElevatedButton(
                                    onPressed: _hasFile ? () {
                                      applicationBloc.uploadFile(
                                          file!, dropdownValue);
                                      print(dropdownValue);
                                      setState(() {
                                        this.file = null;
                                        _hasFile = false;
                                      });
                                    }
                                        : null,
                                    child: Icon(Icons.upload))
                              ],
                            )),

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
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ListTitle(title: 'Fotos',),
                      ],
                    ),
                    FutureBuilder(
                      future: _loadImages('pictures'),
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
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTitle(title: 'Capas',),
                    FutureBuilder(
                      future: _loadImages('banners'),
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
    );
  }

}
