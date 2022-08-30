import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app_management/utils/generate_values.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService{

  FirebaseStorage storage = FirebaseStorage.instance;
  String user = 'teste';
  bool fileExist = false;

  Future<void> uploadFile(File file,String category) async{

    String name = generateRandomString(64);

    while(checkIfFileExist(category, name) == true){
      name = generateRandomString(64);
    }

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

  Future<bool> checkIfFileExist(String category,String id) async {

    try {
      await storage.ref("test/${user}/${category}/${id}").getData().then((doc) {
        fileExist = true;
      });
      return fileExist;
    } catch (e) {
      print(e);
      return true;
    }
  }


}