import 'dart:async';
import 'package:ct484_project/models/user.dart';
import 'package:ct484_project/ui/history/history_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/history.dart';
import '../../models/question.dart';
import '../../models/quiz.dart';
import '../screens.dart';
import '../shared/dialog_utils.dart';
import 'question_widget.dart';
import 'quiz_result_screen.dart';

class PlayQuizScreen extends StatefulWidget {
  final Quiz quiz;

  const PlayQuizScreen(this.quiz, {super.key});

  @override
  State<PlayQuizScreen> createState() => _PlayQuizScreenState();
}

class _PlayQuizScreenState extends State<PlayQuizScreen> {
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  bool _isAnswered = false;
  int _score = 0;
  int _coins = 0;
  int _timeLeft = 0;
  Timer? _timer;
  late List<Question> _questions;
  late User _user;
  late int _highestScore;
  String _temporaryScore = '';
  bool _isHintUsed = false;
  bool _isSkipUsed = false;
  bool _isSExtraTimeUsed = false;
  final ValueNotifier<int> _questionNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.quiz.timeLimit;
    _questions = _getRandomizedQuestions();
    _loadCurrentUser();
    _loadUserHistoryQuiz();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _questionNotifier.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUser() async {
    final currentUser = await context.read<UserManager>().fetchCurrentUser();
    setState(() {
      _user = currentUser!;
    });
  }

  Future<void> _loadUserHistoryQuiz() async {
    try {
      final userHistorys =
          await context.read<HistoryManager>().fetchOneUserQuiz(widget.quiz.id);

      final highestScore = userHistorys.isNotEmpty
          ? userHistorys
              .map((history) => history.score)
              .reduce((a, b) => a > b ? a : b)
          : 0;

      setState(() {
        _highestScore = highestScore;
      });
    } catch (error) {
      print('Error fetching user history: lich su $error');
    }
  }

