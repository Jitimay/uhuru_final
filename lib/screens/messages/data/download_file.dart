// import 'dart:io';

// import 'package:path_provider/path_provider.dart';

// class DownloadSave {
//   Future<void> downloadFile(String url) async {
//     String fileName = url.split('/').last;
//     try {
//       final response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         final bytes = response.bodyBytes;

//         // Get a temporary directory for the download
//         Directory tempDir = await getTemporaryDirectory();

//         String savePath = '${tempDir.path}/$fileName';
//         File file = File(savePath);
//         await file.create(recursive: true);
//         await file.writeAsBytes(bytes);

//         print('File downloaded successfully at: $savePath');
//       } else {
//         print('Failed to download file: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error downloading file: $e');
//     }
//   }
// }
