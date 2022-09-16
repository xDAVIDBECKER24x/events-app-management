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

    try{
      print(ref);
      print(currentUID);
      // await storage.ref('root/users/$currentUID').putFile(file);
      await storage.ref(ref).putFile(file);

    }on FirebaseException catch (e){
      print(e);
    }
  }

  Future<void> deleteFile(String fileName,String category) async{

    String ref = 'root/users/$currentUID/$category/$fileName';

    try{
      print(ref);
      print(currentUID);
      await storage.ref(ref).delete();

    }on FirebaseException catch (e){
      print(e);
    }

  }


  Future<Map<String, dynamic>> uploadFileGetDonwloadUrl(File file,String category) async {
    String name = sha1RandomString();
    String ref = 'root/users/$currentUID/$category/$name';
    String downloadUrl = '';

    try{
      await storage.ref(ref).putFile(file).then((_) async {
        downloadUrl = await storage.ref(ref).getDownloadURL();
        print(downloadUrl.runtimeType);
        print(downloadUrl);
      });
    }on FirebaseException catch (e){
      print(e);

    }
    return {'downloadUrl' : downloadUrl, 'fileName' : name};
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