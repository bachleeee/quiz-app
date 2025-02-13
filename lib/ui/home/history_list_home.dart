import 'package:ct484_project/models/quiz.dart';
import 'package:ct484_project/models/history.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../screens.dart';

class HistoryListHome extends StatelessWidget {
  const HistoryListHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final histories = context.select<HistoryManager, List<History>>(
        (historysManager) => historysManager.historys);

    final quizs = context
        .select<QuizManager, List<Quiz>>((quizsManager) => quizsManager.quizs);

    final filteredHistories = histories.toList()
      ..sort((a, b) => b.playedAt.compareTo(a.playedAt));

    final recentHistories = filteredHistories.take(3).toList();

    return Column(
      children: recentHistories.map((history) {
        final quiz = quizs.firstWhere(
          (quiz) => quiz.id == history.quizId,
        );

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              leading: const Icon(Icons.history, color: Colors.blue),
              title: Text(
                quiz.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                'Played at: ${DateFormat('dd/MM/yyyy hh:mm').format(history.playedAt)}',
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              trailing: Text(
                '${history.score}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
