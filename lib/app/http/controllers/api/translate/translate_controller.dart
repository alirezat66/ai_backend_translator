import 'package:ai_translator/app/http/controllers/api/translate/translate.dart';
import 'package:ai_translator/app/http/controllers/api/translate/translation_service.dart';
import 'package:ai_translator/database/mongo/mongo_connection.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:vania/vania.dart';

class TranslateController extends Controller {
  Future<Response> translate(Request request) async {
    request.validate({
      'project_id': 'required',
      'source_language': 'required',
      'destination_languages': 'required',
      'source_translation': 'required',
    }, {
      'project_id.required': 'The project id is required',
      'source_language.required': 'The source language is required',
      'destination_languages.required':
          'The destination languages are required',
    });
    final userId = Auth().id();
    final ObjectId objectUserId = ObjectId.parse(userId.toString());

    final projectId = request.input('project_id');
    final ObjectId objectProjectId = ObjectId.parse(projectId.toString());
    final sourceLanguage = request.input('source_language');
    List<String> destinationLanguages =
        (request.input('destination_languages') as List<dynamic>)
            .map((e) => e.toString())
            .toList();
    Map<String, String> sourceTranslation = Map<String, String>.from(
        request.input('source_translation') as Map<String, dynamic>);
    print(
        "User ID: $userId Project ID: $projectId Source Language: $sourceLanguage Destination Languages: $destinationLanguages Source Translation: $sourceTranslation");

    final apiKey = 'AIzaSyCVou3J7F6mGqE14cQxBE5QKDgarFB5jF8';
    final translationService = AITranslationService(apiKey);

    Map<String, Map<String, String>> translations = await translationService
        .translateJsonWithGemini(sourceTranslation, destinationLanguages);

    List<TranslationModel> formattedTranslations = [];
    print("translations : $translations");
    sourceTranslation.forEach((key, value) {
      Map<String, String> translatedTexts = {};
      for (var lang in destinationLanguages) {
        translatedTexts[lang] = translations[lang]?[key] ?? '';
      }

      formattedTranslations.add(TranslationModel(
          key: key, value: value, translations: translatedTexts));
    });

    TranslateModel translateModel = TranslateModel(
        projectId: objectProjectId,
        userId: objectUserId,
        sourceLanguage: sourceLanguage,
        translations: formattedTranslations);
    print(translateModel.toJson());
    final coll = MongoConnection().db.collection('translations');
    var v1 = await coll.findOne({"project_id": objectProjectId});
    if (v1 == null) {
      await coll.insert(translateModel.toJson());
    } else {
      await coll
          .replaceOne({"project_id": objectProjectId}, translateModel.toJson());
    }
    final response = await coll.findOne({"project_id": objectProjectId});
    return Response(data: {'message': response});
  }
}

final TranslateController translateController = TranslateController();
