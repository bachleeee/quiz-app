import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../history/history_manager.dart';
import 'quiz_grid.dart';
import '../shared/bottom_navbar.dart';
import 'quiz_manager.dart';

class QuizOverviewScreen extends StatefulWidget {
  const QuizOverviewScreen({super.key});

  @override
  State<QuizOverviewScreen> createState() => _QuizOverviewScreenState();
}

class _QuizOverviewScreenState extends State<QuizOverviewScreen> {
  late Future<void> _fetchQuizs;
  String _searchKeyword = '';
  @override
  void initState() {
    super.initState();
    _loadData(_searchKeyword);
    _fetchQuizs = context.read<QuizManager>().fetchAllQuizs('');
  }

  Future<void> _loadData(String keyword) async {
    try {
      final quizzes = await context.read<QuizManager>().fetchAllQuizs(keyword);
      final userHistorys =
          await context.read<HistoryManager>().fetchAllUserQuizs();

      for (var quiz in quizzes) {
        userHistorys.firstWhere(
          (history) => history.quizId == quiz.id,
        );

        await context.read<QuizManager>().addIsPlayed(quiz.id, true);
      }
    } catch (error) {
      print('Error loading data: $error');
    }
  }

  Future<void> _onSearchChanged(String keyword) async {
    setState(() {
      _searchKeyword = keyword.trim();
      _fetchQuizs = context.read<QuizManager>().fetchAllQuizs(_searchKeyword);
    });
    await _loadData(_searchKeyword.isNotEmpty ? _searchKeyword : '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories quizzes'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search quizzes...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: _onSearchChanged,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _fetchQuizs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return const QuizGrid();
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
