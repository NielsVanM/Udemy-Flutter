import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewChatMessage extends StatefulWidget {
  NewChatMessage({Key key}) : super(key: key);

  @override
  _NewChatMessageState createState() => _NewChatMessageState();
}

class _NewChatMessageState extends State<NewChatMessage> {
  var _enteredMessage = '';
  TextEditingController _messageController = TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    var user = FirebaseAuth.instance.currentUser;
    var userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    await FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'uid': user.uid,
      'username': userData['username'],
      'user_profile_pic': userData['profile_url'],
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(labelText: 'Send a message'),
              onChanged: (val) => setState(() {
                _enteredMessage = val;
              }),
            ),
          ),
          TextButton(
            child: Icon(Icons.send),
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}
