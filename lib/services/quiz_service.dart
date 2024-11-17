import '../models/question.dart';
import '../models/quiz.dart';
import 'pocketbase_client.dart';
import 'package:pocketbase/pocketbase.dart';

class QuizService {
  String _getFeaturedImageUrl(PocketBase pb, RecordModel productModel) {
    final featuredImageName = productModel.getStringValue('featuredImage');
    return pb.files.getUrl(productModel, featuredImageName).toString();
  }

  Future<List<Quiz>> fetchQuizzes({String? keyword}) async {
    final List<Quiz> quizzes = [];

    try {
      final pb = await getPocketbaseInstance();

      final filter =
          keyword != null && keyword.isNotEmpty ? 'title ~ "$keyword"' : null;

      final quizModels = await pb.collection('quizzes').getFullList(
            filter: filter,
          );

      for (final quizModel in quizModels) {
        final quizId = quizModel.id;

        final questionModels = await pb.collection('questions').getFullList(
              filter: 'quizId = "$quizId"',
            );

        final quiz = Quiz.fromJson(
          quizModel.toJson()
            ..addAll(
              {'imageUrl': _getFeaturedImageUrl(pb, quizModel)},
            ),
        );

        for (final questionModel in questionModels) {
          quiz.questions.add(Question.fromJson(questionModel.toJson()));
        }
        quizzes.add(quiz);
      }

      print('$quizzes');
      return quizzes;
    } catch (error) {
      print('Không có dữ liệu trả về: $error');
      return quizzes;
    }
  }
}
