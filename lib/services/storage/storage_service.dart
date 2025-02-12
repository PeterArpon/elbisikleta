import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StorageService with ChangeNotifier {
  // firebase storage instance
  final firebaseStorage = FirebaseStorage.instance;

  bool _isLoading = false;
  bool _isuploading = false;

  // getters
  bool get getIsLoading => _isLoading;
  bool get getIsUploading => _isuploading;

  // to do: delete image

  // Pick images
  Future<List<String>> pickImages() async {
    // start upload
    _isuploading = true;
    // update the UI
    notifyListeners();

    // pick an image
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    // check if images list is empty
    if (images == null) {
      _isuploading = false;
      // update the UI
      notifyListeners();
      return [];
    }

    List<String> photoUrls = [];
    
    for (int i = 0; i < images.length; i++) {
      final File imageFile = File(images[i].path);

      photoUrls.add(imageFile.path);
      
    }
    
    return photoUrls;
  }

  Future<List<String>> uploadImages(List<String> photoUrls, String bikeId) async {
    try {

      // check if images list is empty
      if (photoUrls.isEmpty) {
        return [];
      }

      List<String> newPhotoUrls = [];

      // upload images
      for (int i = 0; i < photoUrls.length; i++) {
        final File imageFile = File(photoUrls[i]);

        try {
          final String fileName = 'uploaded_images/bikes/$bikeId/image_$i.jpg';
          
          final storageRef = FirebaseStorage.instance.ref().child(fileName);
          await storageRef.putFile(imageFile);
          final String downloadUrl = await storageRef.getDownloadURL();
          
          // update photoUrls list
          newPhotoUrls.add(downloadUrl);
        } catch (error) {
          _isuploading = false;
          // update the UI
          notifyListeners();
          throw error;
        } finally {
          _isuploading = false;
          // update the UI
          notifyListeners();
        }

      }

      _isuploading = false;
      // update the UI
      notifyListeners();

      return newPhotoUrls;
    } catch (error) {
      _isuploading = false;
      // update the UI
      notifyListeners();
      throw error;
    }
  }

}