  List<Question> _getRandomizedQuestions() {
    List<Question> shuffledQuestions = List.from(widget.quiz.questions);
    shuffledQuestions.shuffle();
    return shuffledQuestions.take(widget.quiz.numberQuestion).toList();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer?.cancel();
        _showQuizResults();
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
        _isAnswered = false;
        _temporaryScore = '';
        _questionNotifier.value = _currentQuestionIndex;
      });
    } else {
      _showQuizResults();
    }
  }

  void _selectAnswer(int index) {
    if (!_isAnswered) {
      setState(() {
        _selectedAnswerIndex = index;
        _isAnswered = true;
        if (_isCorrectAnswer(index)) {
          _score += 100;
          _coins += 10;
          _temporaryScore = '+100';
        }
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _temporaryScore = '';
          });
        }
        if (_currentQuestionIndex < _questions.length - 1) {
          _nextQuestion();
        } else {
          _showQuizResults();
        }
      });
    }
  }

  bool _isCorrectAnswer(int index) {
    return widget.quiz.questions[_currentQuestionIndex].correctOption == index;
  }

  Future<void> _showQuizResults() async {
    try {
      final userManager = context.read<UserManager>();
      final addHistory = context.read<HistoryManager>();

      int totalScore = 0;
      if (_score == 0) {
        totalScore = _score;
      } else {
        totalScore = _score + _timeLeft;
      }

      final history = History(
        quizId: widget.quiz.id,
        score: totalScore,
        playedAt: DateTime.now(),
      );
      await addHistory.addHistory(history);

      if (totalScore > 0 && totalScore > _highestScore) {
        await userManager.updateUserScore(totalScore);
      }
      if (_coins > 0) {
        await userManager.updateUserCoins(_user, _coins);
      }

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => QuizResultScreen(
            coins: _coins,
            score: totalScore,
            totalQuestions: widget.quiz.numberQuestion,
          ),
        ),
      );
    } catch (error) {
      if (mounted) {
        await showErrorDialog(context, 'Something went wrong.');
      }
    }
  }

  Future<void> _useCoins(User user, int cost) async {
    try {
      final userManager = context.read<UserManager>();
      await userManager.updateUserCoins(user, cost);
    } catch (error) {
      print('Lỗi sử dụng coins $error');
    }
  }

  void _useHint() async {
    int cost = -5;
    if (_user.coins >= 5 && !_isHintUsed) {
      await _useCoins(_user, cost);
      setState(() {
        _loadCurrentUser();
        _isHintUsed = true;
      });
      _eliminateIncorrectChoices();
    }
  }

  void _eliminateIncorrectChoices() {
    final currentQuestion = _questions[_currentQuestionIndex];
    List<int> incorrectAnswers = [];

    for (int i = 0; i < currentQuestion.options.length; i++) {
      if (i != currentQuestion.correctOption) {
        incorrectAnswers.add(i);
      }
    }

    incorrectAnswers.shuffle();
    for (int i = 0; i < 2; i++) {
      int indexToRemove = incorrectAnswers[i];
      currentQuestion.options[indexToRemove] = "";
    }

    setState(() {});
  }

  void _useSkip() async {
    int cost = -10;

    if (_user.coins >= 10) {
      await _useCoins(_user, cost);
      setState(() {
        _score += 100;
        _loadCurrentUser();
        _isSkipUsed = true;
      });
      if (_currentQuestionIndex < _questions.length - 1) {
        _nextQuestion();
      } else {
        _showQuizResults();
      }
    } else {
      await showErrorDialog(context, "Not enough coins to use Skip power-up.");
    }
  }

  void _useExtraTime() async {
    int cost = -10;
    if (_user.coins >= 8) {
      await _useCoins(_user, cost);
      setState(() {
        _timeLeft += 10;
        _isSExtraTimeUsed = true;
        _loadCurrentUser();
      });
    } else {
      await showErrorDialog(context, "Not enough coins to add extra time.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
        ),
      ),
      body: Container(
        color: const Color(0xFF13274F),
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ScoreDisplay(
                        icon: Icons.monetization_on,
                        label: 'Coins',
                        value: '${_user.coins}',
                      ),
                      ScoreDisplay(
                        icon: Icons.star_border,
                        label: 'Score',
                        value: '$_score',
                        temporaryValue:
                            _temporaryScore.isNotEmpty ? _temporaryScore : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: _timeLeft / widget.quiz.timeLimit,
                          backgroundColor: Colors.grey.shade300,
                          color: Colors.redAccent,
                          minHeight: 5,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        ' $_timeLeft',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ValueListenableBuilder<int>(
                    valueListenable: _questionNotifier,
                    builder: (context, value, child) {
                      return QuestionWidget(
                        key: ValueKey<int>(_currentQuestionIndex),
                        questionText:
                            _questions[_currentQuestionIndex].questionText,
                        options: _questions[_currentQuestionIndex].options,
                        selectedAnswerIndex: _selectedAnswerIndex,
                        onAnswerSelected: _selectAnswer,
                        isAnswered: _isAnswered,
                        correctOption:
                            _questions[_currentQuestionIndex].correctOption,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      buildPowerups(
                        context: context,
                        cost: 5,
                        name: 'HINT',
                        icon: Icons.lightbulb,
                        onPressed: _useHint,
                        isUsed: _isHintUsed,
                      ),
                      buildPowerups(
                        context: context,
                        cost: 10,
                        name: 'SKIP',
                        icon: Icons.fast_forward,
                        onPressed: _useSkip,
                        isUsed: _isSkipUsed,
                      ),
                      buildPowerups(
                          context: context,
                          cost: 10,
                          name: 'TIME +',
                          icon: Icons.timer_rounded,
                          onPressed: _useExtraTime,
                          isUsed: _isSExtraTimeUsed),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScoreDisplay extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? temporaryValue;

  const ScoreDisplay({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.temporaryValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue, width: 1.5),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: Colors.orange,
            size: 20,
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          if (temporaryValue != null && temporaryValue!.isNotEmpty)
            Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  temporaryValue!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                )),
        ],
      ),
    );
  }
}

Widget buildPowerups({
  required BuildContext context,
  required String name,
  required int cost,
  required IconData icon,
  required VoidCallback onPressed,
  bool isUsed = false,
}) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: ElevatedButton.icon(
      onPressed: isUsed
          ? null
          : () async {
              bool? confirmed = await showConfirmDialog(
                  context, 'Are you sure you want to use $name power-up?');
              if (confirmed == true) {
                onPressed();
              }
            },
      icon: Icon(icon, color: isUsed ? Colors.grey : Colors.orange[700]),
      label: Text(
        name,
        style: TextStyle(
          color: isUsed ? Colors.grey : Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isUsed ? Colors.grey[300] : Colors.orange[100],
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.orange)),
      ),
    ),
  );
}
