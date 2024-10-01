import 'package:mongo_dart/mongo_dart.dart';

class TranslateModel {
  ObjectId? id;
  ObjectId? projectId;
  ObjectId? userId;
  final String? sourceLanguage;
  List<TranslationModel>? translations;

  set setId(ObjectId? value) => id = value;
  set setProjectId(ObjectId? value) => projectId = value;
  set setUserId(ObjectId? value) => userId = value;

  TranslateModel({
    this.id,
    this.projectId,
    this.userId,
    this.sourceLanguage,
    this.translations,
  });

  factory TranslateModel.fromJson(Map<String, dynamic> json) {
    return TranslateModel(
      id: json['_id'],
      projectId: json['project_id'],
      userId: json['user_id'],
      sourceLanguage: json['source_language'],
      translations: json['translations'],
    );
  }

  Map<String, dynamic> toJson() {
    if (id == null) {
      return {
        'project_id': projectId,
        'user_id': userId,
        'source_language': sourceLanguage,
        'translations': translations?.map((e) => e.toJson()).toList() ?? [],
      };
    }
    return {
      '_id': id,
      'project_id': projectId,
      'user_id': userId,
      'source_language': sourceLanguage,
      'translations': translations,
    };
  }
}

class TranslationModel {
  final String key;
  final String value;
  final Map<String, String> translations;

  TranslationModel(
      {required this.key, required this.value, required this.translations});

  factory TranslationModel.fromJson(Map<String, dynamic> json) {
    return TranslationModel(
      key: json['key'],
      value: json['value'],
      translations: json['translations'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
      'translations': translations,
    };
  }
}
