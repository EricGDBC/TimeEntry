// TODO: Time elapsed on card

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:time_entry_ui_examples/preferences/preferences.dart';
import 'package:time_entry_ui_examples/screens/help_center.dart';
import 'dart:collection';

import 'package:time_entry_ui_examples/tools/formatting.dart';
import 'package:time_entry_ui_examples/widgets/time_entry_drawer.dart';
import 'package:intl/intl.dart';

import 'confirm_work_order.dart';

class TimeEntry extends StatefulWidget {
  const TimeEntry({Key key}) : super(key: key);

  @override
  _TimeEntryState createState() => _TimeEntryState();
}

class _TimeEntryState extends State<TimeEntry> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  DateTime date;
  DateTime _timeStartedWorkOrder;
  DateTime _timeStartedBrake;
  DateTime _timeStartedLunch;

  DateTime _timeElapsedOrder;
  DateTime _timeElapsedBrake;
  DateTime _timeElapsedLunch;

  bool playButtonIsOn = true;
  bool onBreak = false;
  bool onLunch = false;

  String timeStartedWorkOrder = '';
  String timeStartedBrake = '';
  String timeStartedLunch = '';

  String timeElapsedOrder = '';
  String timeElapsedBrake = '';
  String timeElapsedLunch = '';

  Future<String> getWorkerName() async {
    Future<String> name = Preferences.getWorkerName();
    //name.toString();
    return name;
  }

  String getDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('EEEE, MMMM d');
    final String formatted = formatter.format(now);
    return formatted;
  }

  String getTimeRT() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('hh:mm a');
    final String formatted = formatter.format(now);
    return formatted;
  }

  String getTotalHoursWorked() {
    String h = 'Total Hours: 00:00';
    return h;
  }

  bool checkWorkerState() {
    if (onBreak || onLunch) {
      return false;
    }
    return true;
  }

  bool checkOnBrake() {
    if (onBreak) {
      return true;
    }
    return false;
  }

  bool checkOnLunch() {
    if (onLunch) {
      return true;
    }
    return false;
  }

  void backToWork() {
    onBreak = false;
    onLunch = false;
    return;
  }

  Future<void> _breakAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notice'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Select OK if you would like to begin your break.'),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    onBreak = true;
                    timeStartedBrake  =  DateFormat('hh:mm a').format(DateTime.now());
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _lunchAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notice'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Select OK if you would like to begin your lunch break.'),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    onLunch = true;
                    _timeStartedLunch = DateTime.now();
                    timeStartedLunch  =  DateFormat('hh:mm a').format(_timeStartedLunch);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Time Entry',
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          )
        ],
      ),
      drawer: TimeEntryDrawer(),
      body: FutureBuilder(
          future: getWorkerName(),
          builder: (BuildContext context, AsyncSnapshot<String> text) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Name
                    Text(
                      text.data,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, height: 1, fontSize: 18),
                    ),
                    const SizedBox(height: 7),

                    // The date
                    Text(getDate(),
                        style: const TextStyle(
                            color: Colors.blue, height: 1, fontSize: 21)),

                    // Running clock
                    StreamBuilder(
                        stream: Stream.periodic(const Duration(seconds: 1)),
                        builder: (context, snapshot) {
                          return Center(
                            child: Text(
                                DateFormat('h:mm a').format(DateTime.now()),
                                style: TextStyle(height: 2, fontSize: 19)),
                          );
                        }),

                    // Card
                    StreamBuilder(
                        stream: Stream.periodic(const Duration(seconds: 1)),
                        builder: (context, snapshot) {
                          return Flexible(
                            child: SizedBox(
                              width: 352.9,
                              height: 415,
                              child: Card(
                                color: Colors.white54,
                                elevation: 2,
                                margin: const EdgeInsets.all(5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: Colors.grey.withOpacity(.5),
                                    width: 2,
                                  ),
                                ),

                                // Card info depending on the state the worker is in
                                child: Column(
                                  children: [
                                    // Work Order
                                    Visibility(
                                      visible: checkWorkerState(),
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Column(
                                          children: [
                                            // Work Order Name and Play Button
                                            SizedBox(height: 10),
                                            ListTile(
                                              leading: const Visibility(
                                                maintainSize: true,
                                                maintainAnimation: true,
                                                maintainState: true,
                                                visible: false,
                                                child: Icon(
                                                  Icons.pending_actions,
                                                  color: Colors.black,
                                                  size: 45,
                                                ),
                                              ),
                                              title: Container(
                                                child: Text(
                                                  // displaye the work order name here
                                                  "Land Prep Chopper",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 24),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              trailing: Container(
                                                width: 50,
                                                padding: const EdgeInsets.only(
                                                    top: 0.0),
                                                child: FloatingActionButton(
                                                  onPressed: () {
                                                    // Start the timer, change the icon to the checkmark, make the bottom buttons appear depending on the conditions
                                                    setState(() {
                                                      if (playButtonIsOn ==
                                                          false) {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) {
                                                              return ConfirmWorkOrder();
                                                            },
                                                          ),
                                                        );
                                                        //playButtonIsOn = true;
                                                      }
                                                      playButtonIsOn =
                                                          !playButtonIsOn;
                                                      //getTotalHoursWorked();
                                                    });
                                                  },
                                                  //child: const Icon(Icons.play_arrow, color: Colors.black, size: 35,),
                                                  child: Icon(
                                                    playButtonIsOn
                                                        ? Icons.play_arrow
                                                        : Icons.check_outlined,
                                                    color: Colors.black,
                                                    size: 35,
                                                  ),
                                                  backgroundColor:
                                                      Colors.lightGreen,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      20.0))),
                                                ),
                                              ),
                                            ),

                                            // Work Order StopWatch
                                            SizedBox(height: 20),
                                            StreamBuilder(
                                                stream: Stream.periodic(
                                                    const Duration(seconds: 1)),
                                                builder: (context, snapshot) {
                                                  return Center(
                                                    child: Text(
                                                        DateFormat('h:mm:ss a')
                                                            .format(
                                                                DateTime.now()),
                                                        style: const TextStyle(
                                                            height: 2,
                                                            fontSize: 19)),
                                                  );
                                                }),

                                            // Ranch
                                            SizedBox(height: 20),
                                            Text('Ranch - 01',
                                                style: TextStyle(
                                                    height: 2, fontSize: 19)),

                                            // Block
                                            SizedBox(height: 20),
                                            Text('Block - 36',
                                                style: TextStyle(
                                                    height: 2, fontSize: 19)),

                                            // Materials
                                            SizedBox(height: 20),
                                            Text('Tools - Eliminator',
                                                style: TextStyle(
                                                    height: 2, fontSize: 19)),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Break Card
                                    Visibility(
                                      visible: checkOnBrake(),
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Column(
                                          children: [
                                            // Card Title
                                            SizedBox(height: 10),
                                            ListTile(
                                              leading: const Visibility(
                                                maintainSize: true,
                                                maintainAnimation: true,
                                                maintainState: true,
                                                visible: false,
                                                child: Icon(
                                                  Icons.pending_actions,
                                                  color: Colors.black,
                                                  size: 45,
                                                ),
                                              ),
                                              title: Container(
                                                child: Text(
                                                  // displaye the work order name here
                                                  "Break",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 24),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              trailing: Container(
                                                width: 50,
                                                padding: const EdgeInsets.only(
                                                    top: 0.0),
                                                child: Visibility(
                                                  maintainSize: true,
                                                  maintainAnimation: true,
                                                  maintainState: true,
                                                  visible: false,
                                                  child: FloatingActionButton(
                                                    //child: const Icon(Icons.play_arrow, color: Colors.black, size: 35,),
                                                    child: Icon(
                                                      playButtonIsOn
                                                          ? Icons.play_arrow
                                                          : Icons
                                                              .check_outlined,
                                                      color: Colors.black,
                                                      size: 35,
                                                    ),
                                                    backgroundColor:
                                                        Colors.lightGreen,
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20.0))),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // Break StopWatch
                                            SizedBox(height: 20),
                                            StreamBuilder(
                                                stream: Stream.periodic(
                                                    const Duration(seconds: 1)),
                                                builder: (context, snapshot) {
                                                  return Center(
                                                    child: Text(
                                                        DateFormat('h:mm:ss a')
                                                            .format(
                                                                DateTime.now()),
                                                        style: const TextStyle(
                                                            height: 2,
                                                            fontSize: 19)),
                                                  );
                                                }),

                                            // Break Timestamp
                                            SizedBox(height: 20),
                                            Container(
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text('Time Started - ', style: const TextStyle(
                                                        height: 2,
                                                        fontSize: 19)),
                                                    Text(
                                                        '$timeStartedBrake',
                                                        style: const TextStyle(
                                                            height: 2,
                                                            fontSize: 19)),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            // Ranch
                                            SizedBox(height: 20),
                                            Text('Ranch - 01',
                                                style: TextStyle(
                                                    height: 2, fontSize: 19)),

                                            // Block
                                            SizedBox(height: 20),
                                            Text('Block - 36',
                                                style: TextStyle(
                                                    height: 2, fontSize: 19)),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Lunch Card
                                    Visibility(
                                      visible: checkOnLunch(),
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Column(
                                          children: [
                                            // Work Order Name and Play Button
                                            SizedBox(height: 10),
                                            ListTile(
                                              leading: const Visibility(
                                                maintainSize: true,
                                                maintainAnimation: true,
                                                maintainState: true,
                                                visible: false,
                                                child: Icon(
                                                  Icons.pending_actions,
                                                  color: Colors.black,
                                                  size: 45,
                                                ),
                                              ),
                                              title: Container(
                                                child: Text(
                                                  // displaye the work order name here
                                                  "Lunch",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 24),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              trailing: Container(
                                                width: 50,
                                                padding: const EdgeInsets.only(
                                                    top: 0.0),
                                                child: Visibility(
                                                  maintainSize: true,
                                                  maintainAnimation: true,
                                                  maintainState: true,
                                                  visible: false,
                                                  child: FloatingActionButton(
                                                    //child: const Icon(Icons.play_arrow, color: Colors.black, size: 35,),
                                                    child: Icon(
                                                      playButtonIsOn
                                                          ? Icons.play_arrow
                                                          : Icons
                                                              .check_outlined,
                                                      color: Colors.black,
                                                      size: 35,
                                                    ),
                                                    backgroundColor:
                                                        Colors.lightGreen,
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20.0))),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // Work Order StopWatch
                                            SizedBox(height: 20),
                                            StreamBuilder(
                                                stream: Stream.periodic(
                                                    const Duration(seconds: 1)),
                                                builder: (context, snapshot) {
                                                  return Center(
                                                    child: Text(
                                                        DateFormat('h:mm:ss a')
                                                            .format(
                                                                DateTime.now()),
                                                        style: const TextStyle(
                                                            height: 2,
                                                            fontSize: 19)),
                                                  );
                                                }),

                                            // Lunch Timestamp
                                            SizedBox(height: 20),
                                            Container(
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text('Time Started - ', style: const TextStyle(
                                                        height: 2,
                                                        fontSize: 19)),
                                                    Text(
                                                        '$timeStartedLunch',
                                                        style: const TextStyle(
                                                            height: 2,
                                                            fontSize: 19)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            // Ranch
                                            SizedBox(height: 20),
                                            Text('Ranch - 01',
                                                style: TextStyle(
                                                    height: 2, fontSize: 19)),

                                            // Block
                                            SizedBox(height: 20),
                                            Text('Block - 36',
                                                style: TextStyle(
                                                    height: 2, fontSize: 19)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),

                    // Buttons for break/lunch/eod/
                    const SizedBox(height: 50),
                    StreamBuilder(
                        stream: Stream.periodic(const Duration(seconds: 1)),
                        builder: (context, snapshot) {
                          return Visibility(
                            visible: checkWorkerState(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // break button
                                Container(
                                  width: 90,
                                  child: Visibility(
                                    visible: !playButtonIsOn,
                                    child: FloatingActionButton(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0))),
                                      onPressed: _breakAlert,
                                      child: Image.asset(
                                        'lib/assets/images/break.png',
                                        height: 40,
                                        width: 40,
                                      ),
                                      backgroundColor: Colors.lightGreen,
                                    ),
                                  ),
                                ),

                                // lunch button
                                Container(
                                  width: 90,
                                  child: Visibility(
                                    visible: !playButtonIsOn,
                                    child: FloatingActionButton(
                                      onPressed: _lunchAlert,
                                      //child: const Icon(Icons.play_arrow, color: Colors.black, size: 35,),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0))),
                                      child: Image.asset(
                                        'lib/assets/images/lunch.png',
                                        height: 50,
                                        width: 50,
                                      ),
                                      backgroundColor: Colors.lightGreen,
                                    ),
                                  ),
                                ),

                                // end of day button
                                Container(
                                  width: 90,
                                  child: Visibility(
                                    visible: !playButtonIsOn,
                                    child: FloatingActionButton(
                                      onPressed: () {},
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0))),
                                      child: Image.asset(
                                        'lib/assets/images/eod.png',
                                        height: 55,
                                        width: 55,
                                      ),
                                      backgroundColor: Colors.lightGreen,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                    // return to work button
                    StreamBuilder(
                        stream: Stream.periodic(const Duration(seconds: 1)),
                        builder: (context, snapshot) {
                          return Visibility(
                            visible: !checkWorkerState(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // break button
                                Container(
                                  width: 90,
                                  child: FloatingActionButton(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0))),
                                    onPressed: backToWork,
                                    child: const Icon(
                                      Icons.keyboard_return_outlined,
                                      color: Colors.black,
                                      size: 45,
                                    ),
                                    backgroundColor: Colors.lightGreen,
                                  ),
                                ),
                              ],
                            ),
                          );
                        })
                  ],
                ),
              ),
            );
          }),
    );
  }
}
