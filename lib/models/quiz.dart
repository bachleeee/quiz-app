import 'question.dart';
import 'dart:io';

class Quiz {
  final String? id;
  final String title;
  final String description;
  late final List<Question> questions;
  final int timeLimit;
  final int numberQuestion;
  final String imageUrl;
  final File? featuredImage;
  final bool isPlayed;

  Quiz({
    this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    List<Question>? questions,
    this.timeLimit = 0,
    this.numberQuestion = 0,
    this.featuredImage,
    this.isPlayed = false,
  }) : questions = questions ?? [];

  Quiz copyWith(
      {String? id,
      String? title,
      String? description,
      String? imageUrl,
      List<Question>? questions,
      int? timeLimit,
      int? numberQuestion,
      File? featuredImage,
      bool? isPlayed}) {
    return Quiz(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      questions: questions ?? this.questions,
      timeLimit: timeLimit ?? this.timeLimit,
      numberQuestion: numberQuestion ?? this.numberQuestion,
      featuredImage: featuredImage ?? this.featuredImage,
      isPlayed: isPlayed ?? this.isPlayed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'timeLimit': timeLimit,
      'numberQuestion': numberQuestion,
      'questions': questions,
    };
  }

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      numberQuestion: json['numberQuestion'],
      timeLimit: json['timeLimit'],
      title: json['title'],
      questions: json['questions'],
    );
  }

  @override
  String toString() {
    return 'Quiz{id: $id, title: $title,imageUrl: $imageUrl, description: $description, numberQuestion: $numberQuestion, timeLimit: $timeLimit, questions: $questions}';
  }
}
