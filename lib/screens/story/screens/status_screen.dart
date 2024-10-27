import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:uhuru/common/widget/loader.dart';


import '../../../models/status_model.dart';
import '../api/delete_post.dart';

class StatusScreen extends StatefulWidget {
  static const String routeName = "/status-screen";
  final Status status;

  const StatusScreen({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  List<StoryItem> storyItem = [];
  StoryController storyController = StoryController();

  @override
  void initState() {
    super.initState();
    initStoryPageItems();
  }

  void initStoryPageItems() {
    storyItem.add(
      StoryItem.pageImage(
        url: "assets/U1.png",
        controller: storyController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit Video', style: TextStyle(color: Colors.white)),
      ),
      body: storyItem.isEmpty
          ? const Loader()
          : StoryView(
        storyItems: storyItem,
        controller: storyController,
        onVerticalSwipeComplete: (direction) {
          if (direction == Direction.down) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
