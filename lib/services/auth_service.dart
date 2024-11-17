import 'package:http/http.dart' as http;

import '../models/user.dart';

import 'pocketbase_client.dart';
import 'dart:math';
import 'package:pocketbase/pocketbase.dart';

class AuthService {
  void Function(User? user)? onAuthchange;

  AuthService({this.onAuthchange}) {
    if (onAuthchange != null) {
      getPocketbaseInstance().then((pb) {
        pb.authStore.onChange.listen((event) {
          onAuthchange!(event.model == null
              ? null
              : User.fromJson(event.model!.toJson()));
        });
      });
    }
  }

  Future<User> signup(String email, String password) async {
    final pb = await getPocketbaseInstance();

    final random = Random();
    final randomNumber = random.nextInt(90000) + 10000;
    final randomName = 'NewUser$randomNumber';

    const imageUrl =
        'https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper.png';

    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to load image');
      }

      final imageFile = http.MultipartFile.fromBytes(
        'featuredImage',
        response.bodyBytes,
        filename: 'avatar.png',
      );

      final record = await pb.collection('users').create(
        body: {
          'email': email,
          'password': password,
          'passwordConfirm': password,
          'name': randomName,
          'coins': 1000,
          'dailyPoints': 0,
          'weeklyPoints': 0,
          'totalPoints': 0,
          'gamesPlayed': 0,
        },
        files: [imageFile],
      );

      // final avatarUrl =
      //     '${pb.baseUrl}/api/files/_pb_users_auth_/${record.id}/${imageFile.filename}';

      // await pb.collection('users').update(record.id, body: {
      //   'avatarUrl': avatarUrl,
      // });

      return User.fromJson(record.toJson());
    } catch (error) {
      if (error is ClientException) {
        throw Exception(error.response['message']);
      }
      throw Exception('An error occurred');
    }
  }

  Future<User> login(String email, String password) async {
    final pb = await getPocketbaseInstance();

    try {
      final authRecord =
          await pb.collection('users').authWithPassword(email, password);
      return User.fromJson(authRecord.record!.toJson());
    } catch (error) {
      if (error is ClientException) {
        throw Exception(error.response['message']);
      }
      throw Exception('An error occurred');
    }
  }

  Future<void> logout() async {
    final pb = await getPocketbaseInstance();
    pb.authStore.clear();
  }

  Future<User?> getUserFromStore() async {
    final pb = await getPocketbaseInstance();
    final model = pb.authStore.model;

    if (model == null) {
      return null;
    }

    return User.fromJson(
      model.toJson()
        ..addAll(
          {'avatarUrl': _getFeaturedImageUrl(pb, model)},
        ),
    );
  }

  String _getFeaturedImageUrl(PocketBase pb, RecordModel userModel) {
    final featuredImageName = userModel.getStringValue('featuredImage');
    return pb.files.getUrl(userModel, featuredImageName).toString();
  }
}
