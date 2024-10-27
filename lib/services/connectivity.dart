import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:uhuru/screens/channels/apis/channel_apis.dart';
import 'package:uhuru/services/fetching.dart';

import '../common/utils/variables.dart';

Future<void> initConnectivity() async {
  try {
    var result = await Connectivity().checkConnectivity();
    updateConnectionStatus(result);
  } catch (e) {
    debugPrint("Could not check connectivity: $e");
  }
}

void updateConnectionStatus(result) {
  Variables.connectionStatus = result;
  Variables.isOnline = result != ConnectivityResult.none;

  if (Variables.isOnline) {
    debugPrint("*******CONNECTED*******IS ONLINE: ${Variables.isOnline}");
  } else {
    debugPrint("*******NO CONNECTION*******IS ONLINE: ${Variables.isOnline}");
  }
}

void listenToConnectivityChanges() {
  Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
    if (results.isNotEmpty) {
      updateConnectionStatus(results.first); // or however you'd like to handle the list
    }
  });
}

connectivitySubscription() {
  Variables.connectivitySubscription = Connectivity().onConnectivityChanged.listen(
    (result) {
      Variables.connectionStatus = result;
      debugPrint('CONNECTIVITY STATUS --------> ${Variables.connectionStatus}');
      // Notify listeners or update UI based on the new status
    },
  );
  if (AdaptiveTheme.getThemeMode() == AdaptiveThemeMode.dark) {
    Variables.isDarkMode = true;
    setDarkMode(true);
  } else {
    Variables.isDarkMode = false;
    setDarkMode(false);
  }
}
