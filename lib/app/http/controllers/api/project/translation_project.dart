import 'package:mongo_dart/mongo_dart.dart';

class TranslationProject {
  ObjectId? id;
  ObjectId? userId;
  final String? projectName;
  final String? description;
  String? projectApiToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  set setId(ObjectId? value) => id = value;
  set setUserId(ObjectId? value) => userId = value;
  set setProjectApiToken(String token) => projectApiToken = token;
  TranslationProject({
    this.id,
    this.userId,
    this.projectName,
    this.description,
    this.projectApiToken,
    this.createdAt,
    this.updatedAt,
  });

  factory TranslationProject.fromJson(Map<String, dynamic> json) {
    return TranslationProject(
      id: json['_id'],
      userId: json['user_id'],
      projectName: json['project_name'],
      description: json['description'],
      projectApiToken: json['project_api_token'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    if (id == null) {
      return {
        'user_id': userId,
        'project_name': projectName,
        'description': description,
        'project_api_token': projectApiToken,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
    }
    return {
      '_id': id,
      'user_id': userId,
      'project_name': projectName,
      'description': description,
      'project_api_token': projectApiToken,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
