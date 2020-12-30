import 'dart:async';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:motivational_quotes/home/home.dart';
import 'package:motivational_quotes/services/database.dart';
import 'package:provider/provider.dart';
import 'package:motivational_quotes/models/image.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runZonedGuarded<Future<void>>(() async {
    runApp(MyApp());
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });

  //runApp(MyApp());
}

// --- splash screen ---
class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: MainScreen(),
      title: Text('Motivational Quotes',textScaleFactor: 2,),
      image: Image.asset('assets/images/splash logo.jpg'),
      //loadingText: Text("Loading"),
      photoSize: 150.0,
      loaderColor: Colors.white,
    );
  }
}
// --- End splash screen ---

// --- Main Screen ---
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  Widget _currentAd = SizedBox(
    width: 0.0,
    height: 0.0,
  );

  _showBannerAd() {
    setState(() {
      _currentAd = FacebookBannerAd(
         placementId:
             "IMG_16_9_APP_INSTALL#2312433698835503_2964944860251047 ", //IMG_16_9_APP_INSTALL#2312433698835503_2964944860251047 
        bannerSize: BannerSize.STANDARD,
        listener: (result, value) {
          print("Banner Ad: $result -->  $value");
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    //FacebookAudienceNetwork.init();
    //_showBannerAd();
  }

  @override
  Widget build(BuildContext context) {

    return Material(
          child: Column(
          children: [
              Expanded( // home screen
                flex: 22,
                child: Home()
              ),

            /*Flexible( // banner ad in the bottom of the screen
            child: Align( 
              alignment:Alignment(0, 1),
              child: _currentAd,
            ),
            fit: FlexFit.tight,
            flex: 2,
          ) */
        ],
      ),
    );
  }
} 
// --- End Main Screen ---

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // tracks whether device has internet connection or not
  bool isConnected = true;

  // opening a subscription to listen to connectivity
  StreamSubscription<DataConnectionStatus> listener;

  @override
  void initState() {
    super.initState();
    // load method to check internet connectivity
    checkConectivity();
    FacebookAudienceNetwork.init();

  }

  @override
  void dispose() {

    //unsubcribing the listen
    listener.cancel();
    super.dispose();
  }

  // --- check internet connectivity ---
  checkConectivity() async {
    listener = await DataConnectionChecker().hasConnection.then((status) {

      switch (status){
        case true : {
          setState(() {
            isConnected = true;
          });
        }
        break;  
        case false : {
          setState(() {
            isConnected = false;
          });
        }
        break;
      }
    }
    );

    return await DataConnectionChecker().connectionStatus;
    
  }

  // --- End check internet connectivity ---

  @override
  Widget build(BuildContext context) {

    if (isConnected == true){ // when internet is available
      return StreamProvider<List<GridImage>>.value( //can be listen to the firebase streams for all the descendant widgets
      value: DatabaseService().images, 
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Splash(),
      ),
     );
    } else { // when internet is not available
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Material(
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.signal_wifi_off,
                    size: 72,
                    color: Colors.grey ,
                  ),
                  SizedBox(height: 8,),
                  Text(
                    'No Internet Connection',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8,),
                  RaisedButton(            // Try Again button
                    padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 12.0, bottom: 12.0),
                    child: Text('Try Again', style: TextStyle(color: Colors.white, fontSize: 18),),
                    color: Colors.blueGrey[500],
                    
                    onPressed: () {

                      //check internet connectivity
                      DataConnectionChecker().hasConnection.then((value) {
                        if (value == true){
                          setState(() {
                            isConnected = true;
                          });
                        } else {
                          Fluttertoast.showToast(
                            msg: 'Please check network connection !',
                            toastLength: Toast.LENGTH_SHORT, 
                          );
                        }
                      });
                    }
                  )
                ],
              ),
          ),
        ),
      );
    }
  }  
}