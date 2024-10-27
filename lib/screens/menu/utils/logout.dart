import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/view/landing_screen.dart';

  logout(context) async {
    final _isar = await openIsar(); // Open your Isar instance

    await _isar!=null ?_isar!.close(deleteFromDisk: true):'ISAR EQUALS TO NULL';

    debugPrint(_isar!=null ?'ISAR DATA HAS BEEN DELETED':'ISAR EQUALS TO NULL');

    /// Clear user data stored in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();

    /// Navigate to the login screen
    Navigator.of(context).pushReplacement(
        CupertinoPageRoute(builder: (context) => const LandingScreen()));
    // Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }


Future<Isar?> openIsar() async {
  final isar = await Isar.getInstance();
  return isar!=null?isar:null;
}