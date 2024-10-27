import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../../../../common/utils/variables.dart';
import 'confirm_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddVideoScreen extends StatefulWidget {
  const AddVideoScreen({Key? key}) : super(key: key);


  @override
  State<AddVideoScreen> createState()=> AddVideoScreenState();
}

class AddVideoScreenState extends State<AddVideoScreen>{

  final FlutterVideoInfo videoInfo = FlutterVideoInfo();

  Future<void> pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    if (video != null) {
      final videoPath = video.path;

      // Check the duration of the video
      final duration = await getVideoDuration(videoPath);

      if (duration > 60) {
        // Trim the video if it's longer than 1 minute
        debugPrint('CURRENT VIDEO PATH $videoPath');
        final trimmedPath = videoPath;
        // final trimmedPath = await trimVideo(videoPath);

        if (trimmedPath != null) {
          // Use the trimmed video
          Variables.base64Video = trimmedPath;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ConfirmScreen(
                videoFile: File(trimmedPath),
                videoPath: trimmedPath,
              ),
            ),
          );
        } else {
          print('Failed to trim video.');
        }
      } else {
        // Use the original video
        Variables.base64Video = videoPath;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ConfirmScreen(
              videoFile: File(videoPath),
              videoPath: videoPath,
            ),
          ),
        );
      }
    } else {
      print('No video selected.');
    }
  }

  Future<int> getVideoDuration(String videoPath) async {
    // Get video info using flutter_video_info
    var info = await videoInfo.getVideoInfo(videoPath);

    if (info != null && info.duration != null) {
      return (info.duration! ~/ 1000); // Convert milliseconds to seconds
    }
    throw Exception('Failed to get video duration.');
  }

  Future<String?> trimVideo(String videoPath) async {
    final trimmedPath = '${path.withoutExtension(videoPath)}_trimmed.mp4';
    debugPrint('CURRENT VIDEO PATH $videoPath');
    // Use the video_trim package to trim the video
    final bool success = true;
    // (await VideoTrim.trim(
    //     videoPath,
    //     startMilliseconds: 0,
    //     endMilliseconds: 60000
    // )) as bool;
    debugPrint('CURRENT VIDEO PATH $videoPath');

    if (success) {
      print('Video trimmed successfully: $trimmedPath');
      return trimmedPath;
    } else {
      print('Failed to trim video.');
      return null;
    }
  }

  pickImage(ImageSource src, BuildContext context) async {
    final image = await ImagePicker().pickImage(source: src);
    if (image != null) {
      setState(() {
        Variables.isPickingVideo = false;
      });
      final file = File(image.path);
      List<int> videoBytes = await file.readAsBytes();
      // Variables.base64Video = await base64Encode(videoBytes);
      Variables.base64Video = image.path;
      debugPrint('BASE64Video++++++${Variables.base64Video}++++++++');
      // Use the base64Video string as needed
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConfirmScreen(
            videoFile: File(image.path),
            videoPath: image.path,
          ),
        ),
      );
    } else {
      // Handle error
    }
  }

  showOptionsDialog(BuildContext context) {
    // ignore: unused_local_variable
    final backgroundTheme = Theme.of(context).colorScheme.background;
    final textColor =
    Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20);
    final iconColor = Theme.of(context).colorScheme.onBackground;
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          SimpleDialogOption(
            onPressed: () => Variables.isPickingImage? pickImage(ImageSource.gallery, context): pickVideo(ImageSource.gallery, context),
            child: Row(
              children: [
                Icon(
                  Icons.image,
                  color: iconColor,
                ),
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text(AppLocalizations.of(context)!.galery,
                      style: textColor),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Variables.isPickingImage? pickImage(ImageSource.camera, context): pickVideo(ImageSource.camera, context),
            child: Row(
              children: [
                Icon(
                  Icons.camera_alt,
                  color: iconColor,
                ),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(AppLocalizations.of(context)!.camera,
                      style: textColor),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              setState(() {
                Variables.isPickingImage = false;
                Variables.isPickingVideo = false;
              });
              Navigator.of(context).pop();
            },
            child: Row(
              children: [
                Icon(
                  Icons.cancel,
                  color: iconColor,
                ),
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundTheme = Theme.of(context).colorScheme.background;
    final textColor =
    Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20);
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                setState(() {
                  Variables.isPickingImage = false;
                  Variables.isPickingVideo = true;
                });
                await showOptionsDialog(context);
              },
              child: Container(
                width: 190,
                height: 50,
                decoration: BoxDecoration(color: backgroundTheme),
                child: Center(
                  child: Text(AppLocalizations.of(context)!.addvideo,
                      style: textColor),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                setState(() {
                  Variables.isPickingVideo = false;
                  Variables.isPickingImage = true;
                });
                await showOptionsDialog(context);
              },
              child: Container(
                width: 190,
                height: 50,
                decoration: BoxDecoration(color: backgroundTheme),
                child: Center(
                  child: Text('Add image',
                      style: textColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
