import 'dart:math';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'database.dart';

class Storage {

  static String imageLink;
  static String imageLocation;

  DatabaseService database = DatabaseService();

  Future<String> uploadimage(File imageFile) async {

      // Make random image name.
      int randomNumber = Random().nextInt(1000000);
      imageLocation = 'image${randomNumber}.jpg';

      StorageReference photosRef = FirebaseStorage.instance.ref().child("photos").child(imageLocation);

      photosRef.putFile(imageFile).onComplete.then((storageTask) async {
      String imageLink = await storageTask.ref.getDownloadURL();

      // storing image data in firestore
      database.updateImageData(imageLocation, imageLink);

    });
  }

}