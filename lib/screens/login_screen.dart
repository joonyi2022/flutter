import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:odes/models/accountListModel.dart';
import 'package:odes/screens/accounts_screen.dart';
import 'package:odes/screens/web_view_screen.dart';
import 'package:odes/widgets/routeTransitions/fade_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:odes/widgets/routeTransitions/fade_route.dart';
import 'package:odes/utils/networks/api.dart';
import 'dart:async';

// import 'home_screen.dart';
// import 'login_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    _getAccounts();

    super.initState();
  }

  List<AccountList> accounts = List<AccountList>();

  bool _isLoading = false;
  bool _isSnackbarActive = false;
  String token = '';

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController companyController =
      new TextEditingController(text: '');
  final TextEditingController emailController =
      new TextEditingController(text: '');
  final TextEditingController passwordController =
      new TextEditingController(text: '');

  _getAccounts() async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    await _firebaseMessaging.getToken().then((value) {
      setState(() {
        print(value);
        token = value;
      });
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var res = (localStorage.getString('accounts') != null)
        ? jsonDecode(localStorage.getString('accounts'))
        : List<AccountList>();
    res.map((item) {
      setState(() {
        accounts.add(new AccountList.fromJson(item));
      });
    }).toList();
  }

  _snackbar(msg, {Color color = Colors.grey, action = true}) {
    final snackBar = SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
      action: action == false
          ? null
          : SnackBarAction(
              label: 'Close',
              textColor: Colors.white,
              onPressed: () {
                // Some code to undo the change!
              },
            ),
    );
    _isSnackbarActive = true;
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState
        .showSnackBar(snackBar)
        .closed
        .then((SnackBarClosedReason reason) {
      // snackbar is now closed.
      _isSnackbarActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
            Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Image.asset(
                        "assets/icons/logo.png",
                        width: 160,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 35, bottom: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 300,
                              margin: EdgeInsets.all(8.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Company url is required';
                                  }
                                  return null;
                                },
                                controller: companyController,
                                autocorrect: true,
                                style: TextStyle(color: Colors.grey[600]),
                                decoration: InputDecoration(
                                  hintText: "yourcompany.odes.com",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13,
                                  ),
                                  prefixIconConstraints: BoxConstraints(
                                      minWidth: 23, maxHeight: 20),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 10),
                                    child: SvgPicture.asset(
                                      'assets/svg/globe-min.svg',
                                      height: 17,
                                      width: 17,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 22, vertical: 10),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 0.4),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    borderSide: BorderSide(
                                        color: Colors.red[400], width: 2),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    borderSide: BorderSide(
                                        color: Colors.red[400], width: 1.5),
                                  ),
                                  errorStyle: TextStyle(color: Colors.red[400]),
                                ),
                              ),
                            ),
                            Container(
                              width: 300,
                              margin: EdgeInsets.all(8.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'E-mail field is required';
                                  }
                                  // var email = value;
                                  // bool emailValid = RegExp(
                                  //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  //     .hasMatch(email);
                                  // if (!emailValid) {
                                  //   return 'E-mail must be valid';
                                  // }
                                  return null;
                                },
                                controller: emailController,
                                style: TextStyle(color: Colors.grey[600]),
                                decoration: InputDecoration(
                                  hintText: "Your e-mail address",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13,
                                  ),
                                  prefixIconConstraints: BoxConstraints(
                                      minWidth: 23, maxHeight: 20),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 10),
                                    child: SvgPicture.asset(
                                      'assets/svg/mail-min.svg',
                                      height: 12,
                                      width: 12,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 22, vertical: 10),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 0.4),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    borderSide: BorderSide(
                                        color: Colors.red[400], width: 2),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    borderSide: BorderSide(
                                        color: Colors.red[400], width: 1.5),
                                  ),
                                  errorStyle: TextStyle(color: Colors.red[400]),
                                ),
                              ),
                            ),
                            Container(
                              width: 300,
                              margin: EdgeInsets.all(8.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Password field is required';
                                  }
                                  if (value.length < 6) {
                                    return 'Password lenght must be greater than 6';
                                  }
                                  return null;
                                },
                                controller: passwordController,
                                obscureText: true,
                                style: TextStyle(color: Colors.grey[600]),
                                decoration: InputDecoration(
                                  hintText: "Your password",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13,
                                  ),
                                  prefixIconConstraints: BoxConstraints(
                                      minWidth: 23, maxHeight: 20),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 10),
                                    child: SvgPicture.asset(
                                      'assets/svg/lock-min.svg',
                                      height: 20,
                                      width: 20,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 22, vertical: 10),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 0.4),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    borderSide: BorderSide(
                                        color: Colors.red[400], width: 2),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    borderSide: BorderSide(
                                        color: Colors.red[400], width: 1.5),
                                  ),
                                  errorStyle: TextStyle(color: Colors.red[400]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          signIn(companyController.text, emailController.text,
                              passwordController.text);
                        }
                      },
                      minWidth: 120,
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(
                            color: Colors.white,
                            width: 1,
                            style: BorderStyle.solid),
                      ),
                      child: setUpLoginButtonChild(),
                    ),
                    if (accounts.length > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: FlatButton(
                          onPressed: () {
                            // Navigator.of(context).push(FadeRoute(
                            //     page:
                            //         WebViewScreen(url: 'https://google.com')));
                            Navigator.of(context)
                                .push(FadeRoute(page: Accountscreen()));
                          },
                          minWidth: 60,
                          height: 25,
                          color: Color(0xFFF9CA08),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: BorderSide(
                                color: Color(0xFFF9CA08),
                                width: 1,
                                style: BorderStyle.solid),
                          ),
                          child: Text(
                            'Back',
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget setUpLoginButtonChild() {
    if (_isLoading == true) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.white,
          ),
        ),
      );
    }
    return Text(
      'Login',
      style: TextStyle(
          color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
    );
  }

  signIn(company, email, password) async {
    // If the form is valid, display a snackbar. In the real world,
    // you'd often call a server or save the information in a database.
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    await _firebaseMessaging.getToken().then((value) {
      setState(() {
        print(value);
        token = value;
      });
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    setState(() {
      _isLoading = true;
    });
    // showLoadingDialog();
    String sample = company;
    var lastCharacter =
        sample.substring((sample.length - 1).clamp(0, sample.length));
    if (lastCharacter == '/') {
      company = sample.substring(0, sample.length - 1);
    }

    var data = {
      'company_url_name': company,
      'email': email,
      'password': password,
      'registration_id': token
    };

    var resCheck = await Network()
        .authData(data, 'https://login-odes.sgeede.com/api/auth-db');
    var bodyCheck = json.decode(resCheck.body);
    if (bodyCheck['code'] != 200) {
      print(json.encode(bodyCheck));
      if (!_isSnackbarActive) {
        _snackbar(bodyCheck['message'], color: Colors.red[600]);
      }

      setState(() {
        _isLoading = false;
      });

      return;
    }

    print(company + '/api/auth-login');
    var res = await Network().authData(data, company + '/api/auth-login');
    var body = json.decode(res.body);

    if (body['code'] == 200) {
      _isSnackbarActive = false;
      body['companyUrl'] = company;
      body['email'] = email;
      body['password'] = password;
      body['registrationid'] = token;

      List<AccountList> accounts = List<AccountList>();

      var res = (localStorage.getString('accounts') != null)
          ? jsonDecode(localStorage.getString('accounts'))
          : List<AccountList>();

      res.map((item) {
        setState(() {
          accounts.add(new AccountList.fromJson(item));
        });
      }).toList();

      if (accounts.indexWhere((element) => element.email == body['email']) ==
          -1) {
        print('new');
        accounts.add(AccountList.fromJson(body));
      } else {
        print('update');
        accounts[accounts
                .indexWhere((element) => element.email == body['email'])] =
            AccountList.fromJson(body);
      }

      localStorage.setString('accounts', jsonEncode(accounts));
      // String data = localStorage.getString('accounts');
      // print(data);
      _snackbar('Logged in successfully',
          color: Colors.green[400], action: false);
      // hideLoadingDialog();
      await Future.delayed(Duration(seconds: 2));
      Navigator.of(context)
          .push(FadeRoute(page: WebViewScreen(url: body['url'])));
    } else {
      print(json.encode(body));
      if (!_isSnackbarActive) {
        _snackbar(body['message'], color: Colors.red[600]);
      }

      setState(() {
        _isLoading = false;
      });
      //   // hideLoadingDialog();
    }
  }
}
