import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:motivational_quotes/expanded/expanded_image.dart';
import 'package:motivational_quotes/home/ad_load_count.dart';
import 'package:motivational_quotes/models/image.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageGridItem extends StatefulWidget {

  //getting GridImage type data coming from the ImageGridView
  final GridImage gridImage; 

  ImageGridItem({this.gridImage});

  @override
  _ImageGridItemState createState() => _ImageGridItemState();
}

class _ImageGridItemState extends State<ImageGridItem> {

  bool _isInterstitialAdLoaded = true;

  // --- interstitial ad --- 

  void _loadInterstitialAd() {
    print('ad load called ');
    FacebookInterstitialAd.loadInterstitialAd(
      placementId:
          "IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617", //"IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617" YOUR_PLACEMENT_ID 
      listener: (result, value) {
        print(">> FAN > Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED)
          _isInterstitialAdLoaded = true;

        /// Once an Interstitial Ad has been dismissed and becomes invalidated,
        /// load a fresh Ad by calling this function.
        if (result == InterstitialAdResult.DISMISSED &&
            value["invalidated"] == true) {
          _isInterstitialAdLoaded = false;
          _loadInterstitialAd();
        }
      },
    );
  }

  _showInterstitialAd() {
    if (_isInterstitialAdLoaded == true)
      FacebookInterstitialAd.showInterstitialAd();
    else
      print("Interstial Ad not yet loaded!");
  }  

  // --- End interstitial ad --- 

  @override
  Widget build(BuildContext context) {

    if (widget.gridImage.url != null) {

      return Padding(
      padding: EdgeInsets.all(5.0),
          child: Container(
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6), // add a radius to the decorations
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // add a shadow
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(0, 0), // changes position of shadow
              ) 
            ]
          ),
            child: InkWell(
              child: Hero(  //hero pop up animation
                tag: widget.gridImage.timestamp.toString(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                   child: CachedNetworkImage(
                            imageUrl: widget.gridImage.url,
                            placeholder: (context, url) => imagePlaceholder(),
                            fit: BoxFit.cover,
                          ) 
              ),
      ),
      onTap: () { // moving to the ExpandedImage

          if (AdLoadCount.adLoadCount == 5){
            //_loadInterstitialAd();
            //print('ad load at ' + AdLoadCount.adLoadCount.toString());
          }

          if (AdLoadCount.adLoadCount == 7){
            //_showInterstitialAd();
            AdLoadCount.adLoadCount = -1;
            //print(AdLoadCount.adLoadCount.toString());
          }
          //print(AdLoadCount.adLoadCount.toString());

            //it should pass gridImage to the ExpandedImage class
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => ExpandedImage(gridImage: widget.gridImage,))
            );
      },
    ),
          ),
    );

    } else {
      return Center(child: Text('No Data'));
    }
     
  }

  Widget imagePlaceholder() {
    return Container(
      child: Image.asset(
        'assets/images/image placeholder 2.jpg',
        fit: BoxFit.cover,
      ),
    );
  }
} 