import '../models/user.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;

import 'pocketbase_client.dart';

class UserService {
  String _getFeaturedImageUrl(PocketBase pb, RecordModel userModel) {
    final featuredImageName = userModel.getStringValue('featuredImage');
    return pb.files.getUrl(userModel, featuredImageName).toString();
  }

  Future<List<User>> fetchUsers() async {
    final List<User> Users = [];

    try {
      final pb = await getPocketbaseInstance();
      final userModels = await pb.collection('users').getFullList();
      for (final userModel in userModels) {
        Users.add(
          User.fromJson(
            userModel.toJson()
              ..addAll(
                {'avatarUrl': _getFeaturedImageUrl(pb, userModel)},
              ),
          ),
        );
      }
      print('Danh sach user $userModels');

      return Users;
    } catch (error) {
      return Users;
    }
  }

   Future<User?> updateUser(User user) async {
    try {
      final pb = await getPocketbaseInstance();

      final userModel = await pb.collection('users').update(
        user.id!,
        body: user.toJson(),
        files: user.featuredImage != null
            ? [
                http.MultipartFile.fromBytes(
                  'featuredImage',
                  await user.featuredImage!.readAsBytes(),
                  filename: user.featuredImage!.uri.pathSegments.last,
                ),
              ]
            : [],
      );

      return user.copyWith(
        avatarUrl: user.featuredImage != null
            ? _getFeaturedImageUrl(pb, userModel)
            : user.avatarUrl,
      );
    } catch (error) {
      return null;
    }
  }

  Future<User?> updateUserScore(int newScore) async {
    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.model!.id;

      final userModel = await pb.collection('users').getOne(userId);

      final userData = userModel.data;
      int oldTotalPoints = userData['totalPoints'] ?? 0;
      int oldWeeklyPoints = userData['weeklyPoints'] ?? 0;

      int updatedTotalPoints = oldTotalPoints + newScore;
      int updatedWeeklyPoints = oldWeeklyPoints + newScore;

      await pb.collection('users').update(userId, body: {
        'totalPoints': updatedTotalPoints,
        'weeklyPoints': updatedWeeklyPoints,
      });

      print('DỮ LIỆU TRẢ VEFEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE $userModel');
    } catch (error) {
      print("Error updating user score: $error");
      return null;
    }
    return null;
  }

  Future<User?> updateUserCoins(User user, int newCoins) async {
    try {
      final pb = await getPocketbaseInstance();

      int oldTotalCoins = user.coins;

      int updatedTotalCoins = oldTotalCoins + newCoins;

      final updatedUserModel =
          await pb.collection('users').update(user.id!, body: {
        'coins': updatedTotalCoins,
      });

      return user.copyWith(
        coins: updatedUserModel.data['coins'],
      );
    } catch (error) {
      print("Error updating coins: $error");
      return null;
    }
  }
}
