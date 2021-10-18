import 'package:flutter/material.dart';
import 'package:time_entry_ui_examples/screens/login_screen.dart';
import 'package:time_entry_ui_examples/screens/time_entry.dart';
import 'package:time_entry_ui_examples/services/service_locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Time Entry",
      home: LoginScreen(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, child) {
        // this doesnt allow dynamic text growth from phone settings.
        return MediaQuery(
          child: child,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      routes: {
        // routes are easier to use rather than Navigator.push(context, Material blah blah blah)
        '/login': (context) => LoginScreen(),
        '/timeentry': (context) => TimeEntry(),
      },
    );
  }
}