import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MultipleAvatar extends StatelessWidget {
  var list;
  var urlPath;
  MultipleAvatar({Key? key, required this.list, required this.urlPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = RestrictedAmountPositions(
      maxAmountItems: 2,
      maxCoverage: 0.3,
      minCoverage: 0.1,
    );
    return AvatarStack(
      settings: settings,
      height: 50,
      avatars: [for (var n = 0; n < list.length; n++) NetworkImage('${urlPath}')],
    );
  }
}
