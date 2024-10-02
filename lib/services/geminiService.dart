import 'package:http/http.dart' as http;
import 'package:todoapp/services/serviceLibrary.dart';

class Geminiservice {

  final GOOGLE_API_KEY = dotenv.env['GOOGLE_API_KEY'];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> getKey()async{
     final SharedPreferences prefs = await _prefs;
    return  prefs.getString('geminiKey')??'';
  }
  
  Future<String> sendRequest(String question) async {
    final geminiKey = await getKey();
    print("19$geminiKey");
    var url = Uri.parse(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$geminiKey");
    var headers = {'Content-Type': 'application/json'};

    final textInput = {
      "contents": [
        {
          "parts": [
            {"text": '$question'}
          ]
        }
      ]
    };
    String result = '';
    var response =
        await http.post(url, body: jsonEncode(textInput), headers: headers);
    if (response.statusCode == 200) {
      // print(response.body);
      result = jsonDecode(response.body)['candidates'][0]['content']['parts'][0]['text'];
      
    }
    else{
      throw Exception("Failed to add todo");
    }
    return result;
  }
  
}
