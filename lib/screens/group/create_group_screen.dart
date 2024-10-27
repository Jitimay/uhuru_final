import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uhuru/common/colors.dart';
import 'package:uhuru/common/utils/utils.dart';
import 'package:uhuru/screens/chats/data/isar/chat_collection.dart';
import 'package:uhuru/screens/group/data/api/group_api.dart';
import 'package:uhuru/screens/home_screen/mobile_layout_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../chats/model/chat_model.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  static const String routeName = '/create-group';

  final bool? isSelecting;
  final int? id;
  final List<String>? existingParticipants;
  const CreateGroupScreen({
    Key? key,
    this.isSelecting,
    this.id,
    this.existingParticipants,
  }) : super(key: key);

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  List<ChatModel> contacts = [];
  Map<ChatModel, bool> checkContacts = {};
  List<ChatModel> selectedContacts = [];
  bool _isSelecting = false;
  bool _isCreating = false;
  bool _isAddingP = false;
  int? _groupId;
  String _enteredGroupName = '';
  final TextEditingController groupNameController = TextEditingController();
  File? image;

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void createGroup() async {
    debugPrint('Pressed');
    // await GroupApi().createGroup();
  }

  void addParticipants() async {
    int? groupIdentifier;
    if (widget.id == null) {
      groupIdentifier = _groupId;
    } else {
      groupIdentifier = widget.id;
    }

    setState(() => _isAddingP = true);
    List<String> participants = [];
    if (selectedContacts.isNotEmpty) {
      for (var contact in selectedContacts) {
        participants.add(contact.reciever!);
      }
    }
    final r = await GroupApi().addParticipant(
      id: groupIdentifier!,
      participants: participants,
    );
    if (r != 0) {
      setState(() => _isAddingP = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${participants.length} ${(participants.length > 1) ? 'participants' : 'participant'}'),
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => MobileLayoutScreen(
            screenIndex: 3,
          ),
        ),
      );
    } else {
      setState(() => _isAddingP = false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    groupNameController.dispose();
  }

  @override
  void didChangeDependencies() async {
    if (widget.isSelecting != null && widget.isSelecting != false) {
      setState(() => _isSelecting = widget.isSelecting!);
    }
    final resp = await ChatCollection().getChats();
    if (resp.status != 1) {
      contacts = [];
    } else {
      setState(() {
        contacts = resp.data['chats'];
        if (widget.existingParticipants != null) {
          contacts.removeWhere((number) => widget.existingParticipants!.contains(number.reciever));
        }
        checkContacts = {for (var contact in contacts) contact: false};
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundImage = Theme.of(context).colorScheme.background;
    final textStyle = Theme.of(context).textTheme.bodyMedium;

    return Scaffold(
      backgroundColor: backgroundImage,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          _isSelecting ? AppLocalizations.of(context)!.addparticipants : AppLocalizations.of(context)!.creategroup,
          style: textStyle!.copyWith(fontSize: 20, color: Colors.white),
        ),
      ),
      body: (_isCreating || _isAddingP)
          ? Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
          : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  if (!_isSelecting)
                    Center(
                      child: Stack(
                        children: [
                          image == null
                              ? const CircleAvatar(
                                  child: Icon(
                                    Icons.group,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                  backgroundColor: Color.fromARGB(255, 215, 212, 212),
                                  // backgroundImage:
                                  //     AssetImage("assets/backgroundImage.png"),
                                  radius: 64,
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  backgroundImage: FileImage(image!),
                                  radius: 64,
                                ),
                          Positioned(
                            bottom: -10,
                            left: 80,
                            child: IconButton(
                              onPressed: selectImage,
                              icon: const Icon(Icons.add_a_photo),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (!_isSelecting)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        onChanged: (val) {
                          setState(() => _enteredGroupName = val);
                        },
                        controller: groupNameController,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.entergroupname,
                        ),
                      ),
                    ),
                  if (!_isSelecting)
                    Center(
                      child: ElevatedButton(
                        style: ButtonStyle(),
                        onPressed: _enteredGroupName.trim().isEmpty
                            ? null
                            : () async {
                                if (image == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Choose a photo')),
                                  );
                                } else {
                                  setState(() => _isCreating = true);
                                  final resp = await GroupApi().createGroup(
                                    name: _enteredGroupName,
                                    picture: image!.path,
                                  );
                                  if (resp['success'] != 0) {
                                    setState(() {
                                      _isCreating = false;
                                      _isSelecting = true;
                                      _groupId = resp['id'];
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Retry to create $_enteredGroupName group')),
                                    );
                                  }
                                  setState(() => _isCreating = false);
                                  debugPrint(_enteredGroupName);
                                  debugPrint(image!.path.toString());
                                }
                              },
                        child: Text(AppLocalizations.of(context)!.next),
                      ),
                    ),
                  if (_isSelecting && selectedContacts.isNotEmpty)
                    SizedBox(
                      height: 70,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: selectedContacts
                            .map(
                              (e) => Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      child: Icon(Icons.person, color: Colors.white, size: 30),
                                      backgroundColor: Color.fromARGB(255, 215, 212, 212),
                                    ),
                                    Text(e.receiverName ?? e.reciever!),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),

                  if (_isSelecting && selectedContacts.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                  if (_isSelecting)
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        AppLocalizations.of(context)!.selectcontact,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (_isSelecting)
                    Expanded(
                      child: ListView.builder(
                          itemCount: checkContacts.length,
                          itemBuilder: (ctx, i) {
                            ChatModel contact = contacts[i];

                            // Iterable<ChatModel> keys = checkContacts.keys;
                            // final values = checkContacts.entries.toList();
                            // final value = values[i];
                            // final contact = keys.elementAt(i);

                            return InkWell(
                              onTap: () {
                                if ((checkContacts[contact] == false)) {
                                  setState(() {
                                    checkContacts[contact] = true;
                                    // value == true;
                                    setState(() => selectedContacts.add(contact));
                                  });
                                } else {
                                  checkContacts[contact] = false;
                                  setState(() {
                                    setState(() {
                                      selectedContacts.removeWhere((e) => e.id == contact.id);
                                    });
                                  });
                                }
                              },
                              child: ListTile(
                                leading: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    CircleAvatar(
                                      child: Icon(Icons.person, color: Colors.white, size: 30),
                                      backgroundColor: Color.fromARGB(255, 215, 212, 212),
                                    ),
                                    if (checkContacts[contact] == true)
                                      Positioned(
                                        right: -5,
                                        bottom: -5,
                                        child: Icon(
                                          Icons.check_circle,
                                          color: primaryColor,
                                        ),
                                      )
                                  ],
                                ),
                                title: Text(contact.receiverName ?? contact.reciever ?? ''),
                              ),
                            );
                          }),
                    )
                  // const SelectContactsGroup(),
                ],
              ),
            ),
      floatingActionButton: (_isSelecting && !_isAddingP && selectedContacts.isNotEmpty)
          ? FloatingActionButton(
              onPressed: addParticipants,
              backgroundColor: floatingBtnColor,
              child: IconButton(
                onPressed: addParticipants,
                icon: Icon(
                  Icons.done,
                  color: primaryColor,
                ),
              ),
            )
          : null,
    );
  }
}
