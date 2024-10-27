import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common/utils/loader_dialog.dart';
import '../../../common/utils/utils.dart';
import '../../../common/utils/variables.dart';

class VideoDownloader{
  Directory? appDocDir;
  String? downloadPath;

  Future<void> requestStoragePermission(context) async {
    final status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      appDocDir = await DownloadsPath.downloadsDirectory();
      String dateTimeString = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      downloadPath = appDocDir!.path + '/UhuruVideo$dateTimeString.mp4';
    } else {
      showSnackBar(content: "Storage permission required for downloading video", context: context);
      throw Exception('Storage permission required for downloading videos.');
    }
  }

  Future<void> downloadVideo(String videoUrl, context) async {
    await requestStoragePermission(context);

    try {
      LoaderDialog.showLoader(context!, Variables.keyLoader);

      final dio = Dio();
      final response = await dio.download(videoUrl, downloadPath);

      if (response.statusCode == 200) {
        Navigator.of(context, rootNavigator: true).pop();
        showSnackBar(content: "Download complete! File saved to: $downloadPath", context: context);
        debugPrint('Download complete! File saved to: $downloadPath');
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        showSnackBar(content: "Download failed", context: context);
        throw Exception('Download failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      showSnackBar(content: "Download failed", context: context);
      debugPrint('Download error: $e');
    }
  }

}
