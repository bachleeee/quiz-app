import '../models/history.dart';

import 'pocketbase_client.dart';

class HistoryService {
  Future<History?> addHistory(History history) async {
    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.model!.id;

      final historyModel = await pb.collection('history').create(
        body: {...history.toJson(), 'userId': userId},
      );
      print('lich su $historyModel');
      return history.copyWith(
        id: historyModel.id,
      );
    } catch (error) {
      return null;
    }
  }

 Future<List<History>> fetchHistorys({String? quizId}) async {
  final List<History> historys = [];

  try {
    final pb = await getPocketbaseInstance();
    final userId = pb.authStore.model!.id;

    String filter = "userId='$userId'";
    if (quizId != null) {
      filter += " && quizId='$quizId'";
    }

    final historyModels = await pb.collection('history').getFullList(
          filter: filter,
        );
    for (final historyModel in historyModels) {
      historys.add(
        History.fromJson(historyModel.toJson()),
      );
    }
    return historys;
  } catch (error) {
    print('Error fetching historys: $error');
    return historys;
  }
}

}
