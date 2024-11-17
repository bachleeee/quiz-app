import 'package:flutter/material.dart';

import 'quiz_overview_screen.dart';

class QuizResultScreen extends StatelessWidget {
  final int score;
  final int coins;
  final int totalQuestions;

  const QuizResultScreen(
      {super.key,
      required this.score,
      required this.coins,
      required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        backgroundColor: const Color(0xFF13274F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Quiz Completed!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              'Your Score: $score',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                Text(
                  '+ $coins',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Icon(
                  Icons.monetization_on,
                  color: Colors.yellow,
                  size: 40,
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Icon(
              Icons.emoji_events_sharp,
              size: 150,
              color: Colors.yellow,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const QuizOverviewScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.white, width: 2),
                ),
                backgroundColor: const Color.fromARGB(255, 138, 170, 232),
              ),
              child: const Text(
                'PLAY AGAIN',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF001F4F),
    );
  }
}
