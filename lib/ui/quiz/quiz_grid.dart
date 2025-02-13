import 'package:ct484_project/models/quiz.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'quiz_manager.dart';
import 'quiz_grid_tile.dart';

class QuizGrid extends StatelessWidget {
  const QuizGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final quizs = context
        .select<QuizManager, List<Quiz>>((quizsManager) => quizsManager.quizs);
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: quizs.length,
      itemBuilder: (ctx, i) => QuizGridTile(quizs[i]),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
    );
  }
}
