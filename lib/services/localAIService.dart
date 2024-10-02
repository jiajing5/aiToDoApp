import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LocalAIService {
  Future<String> sendRequest(String question) async {
    var url = Uri.parse("http://192.168.208.58:1234/v1/chat/completions");
    var headers = {
      'Content-Type': 'application/json',
    };

    final textInput = {
      "model": "lmstudio-community/Meta-Llama-3-8B-Instruct-GGUF",
      "messages": [ 
      { "role": "system", "content": "Always answer in rhymes." },
      { "role": "user", "content": question }
    ], 
    "temperature": 0.7, 
    "max_tokens": -1,
    "stream": false
    };
    String result = '';
    var response =
        await http.post(url, body: jsonEncode(textInput), headers: headers);
    if (response.statusCode == 200) {
      print(response.body);
      result = jsonDecode(response.body)['choices'][0]['message']['content'];
    } else {
      throw Exception("Failed to add todo");
    }
    return result;
  }
}
