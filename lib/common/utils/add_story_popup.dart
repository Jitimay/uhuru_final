import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uhuru/common/utils/variables.dart';

import '../../screens/story/screens/confirm_status_screen.dart';

void addStoryDialog(BuildContext context) {
  final iconColor = Theme.of(context).colorScheme.onBackground;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Add Story', style: TextStyle(color: Colors.white)),
        content: SizedBox(
          height: 150.0,
          child: Column(
            children: [
              TextButton(
                  onPressed: () {
                    if (Variables.isImage == true || Variables.isVideo == true) {
                      Variables.isVideo = false;
                      Variables.isImage = false;
                    }
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmStatusScreen()));
                  },
                  child: ListTile(
                    leading: Icon(Icons.draw_outlined, color: iconColor,),
                    title: Text('Text', style: TextStyle(color: Colors.white)),
                  )
              ),
              TextButton(
                  onPressed: () async {
                    // File? pickedImage = await pickImageFromGallery(context);
                    // debugPrint('------------${pickedImage?.path}-----------');
                    // if (pickedImage != null) {
                    //   // ignore: use_build_context_synchronously
                    //   Navigator.pop(context);
                    //   Navigator.pushNamed(context, ConfirmStatusScreen.routeName, arguments: pickedImage);
                    // }
                    final pickedFile = await FilePicker.platform.pickFiles(type: FileType.any);
                    // final pickedFile = await pickFile();
                    if (pickedFile != null) {
                      // Check if it's an image or video
                      if (Variables.isImage == false || Variables.isVideo == false) {
                        Variables.isImage =
                            pickedFile.files.single.path!.endsWith('.jpg') ||
                                pickedFile.files.single.path!.endsWith('.png');
                        Variables.isVideo =
                            pickedFile.files.single.path!.endsWith('.mp4');
                      }

                      if (Variables.isImage) {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, ConfirmStatusScreen.routeName, arguments: pickedFile);
                      } else if (Variables.isVideo) {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, ConfirmStatusScreen.routeName, arguments: pickedFile);
                      } else {
                        // Show an error message if the selected file is not an image or video
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please select an image or video', style: TextStyle(color: Colors.white)),
                            backgroundColor: Colors.black,
                          ),
                        );
                      }
                    }
                  },
                  child: ListTile(
                    leading: Icon(Icons.perm_media_outlined, color: iconColor,),
                    title: Text('Media', style: TextStyle(color: Colors.white)),
                  )
              ),
            ],
          ),
        ),
        // actions: [
        //   TextButton(
        //     onPressed: () {
        //       Navigator.pop(context); // Close the dialog
        //     },
        //     child: const Text('OK'),
        //   ),
        // ],
      );
    },
  );
}