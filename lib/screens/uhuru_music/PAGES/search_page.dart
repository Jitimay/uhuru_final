import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../PAGES/music_list.dart';
import '../utilities/app_theme.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.query});
  final String query;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF303151),
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
      ),
      body: SearchScreen(
        query: widget.query,
        showSearch: false,
        showCategory: false,
      ),
    );
  }
}
