import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motivational_quotes/models/image.dart';

class DatabaseService {

  final String uid;

  DatabaseService({this.uid});

  // collection reference
  // images firestore reference
  final CollectionReference imageCollection = FirebaseFirestore.instance.collection('images');
  
  // push device tokens firestore reference
  final CollectionReference devTokenCollection = FirebaseFirestore.instance.collection('pushtokens');

  // creating new document for a image user and updating existing image data
  Future updateImageData(String location, String url) async{
    return await imageCollection.doc(uid).set({
      'location': location,
      'url': url,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // creating new document for a new device token and updating existing tokens
  Future updateDeviceTokens(String devToken) async{
    return await devTokenCollection.doc(devToken).set({
      'devtoken': devToken,
    });
  }
  
  // image list from snapshot
  List<GridImage> _imageListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc,) {
      return GridImage(
        url: doc.data()['url'] ?? '',
        location: doc.data()['location'] ?? '',
        timestamp: doc.data()['timestamp'].toString() ?? ''
      );
    }).toList();
  }

  // get image stream
  //.orderBy('timestamp', descending: true)
  Stream<List<GridImage>> get images {
    return imageCollection.snapshots().map(_imageListFromSnapshot);
  }

}