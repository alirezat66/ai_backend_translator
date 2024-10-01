import 'dart:convert';

import 'package:http/http.dart' as http;

class AITranslationService {
  final String apiKey;

  AITranslationService(this.apiKey);

  Future<Map<String, Map<String, String>>> translateJsonWithGemini(
      Map<String, String> jsonKeys, List<String> targetLanguages) async {
    final url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$apiKey';

    // Create the prompt from the jsonKeys to send to Gemini for translation
    String prompt = _generatePrompt(jsonKeys, targetLanguages);
    print(prompt);
    // Make the POST request to the Gemini API
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "contents": [
          {
            "parts": [
              {"text": prompt}
            ]
          }
        ]
      }),
    );

    // Check for successful response
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      String translatedText =
          jsonResponse['candidates'][0]['content']['parts'][0]['text'];

      return _parseTranslationResponse(translatedText, targetLanguages);
    } else {
      throw Exception('Failed to translate text: ${response.body}');
    }
  }

  // Helper function to generate the prompt for Gemini
  String _generatePrompt(
      Map<String, String> jsonKeys, List<String> targetLanguages) {
    return '''
Translate the following keys and their English meanings into ${targetLanguages.join(', ')}. 
Make sure to keep the translations natural and contextually appropriate for use in a mobile app.
Provide the output as a JSON object where each key is a language code, and the value is another object containing the translations for that language.

Source text:
${json.encode(jsonKeys)}

Output format:
{
  "fr": { "key1": "French translation 1", "key2": "French translation 2" },
  "es": { "key1": "Spanish translation 1", "key2": "Spanish translation 2" },
  ...
}
''';
  }

  // Helper function to parse the translated response (if returned as JSON text)
  Map<String, Map<String, String>> _parseTranslationResponse(
      String responseText, List<String> targetLanguages) {
    // Assuming the response is returned as a JSON string. Adjust parsing as needed.

    String jsonString =
        responseText.trim().replaceAll('```json', '').replaceAll('```', '');
    Map<String, dynamic> parsedJson = json.decode(jsonString);

    Map<String, Map<String, String>> result = {};
    for (var lang in targetLanguages) {
      if (parsedJson.containsKey(lang)) {
        result[lang] = Map<String, String>.from(parsedJson[lang]);
      }
    }
    return result;
  }
}
