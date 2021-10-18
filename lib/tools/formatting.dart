import 'package:flutter/material.dart';

class Formatting {
  static String formatDateForUI(DateTime date) {
    String day = date.day.toString(), month = date.month.toString(), year = date.year.toString();
    return month + "/" + day + "/" + year;
  }

  static String formatDateForXML(DateTime date) {
    String day = date.day.toString(), month = date.month.toString(), year = date.year.toString();
    if (day.length == 1) {
      day = "0" + date.day.toString();
    }
    if (month.length == 1) {
      month = "0" + date.month.toString();
    }
    return year + "-" + month + "-" + day;
  }

  static String formatStringDateForXML(String date) {
    String month = date.substring(0, 2);
    String day = date.substring(3, 5);
    String year = date.substring(6);
    return year + "-" + month + "-" + day;
  }

  static String formatTimeForXML(String time) {
    String format;
    List<String> tokens = time.split(":");
    var amPm = tokens[1].split(" ")[1];
    var hour = int.parse(tokens[0]);
    var minute = tokens[1].split(" ")[0];
    if (amPm == "PM") {
      hour += 12;
    }
    if (amPm == "AM" && hour < 10) {
      format = "0" + hour.toString() + ":" + minute.toString();
    } else {
      format = hour.toString() + ":" + minute.toString();
    }
    return format.trim();
  }

  static String formatTimeForUI(String time) {
    String format;
    if (time.substring(0, 1) == "0") {
      format = time.substring(1, 5);
    } else {
      format = time.substring(0, 5);
    }
    var amPm = "AM";
    var hour = int.parse(time.substring(0, 2));
    if (hour > 12) {
      hour -= 12;
      amPm = "PM";
    }
    return format + " " + amPm;
  }

  static String formatRetrievedTimeForXML(String time) {
    String format;
    var amPm = time.substring(8);
    var hour = int.parse(time.substring(0, 2));
    var minute = time.substring(3, 5);
    if (amPm.trim() == "PM") {
      hour += 12;
    }
    if (amPm.trim() == "AM" && time.substring(0, 1).trim() == "0") {
      format = "0" + hour.toString() + ":" + minute.toString();
    } else {
      format = hour.toString() + ":" + minute.toString();
      print("format didn't need anything: $format");
    }
    return format;
  }

  static String formatTimeResponse(String time) {
    List<String> tokens = time.split(":");
    String hour = tokens[0];
    String minute = tokens[1].split(" ")[0];
    String second = "00";
    String amPm = tokens[1].split(" ")[1];
    if (amPm == "AM") {
      return int.parse(hour) < 10
          ? "0" + hour + ":" + minute + ":" + second
          : hour + ":" + minute + ":" + second;
    }
    if (amPm == "PM") {
      var tempHour = int.parse(hour);
      tempHour += 12;
      if (tempHour == 24) {
        return "00:" + minute + ":" + second;
      } else {
        return tempHour.toString() + ":" + minute + ":" + second;
      }
    }
  }

  static Widget getAppBarStylingTitle(String text1, String text2) {
    return Container(
      width: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              text1,
              style: TextStyle(fontSize: 14),
            ),
          ),
          Center(
            child: Text(
              text2,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  static Widget getAppBarTripleStylingTitle(String text1, String text2, String text3) {
    return Container(
      padding: EdgeInsets.only(top: 15, bottom: 10),
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              text1,
              style: TextStyle(fontSize: 14),
            ),
          ),
          Center(
            child: Text(
              text2,
              style: TextStyle(fontSize: 14),
            ),
          ),
          Center(
            child: Text(
              text3,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
