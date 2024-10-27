
import 'package:flutter/material.dart';

class UploadStatus extends StatelessWidget {
  final bool isUploading;
  final bool isSuccess;
  final double progressionValue;

  UploadStatus({required this.isUploading, required this.isSuccess, required this.progressionValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Uploading a media...'),
        if (isUploading)
          LinearProgressIndicator(
            value: progressionValue,
          )
        else if (isSuccess)
          Icon(Icons.check_circle, color: Colors.green, size: 50)
        else
          Icon(Icons.error, color: Colors.red, size: 50),
      ],
    );
  }
}
