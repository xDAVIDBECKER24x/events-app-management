import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app_management/constants.dart';
import 'package:events_app_management/utils/generate_values.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService{

  FirebaseStorage storage = FirebaseStorage.instance;
  bool fileExist = false;

  Future<void> uploadFile(File file,String category) async{

    String name = sha1RandomString();
    String ref = 'root/users/$currentUID/$category/$name';
    // while(checkIfFileExist(category, name) == true){
    //   name = sha1RandomString();
    // }
    try{
      print(ref);
      print(currentUID);
      // await storage.ref('root/users/$currentUID').putFile(file);
      await storage.ref(ref).putFile(file);
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
      String url = await storage.ref('root/users/${currentUID}/${category}/${file}').getDownloadURL();
      return url;
    }on FirebaseException catch (e){
      print(e);
    }
  }

  Future<bool> checkIfFileExist(String category,String id) async {

    try {
      await storage.ref("root/users/${currentUID}/${category}/${id}").getData().then((doc) {
        fileExist = true;
      });
      return fileExist;
    } catch (e) {
      print(e);
      return true;
    }
  }


}