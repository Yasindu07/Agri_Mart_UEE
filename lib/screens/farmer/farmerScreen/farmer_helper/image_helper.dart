import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  // Upload selected images to Firebase and return their download URLs
  Future<List<String>> uploadImages(List<File?> images) async {
    List<String> imageUrls = [];
    for (var image in images) {
      if (image != null) {
        // Get file name and create a storage reference
        String fileName = basename(image.path);
        Reference storageRef =
            FirebaseStorage.instance.ref().child('products/$fileName');

        // Upload the file to Firebase Storage
        UploadTask uploadTask = storageRef.putFile(image);

        // Wait until the upload is complete, then get the download URL
        TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Add the image URL to the list
        imageUrls.add(downloadUrl);
      }
    }
    return imageUrls;
  }

  // Pick an image from the gallery
  Future<File?> pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  // Capture an image from the camera
  Future<File?> captureImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}
