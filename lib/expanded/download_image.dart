import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:motivational_quotes/models/image.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class DownloadImage {

  //--- download the image ---
  Future writeToDownloadPath(GridImage imageData) async {

    try {

      var response = await Dio().get(imageData.url,
           options: Options(responseType: ResponseType.bytes));
        final result = await ImageGallerySaver.saveImage(
           Uint8List.fromList(response.data),
           quality: 60,
           name: "MotivationalQuotes${imageData.location}");
        print(result); 

        // --- showing toast message ---
        Fluttertoast.showToast(
          msg: 'Image downloaded to Gallery',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.grey[800],
        );
        // --- End showing toast message ---

    } catch(e) {

      Fluttertoast.showToast(
        msg: 'Download failed! error occured',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.grey[800],
      );

      print(e.toString());

    }
  
  }
}