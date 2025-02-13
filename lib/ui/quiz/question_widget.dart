import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class QuestionWidget extends StatelessWidget {
  final String questionText;
  final List<String> options;
  final int? selectedAnswerIndex;
  final Function(int) onAnswerSelected;
  final bool isAnswered;
  final int correctOption;

  const QuestionWidget({
    Key? key,
    required this.questionText,
    required this.options,
    required this.selectedAnswerIndex,
    required this.onAnswerSelected,
    required this.isAnswered,
    required this.correctOption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 180,
          margin: const EdgeInsets.only(bottom: 20.0),
          padding: const EdgeInsets.symmetric(
            vertical: 30.0,
            horizontal: 20.0,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 98, 157, 252),
                Color.fromARGB(255, 14, 2, 121)
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              questionText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: -1.0, end: 0.0),
          ),
        ),
        ...options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final isSelected = selectedAnswerIndex == index;

          return Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected
                              ? (isAnswered && index == correctOption
                                  ? Colors.green
                                  : Colors.red)
                              : Colors.grey,
                        ),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (!isAnswered) onAnswerSelected(index);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(padding: EdgeInsets.all(16.0)),
                        Text(
                          '${String.fromCharCode(65 + index)}. ',
                          style: TextStyle(
                            color: isSelected
                                ? (isAnswered && index == correctOption
                                    ? Colors.green
                                    : Colors.red)
                                : Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            option,
                            style: TextStyle(
                              color: isSelected
                                  ? (isAnswered && index == correctOption
                                      ? Colors.green
                                      : Colors.red)
                                  : Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ).animate().fadeIn(duration: 500.ms),
                        ),
                      ],
                    ),
                  )),
              if (isAnswered && isSelected)
                Positioned(
                  right: 30,
                  top: 6,
                  child: _buildAnswerFeedback(index == correctOption),
                ),
            ],
          );
        }),
      ],
    );
  }
}

Widget _buildAnswerFeedback(bool isCorrect) {
  return isCorrect
      ? const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 40,
        ).animate().slideX()
      : const Icon(
          Icons.cancel,
          color: Colors.red,
          size: 40,
        ).animate().slideX();
}
