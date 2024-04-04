import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rishabh/secretkey.dart';

class OpenAIServices {
  final List<Map<String, String>> message = [];
  Future<String> isArtPromptAPI(String prompt) async {
    try {
      final resp = await http.post(
        Uri.parse('https://api.openai.com/v1/audio/speech'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIAPIKey'
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "user",
              "content":
                  "Does this message want to generate AI picture, image ,art or anythings similar? $prompt. simply answer a yes or no",
            }
          ],
        }),
      );

      if (resp.statusCode == 200) {
        String content =
            jsonDecode(resp.body)['choices'][0]['message']['content'];
        content = content.trim();
      }
      return "An internal Error occured!!";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> chatGPTAPI(String prompt) async {
    message.add({
      "role": "user",
      "content": prompt,
    });
    final resp = await http.post(
      Uri.parse('https://api.openai.com/v1/audio/speech'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $openAIAPIKey'
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": message,
      }),
    );

    if (resp.statusCode == 200) {
      String content =
          jsonDecode(resp.body)['choices'][0]['message']['content'];
      content = content.trim();

      message.add({
        'role': 'assistant',
        'content': content,
      });
      return content;
    }
    return "An internal Error occured!!";
  }

  Future<String> dallEAPI(String prompt) async {
    message.add({
      "role": "user",
      "content": prompt,
    });
    final resp = await http.post(
      Uri.parse('https://api.openai.com/v1/images/generations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $openAIAPIKey'
      },
      body: jsonEncode({
        "model": "dall-e-3",
        "prompt": prompt,
        "n": 1,
      }),
    );

    if (resp.statusCode == 200) {
      String imageUrl = jsonDecode(resp.body)['data'][0]['url'];
      imageUrl = imageUrl.trim();

      message.add({
        'role': 'assistant',
        'content': imageUrl,
      });
      return imageUrl;
    }
    return "An internal Error occured!!";
  }
}
