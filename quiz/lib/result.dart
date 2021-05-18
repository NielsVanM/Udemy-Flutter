import 'package:flutter/material.dart';

class QuizResult extends StatelessWidget {
  final int totalScore;
  final Function resetFunc;

  const QuizResult({Key key, this.totalScore, this.resetFunc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            "You have Finished, your score was $totalScore",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          FlatButton(
            onPressed: resetFunc,
            child: Text("Reset Quiz"),
            color: Colors.blue,
          )
        ],
      ),
    );
  }
}
