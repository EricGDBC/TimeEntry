import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_entry_ui_examples/services/user_commodities_service.dart';
import 'package:time_entry_ui_examples/screens/time_entry.dart';
import '../services/local_authentication.dart';
import '../preferences/preferences.dart';
import '../services/service_locator.dart';

//webServices
import 'package:time_entry_ui_examples/services/webservices/mobile_get_user_id_ws.dart';
import 'package:time_entry_ui_examples/services/webservices/mobile_login_ws.dart';
import 'package:time_entry_ui_examples/services/webservices/mobile_password_reset_ws.dart';
import 'package:time_entry_ui_examples/services/webservices/webservice.dart';

import 'dart:io';


class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController;
  TextEditingController _passwordController;

  bool emailValidate = false, passwordValidate = false;

  final LocalAuthenticationService _localAuth = locator<LocalAuthenticationService>();

  @override
  void initState() {
    super.initState();
    _emailController = new TextEditingController();
    _passwordController = new TextEditingController();
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
  }

  Future<void> miscAlert(BuildContext context, String message) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Alert',
            textAlign: TextAlign.center,
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
          ),
          actions: [
            FlatButton(
              child: Text(
                'OK',
              ),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: FutureBuilder(
        future: Preferences.getEmail(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container(
              child: Center(
                child: Text("Retrieving Data ..."),
              ),
            );
          } else if (snapshot.hasError) {
            return Container(
              child: Center(
                child: Text("An error has occured. Please try again later."),
              ),
            );
          } else {
            if (snapshot.data != "temp_id") _emailController.text = snapshot.data;
            return Center(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(left: 40, right: 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          "Sign In",
                          style: TextStyle(color: Colors.blue, fontSize: 22),
                        ),
                      ),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          icon: Icon(Icons.account_circle),
                          hintText: 'Email address',
                          errorText: emailValidate ? 'Email field can\'t be empty' : null,
                          suffixIcon: IconButton(
                            onPressed: _emailController.clear,
                            icon: Icon(Icons.clear),
                          ),
                        ),
                      ),
                      TextField(
                        obscureText: true,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.lock,
                          ),
                          labelText: 'Password',
                          errorText: passwordValidate ? 'Password field can\'t be empty' : null,
                        ),
                      ),
                      Container(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: DialogButton(
                              color: Preferences.preferredColor,
                              onPressed: () async {
                                if (_emailController.text.isNotEmpty &
                                _passwordController.text.isNotEmpty) {
                                  if (_emailController.text.contains('@')) {
                                    var bytes = utf8.encode(_passwordController.text.toString());
                                    var digest = sha256.convert(bytes);
                                    // start load
                                    String userEmail = _emailController.text;
                                    var response =
                                    await MobileLoginWS().call(userEmail, digest.toString());
                                    // end load
                                    if (response == "1") {
                                      String userID = await MobileGetUserIDWS().call(userEmail);
                                      if (userID.length == 0) {
                                        // the length should never be 0. This check is only for precaution.
                                        miscAlert(context,
                                            "Unable to retrieve userID. Please contact the IT department if this issue reoccurs.");
                                      } else {
                                        await Preferences.getPreferences();
                                        Preferences.savePreferences(userEmail, userID);
                                        await UserCommoditiesService.call();
                                        int district = await Webservice()
                                            .fetchLocation(_emailController.text.trim());
                                        Preferences.saveDefaultDistrict(district);
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            // once user logs in
                                            builder: (_) {
                                              //
                                              // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                                              return TimeEntry();
                                            },
                                          ),
                                        );
                                      }
                                    } else {
                                      SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                      prefs.setString('email', "temp_id");
                                      prefs.setString('userID', "temp_user");
                                      miscAlert(context, "Invalid information.");
                                    }
                                  } else {
                                    miscAlert(context, "Please enter a valid email address.");
                                  }
                                } else if (_emailController.text.isEmpty) {
                                  setState(
                                        () {
                                      emailValidate = true;
                                    },
                                  );
                                } else if (_passwordController.text.isEmpty) {
                                  setState(
                                        () {
                                      passwordValidate = true;
                                    },
                                  );
                                } else {
                                  setState(
                                        () {
                                      print("fields empty");
                                      _emailController.clear();
                                      _passwordController.clear();
                                    },
                                  );
                                }
                              },
                              child: Text(
                                "Sign In",
                                style: TextStyle(color: Colors.white, fontSize: 19),
                              ),
                            ),
                          ),
                          Container(
                            width: 10,
                          ),
                          Flexible(
                            child: DialogButton(
                              color: Colors.transparent,
                              child: Text("Forgot password", style: TextStyle(fontSize: 13)),
                              onPressed: () async {
                                String email = _emailController.text;
                                if (email.isNotEmpty) {
                                  String result = await MobilePasswordResetWS().call(email);
                                  if (result == "1") {
                                    miscAlert(context, "A new password has been sent to $email");
                                  } else {
                                    miscAlert(context, "Password reset failed.");
                                  }
                                  _emailController.clear();
                                } else {
                                  miscAlert(context, "Please enter an email or username.");
                                  setState(
                                        () {
                                      emailValidate = true;
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                          Container(
                            width: 10,
                          ),
                          Flexible(
                            child: DialogButton(
                              color: Colors.transparent,
                              child: Text("Touch or Face ID", style: TextStyle(fontSize: 12)),
                              onPressed: () async {
                                await Preferences.getPreferences();
                                bool hasLogged = await Preferences.emailExists();
                                if (Preferences.currentEmail == _emailController.text) {
                                  if (hasLogged) {
                                    _localAuth.authenticate().then(
                                          (value) async {
                                        if (value) {
                                          await Preferences.getPreferences();
                                          int district = await Webservice()
                                              .fetchLocation(_emailController.text.trim());
                                          Preferences.saveDefaultDistrict(district);
                                          await UserCommoditiesService.call();
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              // route time entry screen once logged in
                                              builder: (_) {
                                                //SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                                                return TimeEntry();
                                              },
                                            ),
                                          );
                                        } else {
                                          print("unable to login with face id");
                                        }
                                      },
                                    );
                                  } else {
                                    miscAlert(context, "Login with a valid user ID and password.");
                                  }
                                } else {
                                  miscAlert(context, "Login with a valid user ID and password.");
                                }
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
