import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:uhuru/screens/story/screens/story_display.dart';
import 'package:video_editor/video_editor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';

import '../../../common/colors.dart';
import '../../../common/utils/loader_dialog.dart';
import '../../../common/utils/utils.dart';
import '../../../common/utils/variables.dart';
import '../api/add_story.dart';
import '../api/get_story.dart';
import '../model/group_status_by_phone_number.dart';

class ConfirmStatusScreen extends ConsumerStatefulWidget {
  static const String routeName = "/confirm-status-screen";
  final FilePickerResult? file;

  ConfirmStatusScreen({super.key, this.file});

  @override
  _ConfirmStatusScreenState createState() => _ConfirmStatusScreenState();
}

class _ConfirmStatusScreenState extends ConsumerState<ConfirmStatusScreen> {
  late VideoEditorController? _controller;
  final _addStoryApi = Get.put(AddStory());
  final _getStoryApi = Get.put(GetStory());
  final TextEditingController _captionController = TextEditingController();

  bool isProcessing = false;
  bool isUploading = false;
  bool isPlaying = false;
  String? processingStatus;
  String text = "";

  @override
  void initState() {
    super.initState();
    if (Variables.isVideo && widget.file != null) {
      _initializeVideoEditor();
    }
  }

  Future<void> _initializeVideoEditor() async {
    if (widget.file?.files.single.path == null) return;

    setState(() {
      isProcessing = true;
      processingStatus = "Preparing video...";
    });

    try {
      final videoFile = File(widget.file!.files.single.path!);
      _controller = VideoEditorController.file(
        videoFile,
        maxDuration: const Duration(seconds: 30),
      );

      await _controller?.initialize();

      final duration = _controller?.videoDuration ?? Duration.zero;
      if (duration > const Duration(seconds: 30)) {
        _controller?.updateTrim(0, 30 / duration.inSeconds);
      }
    } catch (e) {
      showSnackBar(
        content: "Error initializing video editor: ${e.toString()}",
        context: context,
      );
    } finally {
      setState(() {
        isProcessing = false;
        processingStatus = null;
      });
    }
  }

  Future<String?> exportTrimmedVideo() async {
    if (_controller == null || !_controller!.initialized) {
      debugPrint("Controller is not initialized");
      return null;
    }

    setState(() {
      isProcessing = true;
      processingStatus = "Processing video...";
    });

    try {
      final directory = await getExternalStorageDirectory();
      if (directory == null) throw Exception("Cannot access storage directory");

      final trimmedPath = '${directory.path}/TrimmedVideo_${DateTime.now().millisecondsSinceEpoch}.mp4';

      final videoDuration = _controller!.videoDuration;
      final startTime = _controller!.minTrim * videoDuration.inSeconds;
      final endTime = _controller!.maxTrim * videoDuration.inSeconds;
      final duration = endTime - startTime;

      final trimCommand = '-i ${widget.file!.files.single.path} -ss $startTime -t $duration -c copy $trimmedPath';

      final result = await FFmpegKit.execute(trimCommand);
      final returnCode = await result.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        return trimmedPath;
      } else {
        throw Exception("Failed to export video with FFmpeg");
      }
    } catch (e) {
      debugPrint('Error during video export: $e');
      showSnackBar(content: "Error exporting video: ${e.toString()}", context: context);
      return null;
    } finally {
      setState(() {
        isProcessing = false;
        processingStatus = null;
      });
    }
  }

  Future<void> addStory(String mediaPath, String caption, String visibility, BuildContext context) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Uploading your story..."),
          duration: const Duration(seconds:2),
        ),
      );
      var response;

      if (mediaPath == 'null' && caption.isNotEmpty) {
        response = await _addStoryApi.addStoryTextApi('null', caption, visibility);
      } else {
        if (Variables.isVideo) {
          final trimmedVideo = await exportTrimmedVideo();
          if (trimmedVideo != null && await File(trimmedVideo).exists()) {
            mediaPath = trimmedVideo;
          } else {
            throw Exception("Failed to trim video");
          }
        }
        response = await _addStoryApi.addStoryApi(mediaPath, caption, visibility);
      }

      if (response != null) {
        await getStory();
        Navigator.pop(context); // Close loader
        showSnackBar(content: "Story uploaded successfully", context: context);

        Navigator.pushReplacement(context,
          MaterialPageRoute(
            builder: (context)=> StoryDisplay(
              buildStoryItems: [], views: 0,
              statusId: response['statusID'],
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to Upload story: ${e.toString()}"),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> getStory() async {
    try {
      final response = await _getStoryApi.getStoryApi();
      if (response != null) {
        Variables.storyList = response;
        Variables.ownStoryList = response['owner_status'];
        Variables.friendsStoryList = response['friends_status'];
        Variables.storyGroupedByPhone = groupStatusesByPhoneNumbers(Variables.friendsStoryList);
      }
    } catch (e) {
      debugPrint('Error fetching stories: $e');
    }
  }

  Widget _buildVideoPreview() {
    if (_controller == null || !_controller!.initialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        CropGridViewer.preview(controller: _controller!),
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isPlaying = !isPlaying;
                isPlaying ? _controller?.video.play() : _controller?.video.pause();
              });
            },
            child: AnimatedOpacity(
              opacity: isPlaying ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrimSlider() {
    if (_controller == null || !_controller!.initialized) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TrimSlider(
        controller: _controller!,
        height: 60,
        horizontalMargin: 16,
        child: TrimTimeline(
          controller: _controller!,
          padding: const EdgeInsets.only(top: 8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Variables.isVideo
            ? Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _buildVideoPreview(),
                  if (isProcessing)
                    Container(
                      color: Colors.black54,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(color: Colors.white),
                            const SizedBox(height: 16),
                            Text(
                              processingStatus ?? "Processing...",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            _buildTrimSlider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _captionController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Add a caption...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        )
            : Column(
          children: [
            Expanded(
              child: Variables.isImage
                  ? Image.file(File(widget.file!.files.single.path!))
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Type your story...",
                    hintStyle: TextStyle(fontSize: 20, color: Colors.white),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) => text = value, // Update the text variable
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            // Add a new TextField for image caption
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _captionController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Add a caption...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: floatingBtnColor,
        onPressed: () async {
          final mediaPath = widget.file != null ? widget.file!.files.single.path! : 'null';
          final caption = _captionController.text.isNotEmpty ? _captionController.text : text;
          await addStory(mediaPath, caption, 'friends', context);
        },
        child: Icon(Icons.done, color: primaryColor),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _captionController.dispose();
    super.dispose();
  }
}