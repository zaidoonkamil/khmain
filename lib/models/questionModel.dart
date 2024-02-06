import 'package:cloud_firestore/cloud_firestore.dart';

class questionModel{

  final String id;
  final String question;
  final String image;
  final List<String> answers;
  final String correctAnswer;
  questionModel({
    required this.id,
    required this.question,
    required this.image,
    required this.answers,
    required this.correctAnswer,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'image': image,
      'answers': answers,
      'correctAnswer': correctAnswer,
    };
  }

  factory questionModel.fromMap(Map<String, dynamic> map) {
    return questionModel(
      id: map['id'],
      question: map['question'],
      answers: List<String>.from(map['answers']),
      correctAnswer: map['correctAnswer'],
      image: map['image'],
    );
  }

  factory questionModel.fromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final id = snapshot.id;
    data['id'] = id;
    return questionModel.fromMap(data);
  }

}