import 'package:flutter/material.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;

class LinkPreviewWidget extends StatefulWidget {
  final String linkUrl;
  const LinkPreviewWidget({super.key, required this.linkUrl});

  @override
  State<LinkPreviewWidget> createState() => _LinkPreviewWidgetState();
}

class _LinkPreviewWidgetState extends State<LinkPreviewWidget> {
  String _linkUrl = '';
  Map<String, PreviewData> datas = {};

  @override
  void initState() {
    _linkUrl = widget.linkUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: Theme.of(context).colorScheme.onBackground,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.375,
    );

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: Color(0xfff7f7f8),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          child: LinkPreview(
            enableAnimation: true,
            onPreviewDataFetched: (data) {
              setState(() {
                datas = {
                  ...datas,
                  _linkUrl: data,
                };
              });
            },
            previewData: datas[_linkUrl],
            text: _linkUrl,
            textStyle: style,
            metadataTitleStyle: style.copyWith(color: Colors.black),
            metadataTextStyle: style.copyWith(color: Colors.black),
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ),
    );
  }
}
