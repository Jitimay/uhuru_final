import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:uhuru/common/widget/error.dart';
import 'package:uhuru/screens/auth/view/number_input_screen.dart';
import 'package:uhuru/screens/group/create_group_screen.dart';
import 'package:uhuru/models/status_model.dart';
import 'package:uhuru/screens/auth/view/otp_screen.dart';
import 'package:uhuru/screens/auth/view/auth_screen.dart';
import 'package:uhuru/screens/story/screens/confirm_status_screen.dart';
import 'package:uhuru/screens/story/screens/status_screen.dart';

Route<dynamic> generateroute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: ((context) => const LoginScreen()));
    case OTPScreen.routeName:
      final String verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: ((context) => OTPScreen(
              verificationId: verificationId,
            )),
      );
    case UserInformation.routeName:
      return MaterialPageRoute(builder: ((context) => const UserInformation()));

    // case SelectContactScreen.routeName:
    //   return MaterialPageRoute(
    //       builder: ((context) => const SelectContactScreen()));
    // case MobileChatScreen.routeName:
    //   final arguments = settings.arguments as Map<String, dynamic>;
    //   final name = arguments['name'];
    //   final uid = arguments['uid'];
    //   final isGroupChat = arguments['isGroupChat'];
    //   final profilePic = arguments['profilePic'];
    //   return MaterialPageRoute(
    //       builder: ((context) => MobileChatScreen(
    //             isGroupChat: isGroupChat,
    //             name: name,
    //             uid: uid,
    //             profilePic: profilePic,
    //           )));

    case ConfirmStatusScreen.routeName:
      final file = settings.arguments as FilePickerResult;
      return MaterialPageRoute(builder: ((context) => file.files.single.path != null ? ConfirmStatusScreen(file: file) : ConfirmStatusScreen()));

    case StatusScreen.routeName:
      final status = settings.arguments as Status;
      return MaterialPageRoute(builder: ((context) => StatusScreen(status: status)));

    case CreateGroupScreen.routeName:
      return MaterialPageRoute(builder: ((context) => const CreateGroupScreen()));
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: "this page does not exist"),
        ),
      );
  }
}
