import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app_management/constants.dart';
import 'package:events_app_management/services/firestorage_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';


class ApplicationBloc {

  StorageService storageService = StorageService();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List files = [];
  late AsyncSnapshot<List<Map<String, dynamic>>> events;

  ApplicationBloc(){
  }



  Future getUploadedFiles() async{
    String category = 'Fotos';
    files = await storageService.getFireStorageFiles(category);
    return files;
  }


  Future uploadFile(File file, String category) async{
    try{
      await storageService.uploadFile(file, category);
    } on FirebaseException catch (e){
      print(e);
    }
  }


}