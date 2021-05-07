import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:load/load.dart';
import 'package:load/src/dismiss_future.dart';
import 'package:odes/models/accountListModel.dart';
import 'package:odes/screens/login_screen.dart';
import 'package:odes/screens/web_view_screen.dart';
import 'package:odes/widgets/routeTransitions/fade_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:odes/widgets/routeTransitions/fade_route.dart';
import 'package:odes/utils/networks/api.dart';
import 'dart:async';

// import 'home_screen.dart';
// import 'login_screen.dart';

class Accountscreen extends StatefulWidget {
  @override
  _AccountscreenState createState() => _AccountscreenState();
}

class _AccountscreenState extends State<Accountscreen> {
  @override
  void initState() {
    _getAccounts();
    super.initState();
  }

  bool _isLoading = false;
  bool _isSnackbarActive = false;
  String token = '';
  List<AccountList> accounts = List<AccountList>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController companyController =
      new TextEditingController(text: '');
  final TextEditingController emailController =
      new TextEditingController(text: '');
  final TextEditingController passwordController =
      new TextEditingController(text: '');

  _getAccounts() async {
    print('tetes');
    // SharedPreferences localStorage = await SharedPreferences.getInstance();
    // var res = (localStorage.getString('accounts') != null)
    //     ? jsonDecode(localStorage.getString('accounts'))
    //     : List<AccountList>();
    // res.map((item) {
    //   setState(() {
    //     accounts.add(new AccountList.fromJson(item));
    //   });
    // }).toList();

    // print(res.length);
    // print(res);
    // if (res.length == 0) {
    //   Navigator.of(context).pushReplacement(FadeRoute(page: LoginScreen()));
    // }
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
    return LoadingProvider(
      themeData: LoadingThemeData(
        tapDismiss: false,
      ),
      loadingWidgetBuilder: (ctx, data) {
        return Center(
          child: SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 84, 209, 219),
              ),
            ),
          ),
        );
      },
      child: Scaffold(
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
                  child: SizedBox(
                    child: Column(
                      children: [
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 3),
                            child: Column(
                              children: [
                                Container(
                                  height: 60,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 3),
                                          child: Text(
                                            (accounts.length > 1)
                                                ? 'User Accounts'
                                                : 'User Account',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 25,
                                                letterSpacing: 0.8),
                                          ),
                                        ),
                                        Spacer(),
                                        SvgPicture.asset(
                                          'assets/svg/triangle.svg',
                                          height: 17,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Divider(
                                    color: Colors.blueGrey[600],
                                    thickness: 1.5,
                                    height: 1,
                                  ),
                                ),
                                Container(
                                  constraints: BoxConstraints(maxHeight: 200),
                                  child: MediaQuery.removePadding(
                                    context: context,
                                    removeTop: true,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: accounts.length,
                                      itemBuilder: (context, index) {
                                        var account = accounts[index];
                                        return Material(
                                          child: InkWell(
                                            onDoubleTap: () async {
                                              showLoadingDialog();

                                              await Future.delayed(
                                                  Duration(seconds: 1));
                                              Navigator.of(context).push(
                                                  FadeRoute(
                                                      page: WebViewScreen(
                                                          url: account.url)));
                                              hideLoadingDialog();
                                            },
                                            child: Column(
                                              children: [
                                                new Container(
                                                  height: 65,
                                                  child: Center(
                                                      child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20),
                                                    child: Row(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              height: 40,
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 20,
                                                                backgroundImage:
                                                                    AssetImage(
                                                                        'assets/images/person.jpeg'),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    account
                                                                        .name,
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          13,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    account
                                                                        .companyUrl,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Spacer(),
                                                        InkWell(
                                                          child: Icon(
                                                            Icons.delete,
                                                            size: 18.0,
                                                            color: Colors
                                                                .grey[700],
                                                          ),
                                                          onTap: () {
                                                            confirmBox(context,
                                                                account);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                                ),
                                                Divider(
                                                  height: 1,
                                                  thickness: 0.7,
                                                  color: Colors.grey[600]
                                                      .withOpacity(0.6),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: FlatButton(
                            onPressed: () {
                              // Navigator.of(context).push(FadeRoute(
                              //     page:
                              //         WebViewScreen(url: 'https://google.com')));
                              Navigator.of(context).pushReplacement(
                                  FadeRoute(page: LoginScreen()));
                            },
                            minWidth: 120,
                            color: Color(0xFFF9CA08),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(
                                  color: Color(0xFFF9CA08),
                                  width: 1,
                                  style: BorderStyle.solid),
                            ),
                            child: setUpLoginButtonChild(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<LoadingDismissFuture> buildVisitWebWrapper() => showLoadingDialog();

  confirmBox(BuildContext context, account) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Are you confirm delete this account?"),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  minWidth: 90,
                  height: 30,
                  color: Colors.grey[500],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(
                        color: Colors.grey[500],
                        width: 1,
                        style: BorderStyle.solid),
                  ),
                  child: Text(
                    'CANCEL',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      accounts
                          .removeWhere((item) => item.email == account.email);
                    });
                    localStorage.setString('accounts', jsonEncode(accounts));
                    // Navigator.of(context).push(FadeRoute(
                    //     page:
                    //         WebViewScreen(url: 'https://google.com')));
                    Navigator.of(context).pop();
                    if (accounts.length == 0) {
                      Navigator.of(context)
                          .push(FadeRoute(page: LoginScreen()));
                    }
                  },
                  minWidth: 90,
                  height: 30,
                  color: Colors.red[500],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(
                        color: Colors.red[500],
                        width: 1,
                        style: BorderStyle.solid),
                  ),
                  child: Text(
                    'CONFIRM',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ));
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
      'Add Account',
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
    );
  }
}
