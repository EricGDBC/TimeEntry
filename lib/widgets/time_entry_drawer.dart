import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:time_entry_ui_examples/preferences/preferences.dart';
import 'package:time_entry_ui_examples/screens/change_password_screen.dart';
import 'package:time_entry_ui_examples/screens/completed_work_orders_screen.dart';
import 'package:time_entry_ui_examples/screens/help_center.dart';

enum Language { english, spanish }

class TimeEntryDrawer extends StatefulWidget {
  const TimeEntryDrawer({Key key}) : super(key: key);

  @override
  _TimeEntryDrawerState createState() => _TimeEntryDrawerState();
}

class _TimeEntryDrawerState extends State<TimeEntryDrawer> {
  String version = "1.0.0"; // using prev developer's method
  Language _character = Language.english;
  String _userID = '';
  String _userEmail = '';


  void getWorkerEmail() async {
    var email = await Preferences.getEmail();
    _userEmail = email;
    //name.toString();
    return;
  }

  void getWorkerID() async {
    var userID = await Preferences.getID();
    _userID = userID;
    //name.toString();
    return;
  }

  @override
  void initState() {
    super.initState();
    setState(
      () {
        Preferences.getPreferences();
      },
    );
    getVersion();
  }

  void getVersion() async {
    // using previous developer's method
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(
      () {
        version = packageInfo.version;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    getWorkerEmail();
    getWorkerID();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text(
              "Menu",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
              ),
            ),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return ChangePasswordScreen();
                  },
                ),
              );
            },
            child: Center(
              child: Text(
                "Change Password",
                style: TextStyle(color: Colors.blue, fontSize: 24),
              ),
            ),
          ),
          Container(
            height: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return HelpCenter();
                  },
                ),
              );
            },
            child: Center(
              child: Text(
                "Help Center",
                style: TextStyle(color: Colors.blue, fontSize: 24),
              ),
            ),
          ),
          Container(
            height: 10,
          ),

          // View completed work orders
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CompletedWorkOrders();
                  },
                ),
              );
            },
            child: const Center(
              child: Text(
                "View Completed\n   Work Orders",
                style: TextStyle(color: Colors.blue, fontSize: 24),
              ),
            ),
          ),
          Container(
            height: 10,
          ),
          SizedBox(height: 5),

          // User information(Email, ID, Version)
          Column(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("User Email", style: TextStyle(fontWeight: FontWeight.bold, height: 2)),
                    Text(_userEmail),
                  ],
                ),
              ),

              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("User ID", style: TextStyle(fontWeight: FontWeight.bold, height: 2)),
                    Text(_userID),
                  ],
                ),
              ),

              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Version", style: TextStyle(fontWeight: FontWeight.bold, height: 2)),
                    Text("$version"),
                  ],
                ),
              ),
            ],
          ),

          // Language option with radio buttons
          Container(
            padding: const EdgeInsets.all(15.0),
            child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Language/Idioma", style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold, height: 1)),
                  // Languages
                  ListTile(
                    title: const Text('English'),
                    leading: Radio<Language>(
                      value: Language.english,
                      groupValue: _character,
                      onChanged: (Language value) {
                        setState(() {
                          _character = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Español'),
                    leading: Radio<Language>(
                      value: Language.spanish,
                      groupValue: _character,
                      onChanged: (Language value) {
                        setState(() {
                          _character = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
          ),
        ],
      ),
    );
  }
}
