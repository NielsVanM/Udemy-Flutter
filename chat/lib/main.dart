import 'package:chat/screens/auth_screen.dart';
import 'package:chat/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (ctx, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return null;
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Flutter Chat',
              theme: ThemeData(
                primarySwatch: Colors.cyan,
                backgroundColor: Colors.cyan,
                accentColor: Colors.orange,
                accentColorBrightness: Brightness.dark,
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.orange),
                  ),
                ),
              ),
              home: StreamBuilder(
                  initialData: AuthScreen(),
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      return ChatScreen();
                    }
                    return AuthScreen();
                  }),
            );
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Center(child: CircularProgressIndicator());
        });
  }
}
