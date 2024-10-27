import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uhuru/common/colors.dart';
import 'package:uhuru/common/utils/environment.dart';
import 'package:uhuru/common/utils/utils.dart';
import 'package:uhuru/common/utils/variables.dart';
import 'package:uhuru/screens/group/bloc/group_bloc.dart';
import 'package:uhuru/screens/group/bloc/participants/participants_bloc.dart';
import 'package:uhuru/screens/group/data/api/group_api.dart';
import 'package:uhuru/screens/group/data/isar/group_collection.dart';
import 'package:uhuru/screens/home_screen/mobile_layout_screen.dart';
import 'create_group_screen.dart';
import 'data/isar/participant_collection.dart';
import 'data/model/participant_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GroupDetailsScreen extends StatefulWidget {
  final String groupName;
  final String groupPicture;
  final int groupId;
  final int id;
  final List<ParticipantModel> participants;
  const GroupDetailsScreen({
    super.key,
    required this.id,
    required this.groupId,
    required this.groupName,
    required this.groupPicture,
    required this.participants,
  });

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  final String adminNumber = '';
  int? _participantId;
  bool isCurrentUserAdmin = false;
  bool isEditing = false;
  bool isDeleting = false;
  bool isRemovingMember = false;

  bool _isLoading = false;
  bool imageSelected = false;
  bool isSending = false;
  bool hasNameChange = false;

  String? changedName;

  File? image;
  @override
  void initState() {
    super.initState();
  }

  bool isAdminExist(List<ParticipantModel> admins, String targetPhoneNumber) {
    for (var admin in admins) {
      if (admin.phone == targetPhoneNumber) {
        return true;
      }
    }
    return false;
  }

  int getParticipantId(List<ParticipantModel> participants) {
    final participant = participants.firstWhere((e) => e.phone == Variables.phoneNumber);
    debugPrint(participant.remoteId.toString());
    return participant.remoteId ?? 0;
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    if (image != null) {
      setState(() {
        isSending = true;
        imageSelected = true;
      });
      final rps = await GroupApi().editGroup(
        groupId: widget.groupId,
        picture: image!.path,
        currentGroupName: widget.groupName,
        currentGroupPicture: widget.groupPicture,
      );

      if (rps) {
        final r = await GroupCollection().editGroup(picture: image!.path, id: widget.id);
        if (r) {
          setState(() {
            isSending = false;
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.check_circle),
              SizedBox(width: 10),
              Text(AppLocalizations.of(context)!.imagechanged),
            ],
          ),
          behavior: SnackBarBehavior.floating,
        ));

        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } else {
        setState(() {
          imageSelected = false;
          isSending = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.checkyourinternetconnection),
          behavior: SnackBarBehavior.floating,
        ));
      }
    }

    debugPrint('++++++++$image++++++++');
  }

  @override
  Widget build(BuildContext context) {
    context.read<ParticipantsBloc>().add(FetchGroupParticipantEvent(groupId: widget.groupId));
    final borderColor = Theme.of(context).colorScheme.onBackground;
    final editController = TextEditingController(text: '${widget.groupName.toUpperCase()}');
    return Scaffold(
        appBar: AppBar(elevation: 0),
        body: BlocBuilder<ParticipantsBloc, ParticipantsState>(
          builder: (context, state) {
            if (state.participants.isNotEmpty) {
              _participantId = getParticipantId(state.participants);
              final admins = state.participants.where((e) => e.isAdmin == true).toList();
              debugPrint('Admins: $admins');
              isCurrentUserAdmin = isAdminExist(admins, Variables.phoneNumber);
              debugPrint(_participantId.toString());
            }
            return Column(
              children: <Widget>[
                Stack(
                  children: [
                    Center(
                      child: imageSelected
                          ? CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: FileImage(image!),
                              radius: 64,
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: CachedNetworkImageProvider(widget.groupPicture),
                              // backgroundImage: FileImage(image!),
                              radius: 64,
                            ),
                    ),
                    if (isCurrentUserAdmin)
                      Positioned(
                        bottom: -10,
                        right: 110,
                        child: IconButton(onPressed: selectImage, icon: const Icon(Icons.add_a_photo)),
                      )
                  ],
                ),

                SizedBox(height: 10),
                Text(
                  hasNameChange ? changedName ?? '' : widget.groupName.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(thickness: 2),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        if (isCurrentUserAdmin)
                          Container(
                            child: TextButton.icon(
                              icon: Icon(
                                Icons.edit,
                                size: 20,
                                color: borderColor,
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return AlertDialog(
                                        content: IntrinsicHeight(
                                          child: Column(
                                            children: [
                                              Text(AppLocalizations.of(context)!.editgroup),
                                              TextField(
                                                controller: editController,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text(
                                                      'Cancel',
                                                      style: TextStyle(color: borderColor),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      if (editController.text.trim().isEmpty) {
                                                        return;
                                                      } else {
                                                        final rps = await GroupApi().editGroup(
                                                          groupId: widget.groupId,
                                                          groupName: editController.text.trim(),
                                                          currentGroupName: widget.groupName,
                                                          currentGroupPicture: widget.groupPicture,
                                                        );

                                                        if (rps) {
                                                          final r = await GroupCollection().editGroup(
                                                            groupName: editController.text.trim(),
                                                            id: widget.id,
                                                          );
                                                          if (r) {
                                                            setState(() {
                                                              isSending = false;
                                                              hasNameChange = true;
                                                              changedName = editController.text.trim();
                                                            });
                                                          }
                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                            content: Text('Image changed'),
                                                            behavior: SnackBarBehavior.floating,
                                                          ));
                                                        } else {
                                                          setState(() {
                                                            imageSelected = false;
                                                            isSending = false;
                                                          });
                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                            content: Text('Check your internet connection'),
                                                            behavior: SnackBarBehavior.floating,
                                                          ));
                                                        }
                                                      }
                                                      Navigator.of(ctx).pop();
                                                    },
                                                    child: Text(
                                                      'Confirm',
                                                      style: TextStyle(color: borderColor),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              label: Text(
                                AppLocalizations.of(context)!.editname,
                                style: TextStyle(color: borderColor),
                              ),
                            ),
                          ),
                        SizedBox(width: 10),
                        BlocBuilder<GroupBloc, GroupState>(
                          builder: (context, state) {
                            return Container(
                              child: TextButton.icon(
                                icon: Icon(Icons.exit_to_app, color: borderColor),
                                onPressed: () async {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return AlertDialog(
                                          content: IntrinsicHeight(
                                            child: StatefulBuilder(builder: (context, inerState) {
                                              return _isLoading
                                                  ? Text('${AppLocalizations.of(context)!.pleasewaitamoment}...')
                                                  : Column(
                                                      children: [
                                                        Text.rich(TextSpan(text: 'Do you want to exit ', children: [
                                                          TextSpan(text: '${widget.groupName.toUpperCase()}', style: TextStyle(color: Colors.red)),
                                                          TextSpan(text: ' group ?'),
                                                        ])),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                              child: Text(
                                                                AppLocalizations.of(context)!.cancel,
                                                                style: TextStyle(color: borderColor),
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed: () async {
                                                                debugPrint('Trying existing');
                                                                inerState(() {
                                                                  _isLoading = true;
                                                                });
                                                                debugPrint(_isLoading.toString());
                                                                final rsp = await GroupApi().exitGroup(
                                                                  groupId: widget.groupId,
                                                                  particpantId: _participantId,
                                                                  context: context,
                                                                );
                                                                debugPrint('EXITD $rsp');
                                                                if (rsp) {
                                                                  final exited = await GroupCollection().setToExited(
                                                                    groupID: widget.groupId.toString(),
                                                                    context: context,
                                                                  );
                                                                  if (exited) {
                                                                    debugPrint('Exited set loc');
                                                                    inerState(() {
                                                                      _isLoading = false;
                                                                    });
                                                                    Navigator.of(context).pop();
                                                                    Navigator.of(context).pushReplacement(
                                                                      MaterialPageRoute(
                                                                        builder: (ctx) => MobileLayoutScreen(
                                                                          screenIndex: 3,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    inerState(() {
                                                                      _isLoading = false;
                                                                    });
                                                                  }
                                                                } else {
                                                                  inerState(() {
                                                                    _isLoading = false;
                                                                  });
                                                                }
                                                                // await Future.delayed(Duration(seconds: 2));
                                                                debugPrint(_isLoading.toString());
                                                              },
                                                              child: Text(
                                                                AppLocalizations.of(context)!.confirm,
                                                                style: TextStyle(color: borderColor),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    );
                                            }),
                                          ),
                                        );
                                      });
                                },
                                label: Text(
                                  AppLocalizations.of(context)!.exit,
                                  style: TextStyle(color: borderColor),
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                    if (isSending)
                      Positioned(
                        left: 0,
                        right: 0,
                        child: IntrinsicWidth(
                          child: Container(
                            height: 60,
                            margin: EdgeInsets.symmetric(horizontal: 70),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color.fromARGB(255, 134, 133, 133),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Center(
                                  child: Row(
                                children: [
                                  CircularProgressIndicator(
                                    color: messageColor,
                                  ),
                                  SizedBox(width: 10),
                                  Text('${AppLocalizations.of(context)!.pleasewaitamoment}...'),
                                ],
                              )),
                              // child:
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                // if (isCurrentUserAdmin)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(thickness: 2),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.members,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Expanded(
                  child: ListView.builder(
                      itemCount: state.participants.length,
                      itemBuilder: (ctx, i) {
                        final participant = state.participants[i];

                        debugPrint('Name:${participant.name} IsActive: ${participant.isActive}');
                        final uri = Uri.parse(Environment.host).resolve(participant.picture ?? 'null').toString();
                        if (participant.isAdmin ?? false) {}
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(uri),
                            radius: 20,
                            child: uri.contains('null') ? Icon(Icons.group, color: Colors.white) : Container(),
                            backgroundColor: Colors.white,
                          ),
                          title: Text(participant.name.toString()),
                          subtitle: participant.isAdmin == true
                              ? Text(
                                  AppLocalizations.of(context)!.groupadmin,
                                  style: TextStyle(color: messageColor),
                                )
                              : Text(
                                  AppLocalizations.of(context)!.member,
                                  style: TextStyle(color: Colors.grey),
                                ),
                          trailing: (isCurrentUserAdmin && participant.isAdmin == false)
                              ? PopupMenuButton<int>(
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem<int>(
                                        value: 1,
                                        child: Text(AppLocalizations.of(context)!.makegroupadmin),
                                      ),
                                      // PopupMenuItem<int>(
                                      //   value: 2,
                                      //   child: Text(AppLocalizations.of(context)!.removefromgroup),
                                      // )
                                    ];
                                  },
                                  onSelected: (val) async {
                                    if (val == 2) {
                                      setState(() {
                                        isSending = true;
                                      });
                                      debugPrint(_isLoading.toString());
                                      final rsp = await GroupApi().exitGroup(
                                        groupId: widget.groupId,
                                        particpantId: participant.remoteId,
                                        context: context,
                                      );
                                      debugPrint('EXITD $rsp');
                                      if (rsp) {
                                        await GroupParicipantCollection().deleteParicipant(id: participant.id ?? 0);
                                        setState(() {
                                          isSending = false;
                                        });
                                        context.read<ParticipantsBloc>().add(FetchGroupParticipantEvent(groupId: widget.groupId));
                                      } else {
                                        setState(() {
                                          isSending = false;
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Center(child: Text(AppLocalizations.of(context)!.somethingwentwrong)),
                                          behavior: SnackBarBehavior.floating,
                                        ));
                                      }
                                    }
                                    if (val == 1) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Center(child: Text('Making ${participant.name} group admin')),
                                        behavior: SnackBarBehavior.floating,
                                      ));

                                      final rsp = await GroupApi().makeGroupAdmin(
                                        groupId: widget.groupId,
                                        particpantId: participant.remoteId,
                                      );
                                      debugPrint('Admin $rsp');
                                      if (rsp) {
                                        final madeAdmin = await GroupParicipantCollection().makeGroupAdmin(id: participant.id ?? 0);
                                        if (madeAdmin) {
                                          setState(() {});
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: SizedBox(
                                                width: 100,
                                                child: Center(
                                                    child: Row(
                                                  children: [
                                                    Icon(Icons.check_circle),
                                                    SizedBox(width: 5),
                                                    Text(AppLocalizations.of(context)!.nowadmin),
                                                  ],
                                                ))),
                                            behavior: SnackBarBehavior.floating,
                                          ));
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: IntrinsicWidth(child: Center(child: Text(AppLocalizations.of(context)!.anerroroccuredduringtheprocess))),
                                            behavior: SnackBarBehavior.floating,
                                          ));
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: IntrinsicWidth(child: Center(child: Text(AppLocalizations.of(context)!.anerroroccuredduringtheprocess))),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                )
                              : null,
                        );
                      }),
                ),
                SizedBox(height: 50),
              ],
            );
          },
        ),
        floatingActionButton: BlocBuilder<ParticipantsBloc, ParticipantsState>(
          builder: (context, state) {
            final admins = state.participants.where((e) => e.isAdmin == true).toList();
            bool isAdmin = isAdminExist(admins, Variables.phoneNumber);
            return isAdmin
                ? FloatingActionButton(
                    onPressed: () {
                      List<String>? particPhones = [];
                      for (var p in widget.participants) {
                        String phone = p.phone!;
                        particPhones.add(phone);
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => CreateGroupScreen(
                            isSelecting: true,
                            id: widget.groupId,
                            existingParticipants: particPhones,
                          ),
                        ),
                      );
                    },
                    backgroundColor: btnBackgroundColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.group_add,
                          size: 20,
                          color: Colors.white,
                        ),
                        Text(
                          AppLocalizations.of(context)!.add,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                : Container();
          },
        ));
  }
}
