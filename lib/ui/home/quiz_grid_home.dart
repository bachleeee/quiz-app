import 'package:ct484_project/models/quiz.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../quiz/quiz_detail_screen.dart';
import '../screens.dart';

class QuizGridHome extends StatelessWidget {
  const QuizGridHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final quizs = context
        .select<QuizManager, List<Quiz>>((quizsManager) => quizsManager.quizs)
        .take(3)
        .toList();

    return Row(
      children: quizs.map((quiz) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => QuizDetailScreen(quiz),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Image.network(
                  quiz.imageUrl,
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                ),
                Text(
                  quiz.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
