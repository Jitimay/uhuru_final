import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class UtilsFx {
  String getOnlyNumbers(String input) {
    return input.replaceAll(RegExp(r'[^0-9]'), '');
  }

  String extractPhoneNumber(String input) {
    /// Regular expression to match the country phone code
    RegExp countryPhoneCodeRegExp = RegExp(r'^\+(\d+)\s');

    // Check if the input contains the country phone code
    if (countryPhoneCodeRegExp.hasMatch(input)) {
      // Extract and remove the country phone code
      final match = countryPhoneCodeRegExp.firstMatch(input);
      String countryPhoneCode = match!.group(1)!;
      return input.replaceAll("+$countryPhoneCode ", "");
    } else {
      // If no country phone code is present, return the input as it is
      return input;
    }
  }

  Future<Map<String, dynamic>> contacts() async {
    List<Contact> _contacts = [];
    List<String> contacts = [];
    List<Map<String, dynamic>> formattedContacts = [];

    if (await Permission.contacts.request().isGranted) {
      Iterable<Contact> contactsIterable = (await FlutterContacts.getContacts(sorted: false, withProperties: true)).toList();
      _contacts = contactsIterable.toList();
      for (var item in _contacts) {
        if (item.phones.isNotEmpty) {
          final contact = item.phones.first.toString();
          final contactName = item.displayName;
          debugPrint('Contact name: $contactName');
          final phoneNumber = extractPhoneNumber(contact);
          final formattedNumber = getOnlyNumbers(phoneNumber);
          contacts.add(formattedNumber);

          Map<String, dynamic> contact2 = {
            'name': contactName,
            'phone': formattedNumber,
          };
          formattedContacts.add(contact2);
        }
      }
      return {
        'string-contacts': contacts,
        'formatted-contacts': formattedContacts,
      };
    }
    return {
      'string-contacts': [],
      'formatted-contacts': [],
    };
  }

  String formatDate({DateTime? date, isChat = false}) {
    if (date != null) {
      DateTime now = DateTime.now();
      DateTime messageDate = DateTime(date.year, date.month, date.day);

      if (getDateWithoutTime(now) == messageDate) {
        if (isChat) {
          return '${date.hour}:${date.minute}';
        } else {
          return 'Today';
        }
      } else if (getDateWithoutTime(now.subtract(Duration(days: 1))) == getDateWithoutTime(messageDate)) {
        return 'Yesterday';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    }
    return 'No date';
  }

  DateTime getDateWithoutTime(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  String formatBytes(int bytes) {
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    int i = 0;
    double size = bytes.toDouble();
    while (size > 1024) {
      size /= 1024;
      i++;
    }
    return "${size.toStringAsFixed(2)} ${suffixes[i]}";
  }

  Color generateColor(String name) {
    final int hashCode = name.hashCode & 0xFFFFFF;
    final int r = (hashCode & 0xFF0000) >> 16;
    final int g = (hashCode & 0x00FF00) >> 8;
    final int b = hashCode & 0x0000FF;
    return Color.fromRGBO(r, g, b, 1);
  }

  String convertToUnicode(String emoji) {
    final unicodeEmoji = emoji.runes.map((rune) => '\\u{${rune.toRadixString(16)}}').join('');
    return unicodeEmoji;
  }

  String convertToEmoji(String message) {
    final regex = RegExp(r'\\u\{([0-9a-fA-F]+)\}');
    final convertedMessage = message.replaceAllMapped(regex, (match) {
      final codePoint = int.parse(match.group(1)!, radix: 16);
      return String.fromCharCode(codePoint);
    });

    return convertedMessage;
  }

  bool containsEmoji(String message) {
    final regex = RegExp(
      r'[\u{1F600}-\u{1F64F}\u{1F300}-\u{1F5FF}\u{1F680}-\u{1F6FF}\u{1F700}-\u{1F77F}\u{1F780}-\u{1F7FF}\u{1F800}-\u{1F8FF}\u{1F900}-\u{1F9FF}\u{1FA00}-\u{1FA6F}\u{1FA70}-\u{1FAFF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}\u{1F900}-\u{1F9FF}\u{1F018}-\u{1F270}\u{1F97C}-\u{1F9FF}\u{2B50}\u{1F31F}\u{1F4AB}\u{1F525}\u{1F92E}\u{1F92F}\u{1F9B5}\u{1F9B6}\u{1F9B8}\u{1F9B9}\u{1F9BA}\u{1F9BB}\u{1F9BC}\u{1F9BD}\u{1F9BE}\u{1F9BF}\u{1F9C0}\u{1F9C1}\u{1F9C2}\u{1F9D0}-\u{1F9DF}\u{1F64D}-\u{1F64F}]',
      unicode: true,
    );
    return regex.hasMatch(message);
  }

  bool containsEmojiCode(String message) {
    final regex = RegExp(r'\\u\{([0-9a-fA-F]+)\}');
    return regex.hasMatch(message);
  }
}
