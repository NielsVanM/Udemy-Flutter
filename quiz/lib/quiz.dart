import 'package:flutter/material.dart';

import 'question.dart';
import 'answer.dart';

class Quiz extends StatelessWidget {
  const Quiz({
    Key key,
    @required this.questions,
    @required this.questionIndex,
    @required this.answerQuestion,
  }) : super(key: key);

  final List<Map<String, Object>> questions;
  final int questionIndex;
  final Function answerQuestion;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Question(text: questions[this.questionIndex]['questionText']),
        ...(questions[this.questionIndex]['answers']
                as List<Map<String, Object>>)
            .map((a) {
          return Answer(() => answerQuestion(a['score']), a['text']);
        }).toList()
      ],
    );
  }
}
