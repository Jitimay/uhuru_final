import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uhuru/common/colors.dart';
import 'package:uhuru/common/utils/utils.dart';
import 'package:uhuru/screens/channels/blocs/channel/channel_bloc.dart';

class CreateChannelScreen extends StatefulWidget {
  const CreateChannelScreen({super.key});

  @override
  State<CreateChannelScreen> createState() => _CreateChannelScreenState();
}

class _CreateChannelScreenState extends State<CreateChannelScreen> {
  File? picture;
  final _controller = TextEditingController();

  void selectImage() async {
    picture = await pickImageFromGallery(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: primaryColor,
        title: Text(
          'Create channel',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  picture == null
                      ? CircleAvatar(
                          child: Icon(
                            Icons.group,
                            color: Colors.white,
                            size: 50,
                          ),
                          backgroundColor: Color.fromARGB(255, 90, 93, 98),
                          // backgroundImage:
                          //     AssetImage("assets/backgroundImage.png"),
                          radius: 64,
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: FileImage(picture!),
                          radius: 64,
                        ),
                  Positioned(
                    bottom: 0,
                    left: 90,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: primaryColor,
                      ),
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(
                          Icons.add_a_photo,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(hintText: 'Channel name'),
              ),
            ),
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  onPressed: () {
                    String message = 'Channel name and picture are required';
                    final snackBar = SnackBar(
                      content: Center(
                        child: Text(
                          message,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    );
                    if (picture == null || _controller.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      context.read<ChannelBloc>().add(
                            CreateChannelEvent(
                              picture: picture!.path,
                              channelName: _controller.text.trim(),
                            ),
                          );
                    }
                  },
                  child: BlocConsumer<ChannelBloc, ChannelState>(
                    listener: (context, state) {
                      if (state is ChannelListState) {
                        if (state.failureMessage == 'success') {
                          Navigator.of(context).pop();
                        }
                        ;
                      }
                    },
                    builder: (context, state) {
                      if (state is ChannelLoadingState) {
                        if (state is ChannelListState) {
                          Navigator.of(context).pop();
                        }
                        return Text(
                          'Please wait...',
                          style: TextStyle(color: Colors.white),
                        );
                      }
                      return Text(
                        'Create channel',
                        style: TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
