import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String id;
  String userId; // Notun sahibini belirten alan
  String title;
  String content;
  DateTime createdTime;
  DateTime? updatedTime;
  bool isArchived;
  String? imageUrl;
  List<String>? tags;

  Note({
    required this.id,
    required this.userId, // Eklenen alan
    required this.title,
    required this.content,
    required this.createdTime,
    this.updatedTime,
    this.isArchived = false,
    this.imageUrl,
    this.tags,
  });

  // Firestore'dan gelen veriyi dönüştürmek için
  factory Note.fromFirestore(Map<String, dynamic> json, String id) {
    return Note(
      id: id,
      userId: json['userId'], // Eklenen alan
      title: json['title'],
      content: json['content'],
      createdTime: (json['createdTime'] as Timestamp).toDate(),
      updatedTime: json['updatedTime'] != null ? (json['updatedTime'] as Timestamp).toDate() : null,
      isArchived: json['isArchived'] ?? false,
      imageUrl: json['imageUrl'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
    );
  }

  // Firebase'e veri göndermek için
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId, // Eklenen alan
      'title': title,
      'content': content,
      'createdTime': createdTime,
      'updatedTime': updatedTime,
      'isArchived': isArchived,
      'imageUrl': imageUrl,
      'tags': tags,
    };
  }
}
