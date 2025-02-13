import 'package:flutter/material.dart';

class AppBanner extends StatelessWidget {
  const AppBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.symmetric(
        vertical: 30.0,
        horizontal: 20.0,
      ),
      // decoration: BoxDecoration(
      //   gradient: const LinearGradient(
      //     colors: [Colors.blueAccent, Colors.purple],
      //     begin: Alignment.topRight,
      //     end: Alignment.bottomRight,
      //   ),
      //   borderRadius: BorderRadius.circular(20.0),
      // ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Quiziz',
            style: TextStyle(
              color: Colors.white,
              fontSize: 50,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Join Quiziz and have fun',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
