import 'package:flutter/material.dart';
import '../../models/quiz.dart';
import 'quiz_play_screen.dart';

class QuizDetailScreen extends StatelessWidget {
  static const routeName = '/product_detail';

  const QuizDetailScreen(
    this.quiz, {
    super.key,
  });

  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text("Quiz Detail"),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Image.network(
                        quiz.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  quiz.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: _buildQuizDetailItem(
                          icon: Icons.question_answer,
                          label: '${quiz.numberQuestion} Questions',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildQuizDetailItem(
                          icon: Icons.star,
                          label: '+${quiz.numberQuestion * 100} Points',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildQuizDetailItem(
                          icon: Icons.access_time,
                          label: '${quiz.timeLimit}s',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    quiz.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => PlayQuizScreen(quiz),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                backgroundColor: const Color.fromARGB(255, 13, 68, 113),
              ),
              child: const Text(
                'Play Quiz',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizDetailItem({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: const Color.fromARGB(255, 13, 68, 113),
          width: 1.5,
        ),
      ),
      child: Column(
        children: <Widget>[
          Icon(
            icon,
            size: 30,
            color: const Color.fromARGB(255, 4, 33, 84),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
