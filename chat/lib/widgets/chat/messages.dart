import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:chat/widgets/chat/chat_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());

        var docs = snapshot.data.docs;
        return ListView.builder(
          reverse: true,
          itemCount: docs.length,
          itemBuilder: (ctx, i) => ChatBubble(
            key: ValueKey(docs[i].id),
            message: docs[i]['text'],
            isMe: docs[i]['uid'] == user.uid,
            username: docs[i]['username'],
            pfpUrl: docs[i]['user_profile_pic'],
          ),
        );
      },
    );
  }
}
