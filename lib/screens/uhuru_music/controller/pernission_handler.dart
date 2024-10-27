import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  Future<bool> isStoragePermission() async {
    var isStorage = await Permission.storage.status;
    var isAccLc = await Permission.accessMediaLocation.status;
    var isMngExtr = await Permission.manageExternalStorage.status;
    if (!isStorage.isGranted || !isAccLc.isGranted || !isMngExtr.isGranted) {
      await Permission.storage.request();
      await Permission.accessMediaLocation.request();
      await Permission.manageExternalStorage.request();
      if (!isStorage.isGranted || !isAccLc.isGranted || !isMngExtr.isGranted) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }
}
