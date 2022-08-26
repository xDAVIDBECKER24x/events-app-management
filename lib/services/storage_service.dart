import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
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