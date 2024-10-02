import 'package:flutter/foundation.dart';
import 'package:todoapp/services/geminiService.dart';
import 'package:todoapp/services/huggingService.dart';
import 'package:todoapp/services/localAIService.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ChatItems extends ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<String> _chats = ['123'];
  List<String> get chats => _chats;
  int _serviceSelected = 0;
  int get serviceSelected => _serviceSelected;

  Future fetchChat() async{
    final SharedPreferences prefs = await _prefs;
    _chats = prefs.getStringList('chats')?? [''];
    // print("14$_chats");
    notifyListeners();
  }
  Future selectedService(int index)async{
    _serviceSelected = index;
   notifyListeners();
  }
  Future addGeminiKey(String apiKey) async {
    print(apiKey.toString() == '' ? 'null' : apiKey.toString());
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('geminiKey', apiKey.toString());
    notifyListeners();
  }
  Future addHuggingKey(String apiKey) async {
    print(apiKey.toString() == '' ? 'null' : apiKey.toString());
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('huggingKey', apiKey.toString());
    notifyListeners();
  }
  Future addChat(String chat) async{
    final SharedPreferences prefs = await _prefs;
    _chats.add(chat);
    await prefs.setStringList('chats', _chats);
    final result = await prefs.getStringList('chats');
    print('18$result');
    notifyListeners();
  }
  void getGeminiResult(String question)async{
    await Geminiservice().sendRequest(question).then((result){
      chats.add(result);  
      notifyListeners();
  });
  }
  void getHuggingResult(String question)async{
    await Huggingservice().sendRequest(question).then((result){
      chats.add(result);  
      notifyListeners();
  });
  }
  void getLocalAIResult(String question)async{
    await LocalAIService().sendRequest(question).then((result){
      chats.add(result);  
      notifyListeners();
  });
  }

}