import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mime/mime.dart';
import 'package:uhuru/common/utils/environment.dart';
import 'package:uhuru/common/utils/variables.dart';
import 'package:uhuru/screens/chats/bloc/chat_bloc.dart';
import 'package:uhuru/common/colors.dart';
import 'package:uhuru/screens/chats/data/isar/chat_collection.dart';
import 'package:uhuru/screens/chats/model/chat_model.dart';
import 'package:uhuru/screens/contacts/contacts_screen.dart';
import 'package:uhuru/screens/user_profile/screens/user_profile.dart';
import '../../common/utils/Fx.dart';
import '../messages/messages_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  // bool _isDisposed = false;
  // Timer? _periodicTimer;
  bool isSearching = false;
  bool noChats = false;
  List<ChatModel> chats = [];
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    context.read<ChatBloc>().add(FetchChatsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        // toolbarHeight: isSearching ? 100 : null,
        toolbarHeight: 120,
        leadingWidth: 100,
        elevation: 5,
        title: SizedBox(
          child: BlocConsumer<ChatBloc, ChatState>(
            listener: (context, state) {
              if (state is FetchingChatsState) if (state.notFound) {
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(
                //     content: Text('Not found'),
                //     backgroundColor: messageColor,
                //   ),
                // );
              }
            },
            builder: (context, state) {
              return Container(
                child: isSearching
                    ? RoundedTextField(
                        onChanged: (val) {
                          context.read<ChatBloc>().add(SearchChatEvent(query: val));
                        },
                        onTap: () {
                          setState(() {
                            isSearching = false;
                            context.read<ChatBloc>().add(SearchChatEvent(cancelSearchState: true));
                          });
                        },
                      )
                    : Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => UserProfile(),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 3),
                                  child: Text('Uhuru chats', style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              CircleAvatar(
                                radius: 18,
                                child: Image.asset('assets/U1.png'),
                                backgroundColor: floatingBtnColor,
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          RoundedTextField(
                            onChanged: (val) {
                              context.read<ChatBloc>().add(SearchChatEvent(query: val));
                            },
                          )
                        ],
                      ),
              );
            },
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              // buildWhen: (previous, current) => previous.,
              builder: (context, state) {
                if (state is FetchingChatsState) {
                  if (state.chats!.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            height: 100,
                            width: 100,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Image.asset(
                                'assets/nochats.png',
                                color: Variables.isDarkMode ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'No message, yet',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'No message in your inbox yet',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          'Start chatting with your neighbours',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    );
                  } else {
                    return ListView.builder(
                        itemCount: state.chats!.length,
                        itemBuilder: (ctx, i) {
                          if (state.chats != null) {
                            state.chats!.sort((a, b) => b.time.toString().compareTo(a.time.toString()));
                          }
                          final chat = state.chats![i];
                          debugPrint(state.chats!.toString());
                          debugPrint(chat.reciever.toString());
                          debugPrint('@@@@@@@@@@@@@@@@@@ CHAT NOTIF KEY: ${Variables}');
                          String newMessage;
                          final isContainingEmoji = UtilsFx().containsEmojiCode(chat.lastMessage ?? '');
                          if (isContainingEmoji) {
                            newMessage = UtilsFx().convertToEmoji(chat.lastMessage ?? '');
                          } else {
                            newMessage = chat.lastMessage ?? '';
                          }
                          return Dismissible(
                            key: Key(i.toString()),
                            confirmDismiss: (dir) {
                              final rsp = _showConfirmationDialog(context, chat.chatId!);
                              return rsp;
                            },
                            child: ChatItem(
                              id: chat.id.toString(),
                              chatName: chat.chatId!,
                              picture: chat.picture ?? 'null',
                              time: chat.time,
                              receivername: (chat.receiverName == null || chat.receiverName!.isEmpty) ? chat.reciever! : chat.receiverName!,
                              sender: chat.sender!,
                              receiver: chat.reciever!,
                              lastMessage: newMessage,
                              unread: chat.unread ?? 0,
                              notif_key: chat.notifKey ?? '',
                              sender_notif_name: '${Variables.fullNameString}',
                              contactId: chat.contactId,
                            ),
                          );
                        });
                  }
                }
                return Container();
              },
            ),
          ),
          // ChatItem(),
          // ChatItem(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ContactsScreen())),
        child: Icon(Icons.message, color: primaryColor),
        backgroundColor: floatingBtnColor,
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  final String chatName;
  final String id;
  final String receivername;
  final String sender;
  final String receiver;
  final String lastMessage;
  final String picture;
  final String notif_key;
  final String sender_notif_name;
  final DateTime? time;
  final int unread;
  final String? contactId;

  const ChatItem({
    super.key,
    required this.id,
    required this.chatName,
    required this.picture,
    required this.time,
    required this.receivername,
    required this.sender,
    required this.receiver,
    required this.lastMessage,
    required this.unread,
    required this.notif_key,
    required this.sender_notif_name,
    required this.contactId,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = Uri.parse(Environment.urlHost).resolve(picture).toString();
    String mimeType = lookupMimeType(lastMessage) ?? '';
    debugPrint('@@@@@@@@@@@@@@@@@@ NOTIF KEY: $notif_key');
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => MessagesScreen(
              chatId: id,
              chatName: chatName,
              receivername: receivername,
              sender: sender,
              receiver: receiver,
              receiverPicture: imageUrl,
              notif_key: notif_key,
              sender_notif_name: sender_notif_name,
              contactId: contactId,
            ),
          ),
        );
      },
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    backgroundColor: Colors.transparent,
                    content: SizedBox(
                      height: 300,
                      width: 200,
                      child: GridTile(
                        footer: Container(
                          color: Colors.black.withOpacity(.3),
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 15,
                                child: Center(child: Image.asset('assets/U1.png')),
                              ),
                              Text(
                                receivername,
                                style: TextStyle(color: Colors.white),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (ctx) => MessagesScreen(
                                        chatId: id,
                                        chatName: chatName,
                                        receivername: receivername,
                                        sender: sender,
                                        receiver: receiver,
                                        receiverPicture: imageUrl,
                                        notif_key: notif_key,
                                        sender_notif_name: sender_notif_name,
                                        contactId: contactId,
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.message,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                });
          },
          child: imageUrl.contains('null')
              ? Icon(
                  Icons.account_circle,
                  size: 50,
                )
              : CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(imageUrl),
                  radius: 20,
                  backgroundColor: Colors.grey,
                ),
        ),
        title: Text(receivername),
        subtitle: buildMessageSubtitle(mimeType, lastMessage),
        // Text(
        //   (lastMessage == '')
        //       ? 'Hi send me a message'
        //       : lastMessage.length > 15
        //           ? lastMessage.substring(0, 15) + "..."
        //           : lastMessage,
        //   style: TextStyle(color: Colors.grey),
        // ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(time != null ? UtilsFx().formatDate(date: time!, isChat: true) : ''),
            SizedBox(height: 5),
            if (unread > 0)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: Colors.green,
                  width: 18,
                  height: 18,
                  padding: EdgeInsets.symmetric(horizontal: 3),
                  alignment: Alignment.center,
                  child: Text(
                    unread.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class RoundedTextField extends StatelessWidget {
  final VoidCallback? onTap;
  final Function(String) onChanged;
  const RoundedTextField({this.onTap, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: TextField(
        onChanged: (val) {
          onChanged(val);
        },
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: onTap != null ? 0 : 10),
          prefixIcon: onTap != null
              ? InkWell(
                  onTap: onTap,
                  child: Icon(Icons.search, color: Colors.black),
                )
              : null,
          hintText: 'Search here..',
          hintStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

Widget buildMessageSubtitle(String mimeType, String lastMessage) {
  if (mimeType.startsWith('image')) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [Icon(Icons.image, size: 18)],
    );
  } else if (mimeType.startsWith('audio')) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.headphones, size: 18),
      ],
    );
  } else if (mimeType.startsWith('video')) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.play_arrow, size: 18),
      ],
    );
  } else {
    return Text(
      (lastMessage == '')
          ? 'Hi send me a message'
          : lastMessage.length > 15
              ? lastMessage.substring(0, 15) + "..."
              : lastMessage,
      style: TextStyle(color: Colors.grey),
    ); // Handle unknown mimeTypes gracefully
  }
}

Future<bool> _showConfirmationDialog(BuildContext context, chatId) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.red,
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this chat?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () async {
              final rsp = await ChatCollection().deleteChat(chatId: chatId);
              Navigator.of(context).pop(rsp);
            },
            child: Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
