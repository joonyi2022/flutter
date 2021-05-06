import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:odes/screens/splash_screen.dart';
import 'package:odes/screens/web_view_screen.dart';
import 'package:odes/widgets/routeTransitions/fade_route.dart';

void main() {
  runApp(
    MaterialApp(
      home: PushMessagingExample(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class PushMessagingExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PushNotificationScreen();
}

class PushNotificationScreen extends State<PushMessagingExample> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final TextEditingController controller = TextEditingController();
  var redirect = '';
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: "navigator");

  @override
  void initState() {
    super.initState();
    fireBaseTrigger(context);
  }

  void fireBaseTrigger(BuildContext context) async {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        print('redirecting');
        print('redirecting');
        // print(message['redirection']);
        print('done');
        // if (message['redirection'] != '') {
        //   await _navigateToWebView(message['redirection']);
        // }
      },
    );

    if (Platform.isIOS) {
      firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(
              sound: true, badge: true, alert: true, provisional: true));
    }
  }

  void _navigateToWebView(url) {
    // showLoadingDialog();
    // Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    Navigator.of(context).push(FadeRoute(page: WebViewScreen(url: url)));
    // hideLoadingDialog();
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
