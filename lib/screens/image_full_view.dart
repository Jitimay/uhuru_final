import 'package:flutter/material.dart';

class ImageFullView extends StatefulWidget {
  final String tag;
  final Widget image;

  const ImageFullView({Key? key, required this.tag, required this.image}) : super(key: key);

  @override
  _ImageFullViewState createState() => _ImageFullViewState();
}

class _ImageFullViewState extends State<ImageFullView> {
  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        body: Center(
          child: Hero(
            tag: widget.tag,
            child: widget.image,
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
