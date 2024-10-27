// import 'package:flutter/material.dart';
// import 'package:uhuru/common/utils/environment.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class FileViewerScreen extends StatelessWidget {
//   final String filePath;
//
//   FileViewerScreen({required this.filePath});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text('File Viewer', style: TextStyle(color: Colors.black)),
//       ),
//       body: WebView(
//         initialUrl:
//             '${Uri.parse(Environment.urlHost).resolve(filePath).toString()}',
//         javascriptMode: JavascriptMode.unrestricted,
//       ),
//     );
//   }
// }
