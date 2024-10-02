import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; //轉換json檔
import 'package:todoapp/model/itemData.dart';

class HttpService {
  Future<Map<String, Item>> getTodos() async {
    var url = Uri.parse("http://127.0.0.1:5000/todos");
    var response = await http.get(url); //獲取todos
    if(response.statusCode != 200) {
      throw Exception("Failed to load todos");
    }else{
      Map<String, dynamic> data = (json.decode(response.body)); //用json解析值
      print(data);
      final todoItems = data.map((key, value){
        // 將每個項目value值轉為 Item 物件
        return MapEntry(key, Item(title: value['title'], description: value['description'], todoValue: value['todoValue']));
      });
      return todoItems; 
    }
  }

  Future<void> postTodo(Map data) async{
    var url = Uri.parse("http://127.0.0.1:5000/todos");
    var headers = {'Content-Type': 'application/json'};
    var response = await http.post(url, body: jsonEncode(data),headers: headers);
    if(response.statusCode != 201) {
      throw Exception("Failed to add todo");
    }else{
      print(response.body);
    }
  }

  Future<void> updateTodo(Item data) async{
    var url = Uri.parse("http://127.0.0.1:5000/todos/${data.title}");
    var headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> dataMap = {'title': data.title,'description': data.description, 'todoValue':data.todoValue};
    var response = await http.post(url, body: jsonEncode(dataMap),headers: headers);
    print(response.body);
  }

  Future<void> deleteTodo(String title) async{
    var url = Uri.parse("http://127.0.0.1:5000/todos/$title");
    var response = await http.delete(url);
    print(response.body);
  }
}