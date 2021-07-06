import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:load/load.dart';
import 'package:odes/screens/splash_screen.dart';
import 'package:odes/screens/web_view_screen.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// void main() => runApp(MyApp());
Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://b9c2adfaf9b349bb8fa986ae3113c999@o912887.ingest.sentry.io/5850240';
    },
    // Init your App.
    appRunner: () => runApp(MyApp()),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _fcm = FirebaseMessaging(); // For FCM
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>(); // To be used as navigator

  String _appBadgeSupported = 'Unknown';
  int _counter = 0;

  @override
  void initState() {
    /* Handle Notifications */
    super.initState();
    pushNotificaiton();
    initPlatformState();
  }

  void pushNotificaiton() {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage');
        setState(() {
          _counter = 0;
        });
        // FlutterAppBadger.updateBadgeCount(0);
        // FlutterAppBadger.removeBadge();
      },
      onLaunch: (Map<String, dynamic> message) async {
        // On App Launch
        // handleClickedNotification(message);
        print('onLaunch');

        int counter = getCounter();
        int newCounter = counter + 1;
        setCounter(newCounter);
        FlutterAppBadger.updateBadgeCount(counter);
        FlutterAppBadger.removeBadge();
      },
      onResume: (Map<String, dynamic> message) async {
        // On App Resume
        print('onResume');

        int counter = await getCounter();
        int newCounter = counter + 1;
        await setCounter(newCounter);
        print(newCounter);
        FlutterAppBadger.updateBadgeCount(newCounter);

        return handleClickedNotification(message);
      },
    );

    if (Platform.isIOS) {
      // _fcm.requestNotificationPermissions(IosNotificationSettings());

      _fcm.requestNotificationPermissions(const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: true));
    }
  }

  getCounter() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    return (localStorage.getString('counter') != null)
        ? int.parse(localStorage.getString('counter'))
        : 0;
  }

  setCounter(data) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('counter', data.toString());
  }

  initPlatformState() async {
    String appBadgeSupported;
    try {
      bool res = await FlutterAppBadger.isAppBadgeSupported();
      if (res) {
        appBadgeSupported = 'Supported';
      } else {
        appBadgeSupported = 'Not supported';
      }
    } on PlatformException {
      appBadgeSupported = 'Failed to get badge support.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _appBadgeSupported = appBadgeSupported;
    });
  }

  handleClickedNotification(message) {
    // Put your logic here before redirecting to your material page route if you want too
    showLoadingDialog();

    navigatorKey.currentState.pushReplacement(MaterialPageRoute(
        builder: (context) => WebViewScreen(url: message['redirection'])));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: SplashScreen(),
    );
  }

  void _addBadge() {
    FlutterAppBadger.updateBadgeCount(1);
  }

  void _removeBadge() {
    FlutterAppBadger.removeBadge();
  }
}
