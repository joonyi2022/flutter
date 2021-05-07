import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:odes/screens/splash_screen.dart';
import 'package:odes/screens/web_view_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _fcm = FirebaseMessaging(); // For FCM
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>(); // To be used as navigator

  @override
  void initState() {
    /* Handle Notifications */
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        // TODO: As per your need
      },
      onLaunch: (Map<String, dynamic> message) async {
        // On App Launch
        handleClickedNotification(message);
      },
      onResume: (Map<String, dynamic> message) async {
        // On App Resume
        print(message);
        return handleClickedNotification(message);
      },
    );

    if (Platform.isIOS) {
      // _fcm.requestNotificationPermissions(IosNotificationSettings());

      _fcm.requestNotificationPermissions(const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: true));
    }

    super.initState();
  }

  handleClickedNotification(message) {
    // Put your logic here before redirecting to your material page route if you want too
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
}
