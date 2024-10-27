import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../PAGES/search_page.dart';
import '../controller/youtube_explode_search.dart';
import '../utilities/app_theme.dart';

class AutocompleteWidget extends StatefulWidget {
  const AutocompleteWidget({super.key});

  @override
  State<AutocompleteWidget> createState() => _AutocompleteWidgetState();
}

class _AutocompleteWidgetState extends State<AutocompleteWidget> {
  final yt = YoutubeExplodeSearch();
  List<String> _suggestions = [];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Autocomplete<String>(
        optionsBuilder: (textEditingValue) async {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<String>.empty();
          }

          _suggestions =
              await yt.searchVideoSuggestion(query: textEditingValue.text);

          return _suggestions;
        },
        onSelected: (String selection) {
          if (kDebugMode) {
            print('You just selected $selection');
          }
        },
        fieldViewBuilder: (BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          return TextField(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
            ),
            controller: textEditingController,
            focusNode: focusNode,
            onSubmitted: (String value) {
              onFieldSubmitted();
              Get.to(SearchPage(query: textEditingController.text));
              textEditingController.text = '';
            },
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                onTap: () {
                  Get.to(SearchPage(query: textEditingController.text));
                  textEditingController.text = '';
                },
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
              focusColor: AppTheme.white,
              fillColor: AppTheme.white,
              hintStyle: TextStyle(
                color: AppTheme.white,
              ),
              hintText: 'Search...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          );
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topCenter,
            child: Material(
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 32,
                child: ListView.builder(
                  itemCount: _suggestions.length,
                  padding: const EdgeInsets.all(8.0),
                  itemBuilder: (context, index) {
                    final String option = options.elementAt(index);
                    return GestureDetector(
                      onTap: () {
                        onSelected(option);
                      },
                      child: ListTile(
                        title: Text(option),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
