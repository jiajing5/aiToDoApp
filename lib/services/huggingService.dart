import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Huggingservice {
  final huggingFaceAPI = dotenv.env['HugginFace'];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> getKey()async{
    final SharedPreferences prefs = await _prefs;
    return  prefs.getString('huggingKey')??'';
  }
  
  Future<String> sendRequest(String question) async {
    final huggingKey = await getKey();
    var url = Uri.parse(
        "https://api-inference.huggingface.co/models/mistralai/Mistral-7B-Instruct-v0.2/v1/chat/completions");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $huggingKey'
    };

    final textInput = {
      "model": "mistralai/Mistral-7B-Instruct-v0.2",
      "messages": [
        {"role": "user", "content": "$question"}
      ],
      "max_tokens": 500,
      "stream": false //false回答完全部才一次傳回來
    };
    String result = '';
    var response =
        await http.post(url, body: jsonEncode(textInput), headers: headers);
    if (response.statusCode == 200) {
      // print(response.body);
      result = jsonDecode(response.body)['choices'][0]['message']['content'];
    } else {
      throw Exception("Failed to add todo");
    }
    return result;
  }
}
