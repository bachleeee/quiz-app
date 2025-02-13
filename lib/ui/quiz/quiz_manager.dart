import 'package:ct484_project/services/quiz_service.dart';
import 'package:flutter/material.dart';

import '../../../models/quiz.dart';

class QuizManager extends ChangeNotifier {
  final QuizService _quizsService = QuizService();

  List<Quiz> _quizs = [];

  int get quizCount {
    return _quizs.length;
  }

  List<Quiz> get quizs {
    return [..._quizs];
  }

  Quiz? findById(String id) {
    try {
      return _quizs.firstWhere((quiz) => quiz.id == id);
    } catch (error) {
      return null;
    }
  }

  Future<void> fetchQuizs() async {
    _quizs = await _quizsService.fetchQuizzes();
    notifyListeners();
  }
  
  // Future<void> fetchQuizsWithKeyWord(String keyword) async {
  //   _quizs = await _quizsService.fetchQuizzes(keyword: keyword);
  //   notifyListeners();
  // }

  Future<List<Quiz>> fetchAllQuizs(String keyword) async {
    _quizs = await _quizsService.fetchQuizzes(keyword: keyword);
    notifyListeners();
    return _quizs;
  }

  Future<void> addIsPlayed(String? quizId, bool isPlayed) async {
    final quizIndex = _quizs.indexWhere((quiz) => quiz.id == quizId);
    print('quizId $quizId');
    if (quizIndex != -1) {
      _quizs[quizIndex] = _quizs[quizIndex].copyWith(isPlayed: isPlayed);
      notifyListeners();
    }
  }
}
