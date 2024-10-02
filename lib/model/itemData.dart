import 'package:flutter/foundation.dart';

class Item extends ChangeNotifier {
  String? title;
  String? description;
  bool? todoValue;
  Item({ this.title, this.description, this.todoValue});
  Map<String,Item> _data = {};
  Map<String,Item> get data => _data;
  void addData(Map<String,Item> data){
    _data[data.entries.first.key]=data.entries.first.value;
    notifyListeners();
  }
  void updateData(Map<String, Item> data) {
    _data[data.entries.first.key]=data.entries.first.value;
    notifyListeners();
  }
  void deleteData(String data) {
    _data.remove(data);
    notifyListeners();
  }
  void sendData(Map<String, Item> data){
    _data = data;
    notifyListeners();
  }
}