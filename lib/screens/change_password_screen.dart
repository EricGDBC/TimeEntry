import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:time_entry_ui_examples/preferences/preferences.dart';
import 'package:time_entry_ui_examples/services/webservices/mobile_password_update_ws.dart';
import 'package:time_entry_ui_examples/preferences/preferences.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChangePasswordScreenState();
  }
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController _oldPassword;
  TextEditingController _newPassword;
  TextEditingController _confirmNewPassword;

  bool canSubmitChange = true;

  @override
  void initState() {
    super.initState();
    _oldPassword = new TextEditingController();
    _newPassword = new TextEditingController();
    _confirmNewPassword = new TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _oldPassword.dispose();
    _newPassword.dispose();
    _confirmNewPassword.dispose();
  }

  Widget getTextField(
      TextEditingController controller, String hintText, Icon iconWidget) {
    return new Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: TextField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(icon: iconWidget, hintText: hintText),
      ),
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
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(fontSize: 20.0),
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

  void validateAndChange() async {
    this.canSubmitChange = false;
    if (_newPassword.text == _confirmNewPassword.text) {
      if (_newPassword.text.length >= 8) {
        var currentBytes = utf8.encode(_oldPassword.text);
        var currentDigest = sha256.convert(currentBytes);
        var newBytes = utf8.encode(_newPassword.text);
        var newDigest = sha256.convert(newBytes);

        String response = await MobilePasswordUpdateWS().call(
            Preferences.currentEmail,
            currentDigest.toString(),
            newDigest.toString());

        if (response == "1") {
          miscAlert(this.context, "Password successfully updated");
          setState(
                () {
              _oldPassword.clear();
              _newPassword.clear();
              _confirmNewPassword.clear();
            },
          );
        } else {
          miscAlert(this.context, "Error: Something went wrong.");
        }
      } else {
        miscAlert(this.context,
            "Password must be 8 or more characters. Spaces allowed.");
      }
    } else {
      miscAlert(this.context, "Passwords do not match.");
    }
    this.canSubmitChange = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: true,
        title: Text("Change Password"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 100,
            ),
            getTextField(
                _oldPassword,
                "Old Password",
                Icon(
                  Icons.account_circle,
                )),
            getTextField(
              _newPassword,
              "New Password",
              Icon(
                Icons.lock,
              ),
            ),
            getTextField(
              _confirmNewPassword,
              "Confirm New Password",
              Icon(
                Icons.lock,
              ),
            ),
            Container(
              height: 20,
            ),
            RaisedButton(
              child: Text(
                "Change",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () async => {
                if (canSubmitChange) {validateAndChange()}
              },
            ),
          ],
        ),
      ),
    );
  }
}
