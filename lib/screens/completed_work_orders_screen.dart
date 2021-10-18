import 'package:flutter/material.dart';
import 'package:time_entry_ui_examples/tools/formatting.dart';

class CompletedWorkOrders extends StatelessWidget {
  const CompletedWorkOrders({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Formatting.getAppBarStylingTitle(
            "Time Entry", "Completed Work Orders"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          "You have not completed any work orders",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
