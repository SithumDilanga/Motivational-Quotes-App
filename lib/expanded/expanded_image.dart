import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:motivational_quotes/home/ad_load_count.dart';
import 'package:motivational_quotes/models/image.dart';
import 'package:motivational_quotes/expanded/download_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:motivational_quotes/services/permissions_service.dart';

class ExpandedImage extends StatefulWidget {
  final GridImage gridImage;

  const ExpandedImage({Key key, this.gridImage}) : super(key: key);
  @override
  _ExpandedImageState createState() => _ExpandedImageState(this.gridImage);
}

class _ExpandedImageState extends State<ExpandedImage> {
  // getting image data from the ImageGridItem class
  final GridImage gridImage;

  _ExpandedImageState(this.gridImage); 

  // --- share image function ---
  _shareImage(String url) async {

    try {
      var request = await HttpClient().getUrl(Uri.parse(
          url));
       var response = await request.close();
       Uint8List bytes = await consolidateHttpClientResponseBytes(response);
       await Share.file('ESYS AMLOG', 'amlog.jpg', bytes, 'image/jpg');

   } catch (e) {
      print('error: $e');
   }
  }
  // --- End share image function ---

  // --- asking user permission ---
  askPermission(){
   PermissionsService().requestStoragePermission(
     onPermissionDenied: () {
       print('Permission has been denied');
       Fluttertoast.showToast(
        msg: 'Permission denied! cannot download image',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.grey[800],
    );

   });
  }
  // --- End asking user permission ---


  @override
  void initState() {
    super.initState();

    AdLoadCount.adLoadCount++;

  }

  @override
  Widget build(BuildContext context) {

    return Material(
          color: Colors.grey[300],
          child: Column(
            children: [
              Expanded(
                flex: 10,
                child: Container(
                  color: Colors.grey[300],
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 32.0, 8.0, 0.0),
                    child: Column(
                      children: <Widget>[
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 5,
                             child: 
                             Container(
                                child: Hero(
                                tag: gridImage.timestamp.toString(),
                                child: CachedNetworkImage(
                                  imageUrl: gridImage.url,
                                )
                            ),
                        ),
                          ),
                          Flexible(
                            flex: 1,
                               child: 
                               Container(
                                  child: Row(
                                  children: <Widget>[           
                                    Expanded(     //download image
                                      child: IconButton(
                                        icon: Icon(Icons.file_download),
                                        iconSize: 32.0,
                                        color: Colors.blueGrey[700],
                                        onPressed: (){
                                          askPermission();
                                          DownloadImage().writeToDownloadPath(gridImage);
                                        },
                                      ),        
                                    ),
                                    Expanded(     //share image
                                      child: IconButton(
                                        icon: Icon(Icons.share),
                                        iconSize: 32.0,
                                        color: Colors.blueGrey[700],
                                        onPressed: (){
                                          _shareImage(gridImage.url);
                                        },
                                      ),
                                    ),
                                  ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }

}