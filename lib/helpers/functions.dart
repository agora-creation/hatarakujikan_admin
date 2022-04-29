import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

void nextScreen(BuildContext context, Widget widget) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
  );
}

void changeScreen(BuildContext context, Widget widget) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
      fullscreenDialog: true,
    ),
  );
}

void overlayScreen(BuildContext context, Widget widget) {
  showMaterialModalBottomSheet(
    expand: true,
    enableDrag: false,
    context: context,
    builder: (context) => widget,
  );
}

String randomString(int length) {
  const _randomChars =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  const _charsLength = _randomChars.length;
  final rand = Random();
  final codeUnits = List.generate(
    length,
    (index) {
      final n = rand.nextInt(_charsLength);
      return _randomChars.codeUnitAt(n);
    },
  );
  return String.fromCharCodes(codeUnits);
}

Future<String?> getPrefs(String key) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  return _prefs.getString(key);
}

Future<void> setPrefs(String key, String value) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  _prefs.setString(key, value);
}

Future<void> removePrefs(String key) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  _prefs.remove(key);
}

DateTime rebuildDate(DateTime? date, DateTime? time) {
  DateTime _ret = DateTime.now();
  if (date != null && time != null) {
    String _date = dateText('yyyy-MM-dd', date);
    String _time = '${dateText('HH:mm', time)}:00.000';
    _ret = DateTime.parse('$_date $_time');
  }
  return _ret;
}

DateTime rebuildTime(BuildContext context, DateTime? date, String? time) {
  DateTime _ret = DateTime.now();
  if (date != null && time != null) {
    String _date = dateText('yyyy-MM-dd', date);
    String _time = '${time.padLeft(5, '0')}:00.000';
    _ret = DateTime.parse('$_date $_time');
  }
  return _ret;
}

List<int> timeToInt(DateTime? dateTime) {
  List<int> _ret = [0, 0];
  if (dateTime != null) {
    String _h = dateText('H', dateTime);
    String _m = dateText('m', dateTime);
    _ret = [int.parse(_h), int.parse(_m)];
  }
  return _ret;
}

String twoDigits(int n) => n.toString().padLeft(2, '0');

// DateTime => Timestamp
Timestamp convertTimestamp(DateTime date, bool end) {
  String _dateTime = '${dateText('yyyy-MM-dd', date)} 00:00:00.000';
  if (end == true) {
    _dateTime = '${dateText('yyyy-MM-dd', date)} 23:59:59.999';
  }
  return Timestamp.fromMillisecondsSinceEpoch(
    DateTime.parse(_dateTime).millisecondsSinceEpoch,
  );
}

String dateText(String format, DateTime? date) {
  String _ret = '';
  if (date != null) {
    _ret = DateFormat(format, 'ja').format(date);
  }
  return _ret;
}

void customSnackBar(BuildContext context, String? message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message ?? '')),
  );
}
