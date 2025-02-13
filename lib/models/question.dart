import 'dart:io';

class Question {
  final String? id;
  final String questionText;
  final List<String> options;
  final int correctOption;
  final String? imageUrl;
  final File? featuredImage;

  Question({
    this.id,
    required this.questionText,
    required this.options,
    required this.correctOption,
    this.imageUrl,
    this.featuredImage,
  });

  Question copyWith({
    String? id,
    String? questionText,
    List<String>? options,
    int? correctOption,
    String? imageUrl,
    File? featuredImage,
  }) {
    return Question(
      id: id ?? this.id,
      questionText: questionText ?? this.questionText,
      options: options ?? this.options,
      correctOption: correctOption ?? this.correctOption,
      imageUrl: imageUrl ?? this.imageUrl,
      featuredImage: featuredImage ?? this.featuredImage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionText': questionText,
      'options': options,
      'correctOption': correctOption,
      'imageUrl': imageUrl,
    };
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      questionText: json['questionText'],
      options: List<String>.from(json['options'] ?? []),
      correctOption: json['correctOption'],
      imageUrl: json['imageUrl'],
    );
  }

  @override
  String toString() {
    return 'Quiz{id: $id, questionText: $questionText,imageUrl: $imageUrl, options: $options, correctOption: $correctOption, imageUrl: $imageUrl}';
  }
}
