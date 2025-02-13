import 'package:ct484_project/ui/home/history_list_home.dart';
import 'package:ct484_project/ui/home/quiz_grid_home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/user.dart';
import '../history/history_manager.dart';
import '../screens.dart';
import '../shared/bottom_navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user;
  late Future<void> _fetchQuizs;

  @override
  void initState() {
    super.initState();
    _fetchUser();
    _fetchQuizs = context.read<QuizManager>().fetchQuizs();
    _loadData();
  }

  Future<void> _fetchUser() async {
    try {
      final userManager = context.read<UserManager>();
      final fetchedUser = await userManager.fetchCurrentUser();
      if (mounted) {
        setState(() {
          user = fetchedUser;
        });
      }
    } catch (e) {
      print("Failed to fetch user: $e");
    }
  }

  Future<void> _loadData() async {
    try {
      final quizzes = await context.read<QuizManager>().fetchAllQuizs('');
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

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiziz'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(user?.avatarUrl ?? ''),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome back,',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.name ?? 'Guest',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue, width: 1.5),
                  ),
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        Icons.monetization_on,
                        color: Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${user?.coins ?? 0}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 350,
                  height: 200,
                  child: Image.network(
                    'https://static.vecteezy.com/system/resources/previews/001/637/932/non_2x/quiz-time-banner-vector.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Top Categories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: _fetchQuizs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return const QuizGridHome();
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Recent result',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            HistoryListHome()
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
