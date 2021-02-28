import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:odes/models/accountListModel.dart';
import 'package:odes/screens/accounts_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:odes/widgets/routeTransitions/fade_route.dart';
import 'dart:async';

// import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _mockCheckForSession().then((status) {
      if (status) {
        _navigateToHome();
      } else {
        _navigateToLogin();
      }
    });
  }

  List<AccountList> accounts = List<AccountList>();

  Future<bool> _mockCheckForSession() async {
    await Future.delayed(Duration(seconds: 2));
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var res = (localStorage.getString('accounts') != null)
        ? jsonDecode(localStorage.getString('accounts'))
        : List<AccountList>();
    res.map((item) {
      setState(() {
        accounts.add(new AccountList.fromJson(item));
      });
    }).toList();
    bool isAuth = false;

    if (res.length > 0) {
      setState(() {
        isAuth = true;
      });
    }

    return isAuth;
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(FadeRoute(page: Accountscreen()));
    // Navigator.of(context).pushReplacement(FadeRoute(page: HomeScreen()));
    // Navigator.of(context).pushReplacement(
    //  MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(FadeRoute(page: LoginScreen()));
    // Navigator.of(context).pushReplacement(
    // MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset(0.7, 1.5),
                  colors: [
                    const Color(0xFF3BB5EC),
                    const Color(0xFF1366B7),
                    const Color(0xFF1366B7),
                  ],
                  tileMode: TileMode.clamp,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Image.asset("assets/icons/logo.png", width: 145),
            ),
          ],
        ),
      ),
    );
  }
}
