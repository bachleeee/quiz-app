class History {
  final String? id;
  final String? quizId;
  final int score;
  final DateTime playedAt;

  History({
    this.id,
    this.quizId,
    required this.score,
    required this.playedAt,
  });

  History copyWith({
    String? id,
    String? playerId,
    String? quizId,
    int? score,
    DateTime? playedAt,
  }) {
    return History(
      id: id ?? this.id,
      quizId: quizId ?? this.quizId,
      score: score ?? this.score,
      playedAt: playedAt ?? this.playedAt,
    );
  }

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id'] as String,
      quizId: json['quizId'] as String,
      score: json['score'] as int,
      playedAt: DateTime.parse(json['playedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quizId': quizId,
      'score': score,
      'playedAt': playedAt.toIso8601String(),
    };
  }
}
