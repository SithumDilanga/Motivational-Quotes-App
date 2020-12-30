import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motivational_quotes/home/image_grid_item.dart';
import 'package:motivational_quotes/services/database.dart';
import 'package:provider/provider.dart';
import 'package:motivational_quotes/models/image.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class ImageGridView extends StatefulWidget {
  @override
  _ImageGridViewState createState() => _ImageGridViewState();
}

class _ImageGridViewState extends State<ImageGridView> {

  final FirebaseMessaging _messaging = FirebaseMessaging();

  // database object
  DatabaseService database = DatabaseService();

  //List<Message> _messages;

  int currentLength = 0;

  //reversing images list
  List<GridImage> reversedData = [];

  final int increment = 30;
  bool isLoading = false;

  //count how many items added to the reversedData list and in order to update currentLength
  int listCounter = 0; 

  @override
  void initState() {
    super.initState();

    _messaging.getToken().then((token) {
      database.updateDeviceTokens(token);
      //print('Dev Token ' + token);
    });
    
    FacebookAudienceNetwork.init();
    print('gridview init');

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadMore(context, true);
  }

  Future _loadMore(BuildContext context, bool streamListenState) async {

      final images = Provider.of<List<GridImage>>(context, listen: streamListenState) ?? [];

      images.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      //final reversedData = images.reversed.toList();

      setState(() {
        isLoading = true;
      });

    // Add in an artificial delay
    await new Future.delayed(const Duration(milliseconds: 500));
    for (var i = currentLength; i < currentLength + increment; i++) {

      if(i < images.length) {
        listCounter = listCounter + 1;
      }
      
    }

    reversedData = images.sublist(0, images.length).reversed.toList();

    setState(() {
      isLoading = false;
      //currentLength = data.length; //<-previously
      currentLength = listCounter;
      //print('listCounter = ' + currentLength.toString());
    });
  } 


  @override
  Widget build(BuildContext context) {

    try {

      return 
          LazyLoadScrollView(
            isLoading: isLoading,
            onEndOfPage: () {
              return _loadMore(context, false);
            },
              child: GridView.builder(
              itemCount: listCounter + 1,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {

                if (index == listCounter) { 
                  return CupertinoActivityIndicator();
                } 
                
                //passing images stream with the item index to ImageGridItem
                return ImageGridItem(gridImage: reversedData[index],); 
              },

            ),
          );
      
    } catch (e) {

      return Material(
        child: Container(
          child: Center(
            child: Text('Error occured !'),
          )
        ),
      );

    }
    
  }
}