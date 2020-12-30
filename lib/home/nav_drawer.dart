import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class NavDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text(''),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/nav_quote.jpeg'),
                  fit: BoxFit.cover
                )
              ),
            ),
            CustomeListTile(Icons.star, 'Rate App', () async =>{
              LaunchReview.launch(androidAppId: 'com.motivational.inspirational.daily.quotes')

            }),
            CustomeListTile(Icons.share, 'Share', ()=>{
              Share.share(
                ' Motivational Quotes App : '+  
                'https://play.google.com/store/apps/details?id=com.motivational.inspirational.daily.quotes'
              )
            }),
            CustomeListTile(Icons.dashboard, 'Other Apps', () {
              //playstore app page
              //StoreRedirect.redirect(androidAppId: 'com.simplevoice.android.voicerecorder');
              String url = 'https://play.google.com/store/apps/developer?id=SD+Live&hl=en';
              if (canLaunch(url) != null){
                launch(
                  url
                ); 
              } else {
                throw 'Could not launch $url';
              }
            }),
          ],
        ),
      )
    );
  }
}

class CustomeListTile extends StatelessWidget {

  IconData icon;
  String text;
  Function onTap;

  CustomeListTile(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey))
        ),
        child: InkWell(
          splashColor: Colors.blueGrey[300],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Icon(icon, size: 28, color: Colors.blueGrey[700],),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                  child: Text(
                    text, 
                    style: TextStyle(
                      fontSize: 22.0, 
                      color: Colors.blueGrey[900], 
                      shadows: [Shadow(blurRadius: 7.0, color: Colors.blueGrey[200], offset: Offset(1.0, 1.0),)]
                    ),
                  ),
                )
              ],
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}