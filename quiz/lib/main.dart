import 'package:flutter/material.dart';

import 'quiz.dart';
import 'result.dart';

void main() => runApp(QuizApp());

class QuizApp extends StatefulWidget {
  @override
  _QuizAppState createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  int questionIndex = 0;
  int _totalScore = 0;

  void _answerQuestion(int score) {
    _totalScore += score;

    setState(() {
      questionIndex++;
    });
  }

  void _resetQuiz() {
    setState(() {
      questionIndex = 0;
      _totalScore = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    var questions = [
      {
        'questionText': "What is your favorite color?",
        "answers": [
          {'text': 'black', 'score': 10},
          {'text': 'white', 'score': 3},
          {'text': 'red', 'score': 5},
          {'text': 'cyan', 'score': 1},
        ],
      },
      {
        'questionText': "What is your favorite animal?",
        "answers": [
          {'text': 'Deer', 'score': 10},
          {'text': 'Cat', 'score': 2},
          {'text': 'Dog', 'score': 1},
          {'text': 'Lion', 'score': 3},
        ],
      },
      {
        'questionText': "What is your favorite activity?",
        "answers": [
          {'text': 'Sports', 'score': 1},
          {'text': 'Eating', 'score': 2},
          {'text': 'Sleeping', 'score': 3},
          {'text': 'Alcoholism', 'score': 5},
        ],
      },
    ];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("QuizAPP"),
        ),
        body: questionIndex < questions.length
            ? Quiz(
                questions: questions,
                questionIndex: questionIndex,
                answerQuestion: _answerQuestion,
              )
            : QuizResult(
                totalScore: _totalScore,
                resetFunc: _resetQuiz,
              ),
      ),
    );
  }
}
