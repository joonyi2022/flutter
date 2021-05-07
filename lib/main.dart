import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:load/load.dart';
import 'package:odes/screens/accounts_screen.dart';
import 'package:odes/screens/login_screen.dart';
import 'package:odes/screens/splash_screen.dart';
import 'package:odes/screens/web_view_screen.dart';
import 'package:odes/widgets/routeTransitions/fade_route.dart';

void main() {
  runApp(
    RestartWidget(
      child: MaterialApp(
        home: PushMessagingExample(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}

class RestartWidget extends StatefulWidget {
  RestartWidget({this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>().restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
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
    if (Platform.isIOS) {
      firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(
              sound: true, badge: true, alert: true, provisional: true));
    }

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        // print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        // print("onLaunch: $message");
        _navigateToWebView(message['redirection'], context);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // RestartWidget.restartApp(context);
        // await Navigator.of(context).push(FadeRoute(page: Accountscreen()));
        _navigateToWebView(message['redirection'], context);
      },
    );
  }

  Future _navigateToWebView(url, context) async {
    showLoadingDialog();
    print('data ::' + url);
    // Navigator.popUntil(
    //     context, (Route<dynamic> route) => route is WebViewScreen);
    //  showLoadingDialog();
    // print(url);
    await Navigator.popUntil(context, (Route<dynamic> route) => false);
    await Navigator.of(context)
        .pushReplacement(FadeRoute(page: Accountscreen()));
    // Navigator.of(context).popUntil((route) => route.isFirst);
    // Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    // if (!url.isCurrent) {
    //   Navigator.push(context, url.route);
    // } else {
    //   print('asd');
    // }
    // await Navigator.of(context).push(FadeRoute(page: WebViewScreen(url: url)));
    print('done');
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
