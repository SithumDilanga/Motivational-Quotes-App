import 'package:flutter/material.dart';
import 'package:motivational_quotes/admin/upload_image.dart';
import 'package:motivational_quotes/home/image_grid_view.dart';
import 'package:motivational_quotes/home/nav_drawer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver{

  @override
  void initState() {
    super.initState();
    //AdSettings.addTestDevice("32315611-f326-43a0-86fb-c230e75b2daa");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar (
        title: Text('Motivational Quotes', 
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blueGrey[700],
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.cloud_upload),
            onPressed: () async { //moving to upload image activity
              Navigator.push(context, MaterialPageRoute(builder: (context) => UploadImage()));
            },
          ),
        ],
      ),
      drawer: NavDrawer(), //navigaion drawer
      body: Material(
        child: ImageGridView(),
      ),
    );
  }
}