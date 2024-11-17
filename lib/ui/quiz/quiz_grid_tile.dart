import 'package:flutter/material.dart';
import '../../models/quiz.dart';
import 'quiz_detail_screen.dart';

class QuizGridTile extends StatelessWidget {
  const QuizGridTile(
    this.quiz, {
    super.key,
  });

  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => QuizDetailScreen(quiz),
                ),
              );
            },
            child: Stack(
              children: [
                Image.network(
                  quiz.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 140,
                ),
                if (quiz.isPlayed)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Completed',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      quiz.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
