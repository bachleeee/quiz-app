import 'package:flutter/material.dart';

import '../../models/history.dart';
import '../../services/history_service.dart';

class HistoryManager extends ChangeNotifier {
  final HistoryService _historyService = HistoryService();
  List<History> _historys = [];

  int get historyCount {
    return _historys.length;
  }

  List<History> get historys {
    return [..._historys];
  }

  Future<void> addHistory(History history) async {
    final newHistory = await _historyService.addHistory(history);
    if (newHistory != null) {
      _historys.add(newHistory);
      notifyListeners();
    }
  }

  Future<List<History>> fetchOneUserQuiz(String? quizId) async {
    _historys = await _historyService.fetchHistorys(quizId: quizId);
    notifyListeners();
    return _historys;
  }

  Future<List<History>> fetchAllUserQuizs() async {
    _historys = await _historyService.fetchHistorys();
    notifyListeners();
    return _historys;
  }
}
