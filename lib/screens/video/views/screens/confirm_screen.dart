import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uhuru/common/constant.dart';
import 'package:uhuru/common/utils/utils.dart';
import 'package:uhuru/common/widget/upload_status.dart';
import 'package:uhuru/screens/video/api/add_video.dart';
import 'package:uhuru/screens/video/views/screens/video_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:video_player/video_player.dart';
import 'package:video_editor/video_editor.dart';

import '../../../../common/utils/loader_dialog.dart';
import '../../../../common/utils/variables.dart';
import '../../../home_screen/mobile_layout_screen.dart';
import '../../../user_profile/api/update_profile_api.dart';
import '../../api/get_video.dart';
import '../widget/portrait_file_player.dart';
import '../widget/text_input.dart';

class ConfirmScreen extends ConsumerStatefulWidget {
  final File videoFile;
  final String videoPath;
  const ConfirmScreen({
    Key? key,
    required this.videoFile,
    required this.videoPath,
  }) : super(key: key);

  @override
  ConsumerState<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends ConsumerState<ConfirmScreen> {
  bool loading = false;
  double? parcent = 0;
  late final VideoPlayerController controller;
  final TextEditingController _songController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();
  final _addVideoApi = Get.put(AddVideo());
  final _getVideoApi = Get.put(GetVideo());
  String downloadUrl = "";
  late VideoEditorController _controller;
  var videoFileTrimmed;
  Future<String> uploadFile() async {
    setState(() {
      loading = true;
    });
    var allDocs = await firestoreV.collection('videos').get();
    int len = allDocs.docs.length;

    final storageRef =
        firebasesStorageV.ref().child("videos").child("Video $len");

    final uploadTask = storageRef.putFile(widget.videoFile);

    uploadTask.snapshotEvents.listen((TaskSnapshot snap) async {
      switch (snap.state) {
        case TaskState.running:
          final progress = 100 * (snap.bytesTransferred / snap.totalBytes);
          setState(() {
            parcent = progress.toDouble();
          });

          break;

        case TaskState.paused:
          showSnackBar(context: context, content: "upload is paused");
          break;
        case TaskState.canceled:
          showSnackBar(context: context, content: "upload was canceled");
          break;

        case TaskState.error:
          showSnackBar(context: context, content: "Error while uploading");
          break;

        case TaskState.success:
          await storageRef.getDownloadURL().then(
            (value) {
              setState(() {
                downloadUrl = value;
              });
            },
          );
          setState(() {
            loading = false;
          });
          // ignore: use_build_context_synchronously
          showSnackBar(context: context, content: "upload success");

          break;
      }
    });

    return downloadUrl;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      // controller = VideoPlayerController.file(widget.videoFile);
      _controller = VideoEditorController.file(
        widget.videoFile,
        maxDuration: const Duration(seconds: 60), // Maximum trim duration of 60 seconds
      )..addListener(() => setState(() {}))
        ..video.setLooping(false)
        ..initialize().then((_)  => controller.pause());
    });
  }

  @override
  void dispose() {
    // controller.dispose();
    _controller.dispose();
    super.dispose();
  }

  addVideo(String caption, String songName, media, String media_type) async {
    // LoaderDialog.showLoader(context!, Variables.keyLoader);
    debugPrint('>>>>>>>>>>UPDATE FUNCTION<<<<<<<<<<<<');
    try{
      final response = await _addVideoApi.newVideoApi(
           caption, songName, media, media_type, context);
      debugPrint('>>>>>>>>>>CACIYEMWO<<<<<<<<<<<<');
      if(response != null){
        debugPrint('>>>>>>>>>>$response<<<<<<<<<<<<');
        setState(() {
          Variables.isUploading = false;
          Variables.isSuccess = true;
          _captionController.clear();
          _songController.clear();
        });
        getVideo();
        // Navigator.of(context, rootNavigator: true).pop();
      } else {
        debugPrint('>>>>>>>>>>$response<<<<<<<<<<<<');
      }
    } catch(e){
      setState(() {
        Variables.isUploading = true;
        Variables.isSuccess = false;
      });
      debugPrint('**********This is the exception!!!!$e!!!!!!');
      showSnackBar(content: "$e", context: context);
    }
  }

  getVideo() async {
    try {
      final response = await _getVideoApi.getVideoApi(Variables.videoPageNumber);
      debugPrint('++++FLYING>>>>>>>>>>$response<<<<<<<<<<<<');
      if (response != null) {
        setState(() {
          // Add new videos ensuring no duplicates
          for (var video in response['results']) {
            if (!Variables.videoList.any((element) => element['id'] == video['id'])) {
              Variables.videoList.add(video);
              Variables.filteredVideos.add(video);
            }
          }
          Variables.itemLoadingStates = List.generate(
            Variables.filteredVideos.length,
                (index) => false,
          );
          Variables.videoPages = response['count'];
        });

        // Navigator.of(context, rootNavigator: true).pop();
        // Navigator.of(context, rootNavigator: true).pop();
      }
    } catch (e) {
      debugPrint('**********This is the exception!!!!$e!!!!!!');
    }
  }

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

  Future<String?> moveFileToPermanentLocation(String trimmedPath) async {
    final file = File(trimmedPath);

    // Check if the file exists before trying to move it
    if (!await file.exists()) {
      debugPrint('File does not exist at path: $trimmedPath');
      return null;
    }

    final directory = await getExternalStorageDirectory(); // Get the external storage directory (optional, consider user permission)
    // OR
    // final directory = await getApplicationDocumentsDirectory(); // Get the app's document directory

    final newPath = '${directory?.path}/trimmed_video.mp4'; // Set the new path in the permanent directory

    try {
      // Ensure the directory exists
      if (directory != null && !(await directory.exists())) {
        await directory.create(recursive: true);
      }

      final newFile = await file.copy(newPath); // Copy the file to the new path
      debugPrint('File moved to $newPath');
      return newFile.path;
    } catch (e) {
      debugPrint('Error moving file: $e');
      return null;
    }
  }



  exportTrimmedVideo() async {
    if (!_controller.initialized) {
      debugPrint("Controller is not initialized");
      return;
    }
    await requestStoragePermission(context);
    final directory = await getExternalStorageDirectory();
    final String outputPath = '${directory?.path}';
    final Duration start = _controller.startTrim;
    final Duration end = _controller.endTrim;
    var executed;

    final config = VideoFFmpegVideoEditorConfig(
        _controller,
      name: 'UhuruTrimmedVideo',
      outputDirectory: outputPath,
      format: VideoExportFormat.mp4
    );
    try {
      final executeConfig = await config.getExecuteConfig();
      await FFmpegVideoEditorExecute(command: executeConfig.command, outputPath: executeConfig.outputPath);
      await config.getOutputPath(filePath: '${directory?.path}/UhuruTrimmedVideo.mp4', format: VideoExportFormat.mp4).then((outputPath) {
        // Success block - outputPath contains the generated path
        setState(() {
          executed = outputPath;
        });
        debugPrint('Output path: $outputPath');
      }).catchError((error) {
        // Handle any error that occurred
        debugPrint('Error generating output path: $error');
      }).whenComplete(() {
        // This block will run after everything completes (success or failure)
        debugPrint('Completed output path generation');
      });;

       debugPrint('EXECUTED PATH == ${executed}');
      videoFileTrimmed = executed;

      // Ensure the trimming was successful
      if (videoFileTrimmed != null && videoFileTrimmed.isNotEmpty) {
        debugPrint('Trimming successful: $videoFileTrimmed');
        final permanentPath = await moveFileToPermanentLocation(videoFileTrimmed);
        if (permanentPath != null) {
          setState(() {
            Variables.base64Video = permanentPath;
          });
          debugPrint('Video trimmed and moved successfully! ==== $permanentPath');
        } else {
          debugPrint('Failed to move trimmed video.');
        }
      } else {
        debugPrint('Failed to export the video.');
      }
    } catch (e) {
      debugPrint('Error during video export: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.5,
              child: Variables.isPickingImage?
              Image.file(widget.videoFile):
              Column(
                children: [
                  SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.0,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CropGridViewer.preview(
                          controller: _controller,
                        ),
                        AnimatedBuilder(
                          animation: _controller.video,
                          builder: (_, __) => AnimatedOpacity(
                            opacity:
                            _controller.video.value.isPlaying ? 0 : 1,
                            duration: kThemeAnimationDuration,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_controller.video.value.isPlaying) {
                                    _controller.video.pause();
                                    // controller.pause();
                                  } else {
                                    _controller.video.play();
                                    // controller.play();
                                  }
                                });
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration:
                                const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TrimSlider(
                    controller: _controller,
                    height: 60,
                    horizontalMargin: 10, // Limit the slider to 60 seconds
                  ),
                ],
              ),
              // PortraitFileWidget(file: widget.videoFile),
            ),
            const SizedBox(
              height: 30,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Visibility(
                    visible: Variables.isPickingVideo,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: MediaQuery.of(context).size.width - 20,
                      child: TextFieldInput(
                        controller: _songController,
                        labelText: 'Song Name',
                        icon: Icons.music_note,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextFieldInput(
                      controller: _captionController,
                      labelText: 'Caption',
                      icon: Icons.closed_caption,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Variables.isUploading
                      ? UploadStatus(isUploading: Variables.isUploading, isSuccess: Variables.isSuccess, progressionValue: Variables.uploadProgress)
                      : ElevatedButton(
                    onPressed: () async {
                      if(!Variables.isUploading){
                        setState(() {
                          Variables.isUploading = true;
                          Variables.isSuccess = false;
                        });
                        if(!Variables.isPickingImage){
                          debugPrint('THIS A VIDEO CAUSE ISPICKINGIMAGE IS ${!Variables.isPickingImage}');
                          // Export the trimmed video
                          ///extract has an issue cause the current video_editor package
                          ///doesn't support it the older versions will require
                          /// a downgrade of the whole project
                          await exportTrimmedVideo();
                        }
                        debugPrint('${Variables.base64Video}');
                        addVideo(_captionController.text, Variables.isPickingImage? " ": _songController.text, Variables.base64Video, Variables.isPickingImage? "image": "video");
                      }
                    },
                    child: Text(
                      Variables.isUploading? 'Uploading..': 'Share!',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  !loading
                      ? Container()
                      : LinearPercentIndicator(
                          percent: (parcent! / 100),
                          progressColor: Colors.blue,
                          backgroundColor: Colors.white,
                        )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
