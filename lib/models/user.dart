import 'dart:io';

class User {
  final String? id;
  final String username;
  final String email;
  final String name;
  final int coins;
  final int dailyPoints;
  final int weeklyPoints;
  final int totalPoints;
  final int gamesPlayed;
  final String avatarUrl;
  final File? featuredImage;

  User(
      {this.id,
      required this.username,
      required this.email,
      this.name = '',
      this.coins = 0,
      this.dailyPoints = 0,
      this.weeklyPoints = 0,
      this.totalPoints = 0,
      this.gamesPlayed = 0,
      this.avatarUrl = '',
      this.featuredImage});

  User copyWith(
      {String? id,
      String? username,
      String? name,
      String? email,
      int? coins,
      int? dailyPoints,
      int? weeklyPoints,
      int? totalPoints,
      int? gamesPlayed,
      String? avatarUrl,
      File? featuredImage
      }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      email: email ?? this.email,
      coins: coins ?? this.coins,
      dailyPoints: dailyPoints ?? this.dailyPoints,
      weeklyPoints: weeklyPoints ?? this.weeklyPoints,
      totalPoints: totalPoints ?? this.totalPoints,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      featuredImage: featuredImage ?? this.featuredImage,
    );
  }

  bool hasFeaturedImage() {
    return featuredImage != null || avatarUrl.isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'name': name,
      'coins': coins,
      'dailyPoints': dailyPoints,
      'weeklyPoints': weeklyPoints,
      'totalPoints': totalPoints,
      'gamesPlayed': gamesPlayed,
      'avatarUrl': avatarUrl,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      coins: json['coins'] ?? '',
      dailyPoints: json['dailyPoints'] ?? '',
      weeklyPoints: json['weeklyPoints'] ?? '',
      totalPoints: json['totalPoints'] ?? '',
      gamesPlayed: json['gamesPlayed'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
    );
  }
}
