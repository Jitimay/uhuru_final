// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/services.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityCheck extends GetxController {
  ///List all the available connection status default equal to[ConnectivityResult.none]
  // List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  final _mounted = false.obs;
  var connectionStatus = Rx<List<ConnectivityResult>>([]);
  ConnectivityResult? connectivityResult;
  bool get mounted => _mounted.value;
  final _haveData = Rx<bool>(false);
  final _isFirstRun = Rx<bool>(true);
  final _hasConnection = Rx<bool>(true);
  final _hasOptionListData = Rx<bool>(false);
  final _isMethodSelected = Rx<bool>(false);
  final _isChoiceSelected = Rx<bool>(false);
  final _isLoading = Rx<bool>(false);
  dynamic scaffoldKey;

  ConnectivityCheck({
    this.scaffoldKey,
  });
  bool get isLoading => _isLoading.value;
  bool get haveData => _haveData.value;
  bool get isFirstRun => _isFirstRun.value;
  bool get hasConnection => _hasConnection.value;
  bool get hasOptionListData => _hasOptionListData.value;
  bool get isMethodSelected => _isMethodSelected.value;
  bool get isChoiceSelected => _isChoiceSelected.value;

  set isLoadingSet(bool value) => _isLoading.value = value;
  set isMethodSelectedSet(bool value) => _isMethodSelected.value = value;
  set hasOptionListDataSet(bool value) => _hasOptionListData.value = value;
  set hasConnectionSet(bool value) => _hasConnection.value = value;
  set isFirstRunSet(bool value) => _isFirstRun.value = value;
  set haveDataSet(bool value) => _haveData.value = value;
  set isChoiceSelectedSet(bool value) => _isChoiceSelected.value = value;
  set mountedValue(value) {
    _mounted.value = value;
  }

  ///Stream the connectivity result
  // ignore: unused_field
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  /// initialize the connectity status

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> results;
    try {
      results = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('imposible to check the network status', error: e);
      return;
    }
    if (mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(results);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    connectionStatus.value = result;
    connectivityResult = result[0];
    if (connectivityResult == ConnectivityResult.none) {
      hasConnectionSet = false;
      Get.snackbar('connection state', 'verifier votre connection');
    }

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      isFirstRunSet = false;
      update();

      Get.snackbar('connection state', "connection restaure");
    }
    // if (haveData == true &&
    //         hasConnection == false &&
    //         connectivityResult == ConnectivityResult.wifi ||
    //     connectivityResult == ConnectivityResult.mobile) {
    //   GlobalFunction.showSnackBar(scaffoldKey, 'connection restaure');
    // }
    // if (haveData == false &&
    //         isFirstRun == true &&
    //         connectivityResult == ConnectivityResult.wifi ||
    //     connectivityResult == ConnectivityResult.mobile) {
    //   GlobalFunction.showSnackBar(scaffoldKey, 'connection restaure');
    //   update();
    // }

    // ignore: duplicate_ignore
    // ignore: avoid_print
    print('Connectivity changed: ${connectionStatus.value}');
    print('that is connectivity result value ===>>>> $connectivityResult');
  }

  @override
  void onInit() {
    super.onInit();

    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    super.dispose();
    isFirstRunSet = true;
  }
}
