import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:uhuru/common/colors.dart';
import 'package:uhuru/common/utils/Fx.dart';
import 'package:uhuru/common/utils/variables.dart';
import 'package:uhuru/screens/chats/bloc/chat_bloc.dart';

class ChatDetailsScreen extends StatefulWidget {
  final String? receiverPicture;
  final String? phoneNumber;
  final String onlineStatus;
  final String? contactId;
  final String id;
  const ChatDetailsScreen({
    super.key,
    this.receiverPicture,
    required this.phoneNumber,
    required this.onlineStatus,
    required this.contactId,
    required this.id,
  });

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

Future<void> updateContact(String number) async {}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  bool isEditing = false;

  @override
  void initState() {
    isEditing = widget.contactId != null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Is editing:$isEditing');
    const divider = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Divider(color: Colors.grey),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      color: primaryColor,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * .28,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 80,
                      left: 0,
                      right: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: (widget.receiverPicture.toString().contains('null'))
                                ? Icon(Icons.account_circle, size: 130)
                                : CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(widget.receiverPicture!),
                                    radius: 60,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  Variables.recieverName,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
                ),
                Text(
                  widget.onlineStatus,
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                SizedBox(height: 30),
                divider,
                CustomRow(
                  onPressed: () => Navigator.of(context).pop(),
                  color: Colors.black,
                  iconData: Icons.message_outlined,
                  label: 'Send a message',
                ),
                // divider,
                // CustomRow(onPressed: () {}, color: Colors.black, iconData: Icons.call, label: 'Call'),
                // divider,
                // CustomRow(onPressed: () {}, color: Colors.black, iconData: Icons.video_call_outlined, label: 'Video call'),
                divider,
                CustomRow(
                  onPressed: () async {
                    if (isEditing) {
                      final contact = await FlutterContacts.openExternalEdit(widget.contactId!);
                      String newName = contact?.displayName ?? '${Variables.recieverName}';
                      Variables.recieverName = newName;
                      String chatId = widget.id;
                      context.read<ChatBloc>().add(EditChatEvent(newName: newName, id: chatId));
                      setState(() {});
                    } else {
                      final contact = Contact(phones: [Phone(widget.phoneNumber!)]);
                      final newContact = await FlutterContacts.openExternalInsert(contact);
                      String newName = newContact?.displayName ?? '${Variables.recieverName}';
                      Variables.recieverName = newName;
                      String chatId = widget.id;
                      context.read<ChatBloc>().add(
                            EditChatEvent(
                              newName: newName,
                              id: chatId,
                              contactId: newContact!.id,
                            ),
                          );
                      setState(() => isEditing = false);
                    }
                    debugPrint('Contact updated');
                  },
                  color: Colors.black,
                  iconData: Icons.account_circle,
                  label: isEditing ? 'Edit contact' : 'Add contact',
                ),
                divider,
                CustomRow(
                  onPressed: () {},
                  color: Colors.black,
                  iconData: Icons.account_circle,
                  label: 'Block contact',
                ),
                SizedBox(height: 5),
                InkWell(
                  onTap: () {},
                  child: Card(
                    child: Container(
                      color: Colors.white,
                      height: 60,
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        children: [
                          Text(
                            'Media, links, and docs',
                            style: TextStyle(color: Colors.black),
                          ),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios, color: Colors.black, size: 15)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomRow extends StatelessWidget {
  final IconData iconData;
  final String label;
  final Color color;
  final VoidCallback onPressed;
  const CustomRow({
    super.key,
    required this.color,
    required this.iconData,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Row(
          children: [
            Icon(iconData, color: color),
            SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

Future<Contact?> getContactByPhoneNumber(String phoneNumber) async {
  debugPrint('THE PHONE NUMBER IS: $phoneNumber');
  // Ensure contacts permission is granted
  if (await FlutterContacts.requestPermission()) {
    // Fetch all contacts that have at least one phone number
    List<Contact> contacts = (await FlutterContacts.getContacts(sorted: false, withProperties: true)).toList();

    // Iterate through the contacts to find the one with the matching phone number
    for (Contact contact in contacts) {
      // Normalize the phone number format (remove spaces, dashes, etc.) if necessary
      String normalizedPhone = contact.phones.first.number;
      final phoneNumber = UtilsFx().extractPhoneNumber(normalizedPhone);
      final numbersToString = UtilsFx().getOnlyNumbers(phoneNumber);
      debugPrint('THE PHONE NUMBER EXTRACTED: $numbersToString');
      if (numbersToString == phoneNumber) {
        // Return the contact if the phone number matches
        return contact;
      }
    }
  }
  // Return null if no matching contact is found
  return null;
}
