import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app_management/models/file_model.dart';
import 'package:events_app_management/services/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ApplicationBloc {

  StorageService storageService = StorageService();

  List<String> files = [];


  Future getUploadedFiles() async{
    String category = 'images';
    String name = 'foo';

    files = await storageService.getFireStorageFiles(category);
    return files;
  }


  Future uploadFile(File file) async{
    String category = 'images';
    try{
      await storageService.uploadFile(file, category);
    } on FirebaseException catch (e){
      print(e);
    }
  }



}