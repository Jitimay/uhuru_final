import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ChannelTextItem extends StatelessWidget {
  final String content;
  final String date;
  const ChannelTextItem({
    super.key,
    required this.content,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('hh:mm a').format(DateTime.parse(date));
    return IntrinsicHeight(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .9),
        child: GestureDetector(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 52, 52, 52),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildCaptionWithLinks(content, context),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '${formattedDate}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildCaption(caption) {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: caption.substring(0, caption.indexOf('https')), // Text before the URL
          style: TextStyle(color: Colors.white),
        ),
        if (caption.indexOf('https') != -1) // Check if URL exists
          TextSpan(
            text: caption.substring(caption.indexOf('https'), caption.indexOf(' ', caption.indexOf('https') + 1) != -1 ? caption.indexOf(' ', caption.indexOf('https') + 1) : caption.length), // Extract and highlight URL (consider no space after link)
            style: TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()..onTap = () => launchUrl(caption.substring(caption.indexOf('https'), caption.indexOf(' ', caption.indexOf('https') + 1) != -1 ? caption.indexOf(' ', caption.indexOf('https') + 1) : caption.length)), // Launch URL on tap
          ),
        TextSpan(
          text: caption.substring(caption.indexOf(' ', caption.indexOf('https') + 1)), // Text after the URL (excluding space)
          style: TextStyle(color: Colors.white), // Set back to black color
        ),
      ],
    ),
  );
}

Widget buildCaptionWithLinks(String caption, context) {
  final List<String> words = caption.split(' ');
  List<TextSpan> textSpans = [];

  for (String word in words) {
    if (word.startsWith('http')) {
      textSpans.add(
        TextSpan(
          text: '$word ',
          style: TextStyle(color: Colors.blue),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launchURL(word, context);
            },
        ),
      );
    } else {
      textSpans.add(
        TextSpan(
          text: '$word ',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }

  return RichText(text: TextSpan(children: textSpans));
}

void launchURL(String url, context) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not open $url')));
  }
}
