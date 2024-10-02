import 'package:flutter/material.dart';
import 'package:todoapp/model/aiData.dart';
import 'package:provider/provider.dart';

class Apikeypage extends StatefulWidget {
  const Apikeypage({super.key});

  @override
  State<Apikeypage> createState() => _ApikeypageState();
}

class _ApikeypageState extends State<Apikeypage> {
  TextEditingController geminiKey = TextEditingController();
  TextEditingController huggingKey = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: geminiKey,
            ),
          ),
          ElevatedButton(onPressed: () {
            context.read<ChatItems>().addGeminiKey(geminiKey.text);
          }, child: Text("AddGemini"))
        ],
      ),
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: huggingKey,
            ),
          ),
          ElevatedButton(onPressed: () {
            context.read<ChatItems>().addHuggingKey(huggingKey.text);
          }, child: Text("AddHugging"))
        ],
      ),
    ]);
  }
}
