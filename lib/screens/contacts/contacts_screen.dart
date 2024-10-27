import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uhuru/common/utils/variables.dart';
import 'package:uhuru/common/colors.dart';
import 'package:uhuru/common/utils/environment.dart';
import 'package:uhuru/screens/chats/model/chat_model.dart';
import 'package:uhuru/services/contacts.dart';
import '../messages/messages_screen.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  bool isLoading = false;
  int? contactsCount;
  List<ChatModel> chats = [];

  Future<void> _loadContacts() async {
    setState(() => isLoading = true); // Show loading indicator
    try {
      // Ensure permission is granted before trying to access contacts
      if (await Permission.contacts.isGranted) {
        if (Variables.remoteContacts.isEmpty) {
          await phoneNumbersFilter(); // Fetch contacts
          chats = Variables.remoteContacts;
          contactsCount = Variables.remoteContacts.length;
        } else {
          chats = Variables.remoteContacts;
          contactsCount = Variables.remoteContacts.length;
        }
      }
    } catch (e) {
      print("Error fetching contacts: $e");
    } finally {
      setState(() => isLoading = false); // Hide loading indicator
    }
  }

  void addContact() async => await FlutterContacts.openExternalInsert();

  void _onRefresh() async {
    try {
      await phoneNumbersFilter();
      chats = Variables.remoteContacts;
      contactsCount = Variables.remoteContacts.length;
    } catch (e) {
      print("Error fetching contacts: $e");
    } finally {
      setState(() {});
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadContacts();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(Icons.arrow_back),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select contact', style: TextStyle(color: Colors.white, fontSize: 15)),
                if (contactsCount != null) Text('${contactsCount! > 0 ? "${contactsCount} contacts" : "No contact available"} ', style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            )
          ],
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            onPressed: addContact,
            icon: GestureDetector(onTap: addContact, child: Icon(Icons.add)),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : RefreshIndicator(
              backgroundColor: primaryColor,
              color: Colors.white,
              onRefresh: () async => _onRefresh(),
              child: ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  final imageUrl = Uri.parse(Environment.urlHost).resolve(chat.picture ?? 'null').toString();
                  if (chats.isEmpty) {
                    return Center(child: Text('None of your contacts is registered to uhuru'));
                  }
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (ctx) => MessagesScreen(
                            chatId: chat.id.toString(),
                            chatName: chat.chatId ?? '',
                            receivername: chat.receiverName ?? chat.reciever ?? '',
                            sender: chat.sender ?? '',
                            receiver: chat.reciever ?? '',
                            receiverPicture: imageUrl,
                            notif_key: chat.notifKey ?? "",
                            sender_notif_name: Variables.fullNameString,
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: imageUrl.contains('null')
                          ? Icon(
                              Icons.account_circle,
                              size: 50,
                            )
                          : CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(imageUrl),
                              radius: 20,
                              backgroundColor: Colors.grey,
                            ),
                      title: Text(chat.receiverName ?? chat.reciever ?? ''),
                      subtitle: Text(
                        chat.reciever ?? '',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
