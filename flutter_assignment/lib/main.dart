// 1) Create a new Flutter App (in this project) and output an AppBar and some text
// below it
// 2) Add a button which changes the text (to any other text of your choice)
// 3) Split the app into three widgets: App, TextControl & Text

import 'package:flutter/material.dart';

void main() => runApp(AssignmentApp());

class AssignmentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Flutter Assignemtn"),
        ),
        body: App(),
      ),
    );
  }
}

class App extends StatefulWidget {
  const App({
    Key key,
  }) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  String content = "This is text";

  void _changeText() {
    setState(() {
      content = "This is different text";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CustomText(
        content: content,
      ),
      Textcontrol(
        action: _changeText,
      ),
    ]);
  }
}

class Textcontrol extends StatelessWidget {
  const Textcontrol({Key key, this.action}) : super(key: key);

  final Function action;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: action, child: Text("Change the text"));
  }
}

class CustomText extends StatelessWidget {
  final String content;

  const CustomText({Key key, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(content);
  }
}
