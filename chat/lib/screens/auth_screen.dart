import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:chat/widgets/auth/auth_form.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isAuthenticating = false;

  void _submitAuthForm(
    String email,
    String username,
    String password,
    bool isLogin,
    File profilePic,
  ) async {
    UserCredential authResult;
    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (isLogin) {
        authResult = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } else {
        authResult = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        var ref = FirebaseStorage.instance
            .ref()
            .child('profiles')
            .child('${authResult.user.uid}.jpeg');

        await ref.putFile(profilePic);
        String imageUrl = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection("users")
            .doc(authResult.user.uid)
            .set({
          'email': email,
          'username': username,
          'profile_url': imageUrl,
        });
      }
    } on PlatformException catch (err) {
      setState(() {
        _isAuthenticating = false;
      });

      var message = "An error occured, please check your credentials";

      if (err.message != null) {
        message = err.message;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.network(
              "https://www.pexels.com/photo/1980720/download/",
              fit: BoxFit.cover,
            ),
          ),
          AuthForm(authFunc: _submitAuthForm, authState: _isAuthenticating),
        ],
      ),
    );
  }
}
