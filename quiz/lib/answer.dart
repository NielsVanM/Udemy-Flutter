import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  Answer(this.answerQuestion, this.answerText);

  final Function answerQuestion;
  final String answerText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        onPressed: this.answerQuestion,
        color: Colors.blue[300],
        child: Text(
          this.answerText,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
