import 'package:flutter/material.dart';
import 'package:time_entry_ui_examples/preferences/preferences.dart';
import 'package:time_entry_ui_examples/screens/time_entry.dart';
import 'package:time_entry_ui_examples/tools/formatting.dart';
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

class ConfirmWorkOrder extends StatefulWidget {
  const ConfirmWorkOrder({Key key}) : super(key: key);

  @override
  State<ConfirmWorkOrder> createState() => _ConfirmWorkOrderState();
}

class _ConfirmWorkOrderState extends State<ConfirmWorkOrder> {
  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      appBar: AppBar(
        title: Formatting.getAppBarStylingTitle(
            "Time Entry", "Confirm Work Order"),
      ),
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

                    // Work Order Card
                    Flexible(
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

                          // Work Order Card
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
                                          color: Colors.blue, fontSize: 24),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  trailing: Container(
                                    width: 50,
                                    padding: const EdgeInsets.only(top: 0.0),
                                    child: Visibility(
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      visible: false,
                                      child: FloatingActionButton(
                                        onPressed: () {
                                          // Start the timer, change the icon to the checkmark, make the bottom buttons appear depending on the conditions
                                          setState(() {});
                                        },
                                        //child: const Icon(Icons.play_arrow, color: Colors.black, size: 35,),
                                        child: Icon(
                                          true
                                              ? Icons.play_arrow
                                              : Icons.check_outlined,
                                          color: Colors.black,
                                          size: 35,
                                        ),
                                        backgroundColor: Colors.lightGreen,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0))),
                                      ),
                                    ),
                                  ),
                                ),

                                // Work Order Time Stamp
                                SizedBox(height: 20),
                                StreamBuilder(
                                    stream: Stream.periodic(
                                        const Duration(seconds: 1)),
                                    builder: (context, snapshot) {
                                      return Center(
                                        child: Text(
                                            DateFormat('hh:mm')
                                                .format(DateTime.now()),
                                            style: const TextStyle(
                                                height: 2, fontSize: 19)),
                                      );
                                    }),

                                // Time Started
                                SizedBox(height: 20),
                                Text('Time Started - 6:00 AM',
                                    style: TextStyle(height: 2, fontSize: 19)),

                                // Ranch
                                SizedBox(height: 20),
                                Text('Ranch - 01',
                                    style: TextStyle(height: 2, fontSize: 19)),

                                // Block
                                SizedBox(height: 20),
                                Text('Block - 36',
                                    style: TextStyle(height: 2, fontSize: 19)),

                                // Materials
                                SizedBox(height: 20),
                                Text('Tools - Eliminator',
                                    style: TextStyle(height: 2, fontSize: 19)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Buttons to confirm the work order
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // break button
                        Container(
                          width: 90,
                          child: FloatingActionButton(
                            child: Icon(
                                Icons.check_outlined,
                                color: Colors.black,
                                size: 35,
                              ),
                            backgroundColor: Colors.lightGreen,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20.0))),
                            onPressed: () {
                              // Start the timer, change the icon to the checkmark, make the bottom buttons appear depending on the conditions
                              setState(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return TimeEntry();
                                    },
                                  ),
                                );

                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
