import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uhuru/common/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewMessageItem extends StatefulWidget {
  final Function(String message) onSent;
  final Function(String message)? onSendAudio;
  final VoidCallback onAttachFile;
  final bool? isChannel;
  final bool? isFilePreview;
  const NewMessageItem({
    super.key,
    required this.onSent,
    required this.onAttachFile,
    this.onSendAudio,
    this.isChannel = false,
    this.isFilePreview = false,
  });
  const NewMessageItem.filePreview({
    super.key,
    required this.onSent,
    required this.onAttachFile,
    this.onSendAudio,
    this.isChannel = true,
  }) : isFilePreview = true;

  const NewMessageItem.isChannel({
    super.key,
    required this.onSent,
    required this.onAttachFile,
    this.onSendAudio,
    this.isFilePreview = false,
  }) : isChannel = true;

  @override
  State<NewMessageItem> createState() => _NewMessageItemState();
}

class _NewMessageItemState extends State<NewMessageItem> {
  final record = AudioRecorder();
  int recordCounter = 0;
  bool isMicOpen = false;
  final TextEditingController _textEditingController = TextEditingController();
  bool isTyping = false;
  bool showEmoji = false;
  bool isKeyboardOpen = false;
  final FocusNode _focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  Future<String> getSoundsFolderPath() async {
    Directory? downloadsDirectory = await getExternalStorageDirectory();
    String downloadsPath = downloadsDirectory!.path;
    if (!await downloadsDirectory.exists()) {
      await downloadsDirectory.create(recursive: true);
    }
    // final Directory appDocDir = await getApplicationDocumentsDirectory();
    // final Directory soundsDir = Directory('${appDocDir.path}/Sounds');
    // if (!await soundsDir.exists()) {
    //   await soundsDir.create(recursive: true);
    // }
    return downloadsPath;
  }

  Future<String> generateRandomFileName() async {
    final DateTime now = DateTime.now();
    final String formattedDate = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final String fileName = 'UHURU-AUD-$formattedDate-WA${recordCounter}.m4a';
    recordCounter++;
    await _saveCounter();

    return fileName;
  }

  Future<void> _loadCounter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    recordCounter = prefs.getInt('recordCounter') ?? 1;
  }

  Future<void> _saveCounter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('recordCounter', recordCounter);
  }

  Future<void> startRecording() async {
    try {
      if (await record.hasPermission()) {
        setState(() {
          isMicOpen = true;
        });

        final String soundsFolderPath = await getSoundsFolderPath();
        final String randomFileName = await generateRandomFileName();
        await record.start(
          const RecordConfig(),
          path: '$soundsFolderPath/$randomFileName',
        );
      } else {
        debugPrint('Permission not granted for recording.');
      }
    } catch (e) {
      debugPrint('Error starting recording: $e');
    }
  }

  Future<String> sendRecording() async {
    final path = await record.stop();
    return path!;
  }

  Future<void> cancelRecording() async {
    try {
      final audioPath = await record.stop() ?? '';
      if (await File(audioPath).exists()) {
        await File(audioPath).delete();
        debugPrint('Recording canceled and file deleted.');
      }
    } catch (e) {
      debugPrint('Error canceling recording: $e');
    }
  }

  @override
  void initState() {
    _loadCounter();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isMicOpen
        ? SafeArea(
            child: Container(
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () async {
                        await cancelRecording();
                        setState(() {
                          isMicOpen = false;
                        });
                      },
                      icon: Icon(Icons.delete, color: Colors.white)),
                  Spacer(),
                  Container(
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.recording,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(width: 8.0),
                        SpinKitThreeBounce(
                          color: Colors.white,
                          size: 20.0,
                          duration: Duration(milliseconds: 800),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: widget.onSendAudio != null
                          ? () async {
                              final path = await sendRecording();
                              widget.onSendAudio!(path);
                              setState(() {
                                isMicOpen = false;
                              });
                            }
                          : null,
                      icon: Icon(Icons.send, color: Colors.white)),
                ],
              ),
            ),
          )
        : Column(
            children: [
              Row(children: [
                Expanded(
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      onTap: () {
                        setState(() {
                          showEmoji = false;
                          isTyping = false;
                          isKeyboardOpen = true;
                        });
                      },
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return;
                        }
                      },
                      focusNode: _focusNode,
                      controller: _textEditingController,
                      onChanged: (val) {
                        if (!val.isEmpty) {
                          setState(() {
                            isTyping = true;
                          });
                        } else {
                          setState(() {
                            isTyping = false;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        suffixIcon: widget.isFilePreview ?? false
                            ? null
                            : IconButton(
                                icon: Icon(
                                  Icons.attachment,
                                  color: primaryColor,
                                ),
                                onPressed: widget.onAttachFile,
                              ),
                        prefixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(width: 4.0),
                            IconButton(
                              icon: Icon(Icons.emoji_emotions, color: primaryColor.withOpacity(.7)),
                              onPressed: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                setState(() {
                                  showEmoji = true;
                                  isTyping = true;
                                });
                              },
                            ),
                          ],
                        ),
                        hintText: '${AppLocalizations.of(context)!.sendingmessage}...',
                        hintStyle: TextStyle(
                          color: Colors.black54,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                if (_textEditingController.text.trim().isNotEmpty)
                  IconButton(
                    onPressed: () {
                      widget.onSent(_textEditingController.text);
                      _textEditingController.clear();
                      setState(() {
                        isTyping = false;
                        showEmoji = false;
                      });
                    },
                    icon: Icon(
                      Icons.send,
                      color: widget.isFilePreview ?? false ? Colors.white : null,
                    ),
                  )
                else
                  Container(
                    child: widget.isChannel == false
                        ? CircleAvatar(
                            backgroundColor: floatingBtnColor,
                            child: IconButton(
                              icon: Icon(
                                Icons.mic,
                                color: primaryColor,
                              ),
                              onPressed: () async {
                                await startRecording();
                              },
                            ))
                        : SizedBox(),
                  ),
              ]),
              SizedBox(height: 5),
              if (showEmoji)
                SizedBox(
                  height: MediaQuery.of(context).size.height * .35,
                  child: EmojiPicker(
                    textEditingController: _textEditingController,
                    onEmojiSelected: (cat, sth) {
                      setState(() {
                        isTyping = true;
                      });
                    },
                    config: Config(
                        emojiViewConfig: EmojiViewConfig(
                      columns: 7,
                      emojiSizeMax: 22,
                    )),
                  ),
                ),
            ],
          );
  }
}
