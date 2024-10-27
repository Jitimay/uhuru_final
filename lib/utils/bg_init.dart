import 'package:flutter_background_service/flutter_background_service.dart';

import 'bg_services.dart';

class BgInit {
  final service = FlutterBackgroundService();

  Future<void> initializeService() async {
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: BgServices.onStart,
        initialNotificationContent: "OBR",
        initialNotificationTitle: "EBMS",

        // auto start service
        autoStart: true,
        isForegroundMode: false,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: false,

        // this will be executed when app is in foreground in separated isolate
        onForeground: BgServices.onStart,

        // you have to enable background fetch capability on xcode project
        onBackground: BgServices.onIosBackground,
      ),
    );

    service.startService();
  }
}
