import 'package:flutter/material.dart';
import 'package:time_entry_ui_examples/tools/formatting.dart';

class HelpCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Formatting.getAppBarStylingTitle(
            "Time Entry", "Help Center"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          "Help center is in progress. Please check back later.",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
