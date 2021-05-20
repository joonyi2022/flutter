import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:odes/screens/splash_screen.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

void main() {
  runApp(
    MaterialApp(
      home: PushMessagingExample(),
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class PushMessagingExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PushNotificationScreen();
}

class PushNotificationScreen extends State<PushMessagingExample>
    with ChangeNotifier {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final TextEditingController controller = TextEditingController();
  ValueNotifier<int> notificationCounterValueNotifer = ValueNotifier(1);

  @override
  void initState() {
    super.initState();
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        FlutterAppBadger.updateBadgeCount(1);
      },
      onLaunch: (Map<String, dynamic> message) async {
        // FlutterAppBadger.removeBadge();
        print("onLaunch: $message");
        FlutterAppBadger.removeBadge();
      },
      onResume: (Map<String, dynamic> message) async {
        FlutterAppBadger.updateBadgeCount(1);
        print("onResume: $message");
      },
    );
    if (Platform.isIOS)
      firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(
              sound: true, badge: true, alert: true, provisional: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreen(),
    );
  }

  Widget buildBody() {
    return Container(
      height: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 100,
            child: TextField(
              controller: controller,
            ),
          ),
          RaisedButton(
            color: Colors.white54,
            child: const Text(
              "Subscribe",
              style: TextStyle(color: Colors.lightGreen),
            ),
            onPressed: () {
              firebaseMessaging.subscribeToTopic(controller.text);
              clearText();
            },
          ),
          RaisedButton(
            color: Colors.white54,
            child: const Text(
              "Unsubscribe",
              style: TextStyle(color: Colors.redAccent),
            ),
            onPressed: () {
              firebaseMessaging.unsubscribeFromTopic(controller.text);
              clearText();
            },
          ),
        ],
      ),
    );
  }

  void clearText() {
    setState(() {
      controller.text = "";
    });
  }
}
