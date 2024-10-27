import 'package:flutter/material.dart';

class BottomSheetContent extends StatelessWidget {
  final VoidCallback? onDelFrom;
  final VoidCallback? onDelForMe;
  final VoidCallback? onDelForEveryone;
  final VoidCallback onTransfer;
  final bool isMe;
  final String sender;
  const BottomSheetContent({
    super.key,
    required this.onTransfer,
    this.onDelFrom,
    this.onDelForMe,
    this.onDelForEveryone,
    required this.isMe,
    required this.sender,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(.9),
      height: isMe ? 188 : 132,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: isMe
            ? Column(
                children: [
                  GestureDetector(
                    onTap: onTransfer,
                    child: ListTile(
                      leading: CircleAvatar(child: Icon(Icons.arrow_forward)),
                      title: Text(
                        'Transfer',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  if (onDelForMe != null)
                    GestureDetector(
                      onTap: onDelForMe,
                      child: ListTile(
                        leading: CircleAvatar(child: Icon(Icons.delete)),
                        title: Text(
                          'Delete for me',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  if (onDelForEveryone != null)
                    GestureDetector(
                      onTap: onDelForEveryone,
                      child: ListTile(
                        leading: CircleAvatar(child: Icon(Icons.delete)),
                        title: Text(
                          'Delete for everyone',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                ],
              )
            : Column(
                children: [
                  GestureDetector(
                    onTap: onTransfer,
                    child: ListTile(
                      leading: CircleAvatar(child: Icon(Icons.arrow_forward)),
                      title: Text(
                        'Transfer',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onDelFrom,
                    child: ListTile(
                      leading: CircleAvatar(child: Icon(Icons.delete)),
                      title: Text(
                        'Delete from $sender',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
