import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String username;
  final String pfpUrl;

  const ChatBubble({
    Key key,
    this.message,
    this.isMe,
    this.username,
    this.pfpUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
                minWidth: 100,
                maxWidth: MediaQuery.of(context).size.width * .7),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: isMe ? Colors.grey[400] : Theme.of(context).accentColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12),
                bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
              ),
            ),
            child: Stack(
              overflow: Overflow.visible,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      message,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                if (!isMe)
                  Positioned(
                    top: -15,
                    right: -35,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(pfpUrl),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    ]);
  }
}
