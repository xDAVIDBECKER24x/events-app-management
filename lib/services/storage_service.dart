

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app_management/blocs/application_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService{

  FirebaseStorage storage = FirebaseStorage.instance;
  String user = 'teste';

  Future<void> uploadFile(File file,String category) async{

    String name = 'foo';

    try{
      await storage.ref('test/${user}/${category}/${name}').putFile(file);
    }on FirebaseException catch (e){
     print(e);
    }
  }

  Future getFireStorageFiles(String category) async {
    List<Map<String, dynamic>> files = [];
    final ListResult result = await storage.ref('test/${user}/${category}').list();
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

    // List<String> urls = [];
    // late String url;
    // try{
    //    ListResult results = await storage.ref('test/${user}/${category}').listAll();
    //    // print(results);
    //    //  results.items.forEach((elements) async {
    //    //    url = await getFireStorageFileByFullPath(elements.fullPath);
    //    //    urls.add(url);
    //    //  });
    //   return results;
    // }on FirebaseException catch (e){
    //     print(e);
    // }
  }

  Future getFireStorageFileByFullPath(String path) async {

    try{
      String url = await storage.ref(path).getDownloadURL();
      return url;
    }on FirebaseException catch (e){
      print(e);
    }
  }


  Future getFireStorageFile(String category,String file) async {
    try{
      String url = await storage.ref('test/${user}/${category}/${file}').getDownloadURL();
      return url;
    }on FirebaseException catch (e){
      print(e);
    }
  }


}