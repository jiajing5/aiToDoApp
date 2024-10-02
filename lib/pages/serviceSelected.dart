import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/services/geminiService.dart';
import 'package:todoapp/services/huggingService.dart';
import 'package:todoapp/services/localAIService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/model/aiData.dart';

class CustomServiceSelect extends StatefulWidget {
  CustomServiceSelect({super.key});

  @override
  State<CustomServiceSelect> createState() => _CustomServiceSelectState();
}

class _CustomServiceSelectState extends State<CustomServiceSelect> {
  final geminiService = Geminiservice();
  final huggingService = Huggingservice();
  final localAIService = LocalAIService();

  Map<String, dynamic> services = {};
  @override
  void initState() {
    services = {
      'Gemini': geminiService,
      'Hugging Face': huggingService,
      'Local AI': localAIService
    };
  }

  @override
  Widget build(BuildContext context) {
    final aiService = Provider.of<ChatItems>(context);
    return PopupMenuButton<String>(
      itemBuilder: (context) => buildItems(),
      offset: const Offset(0, 50),
      elevation: 1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
          topRight: Radius.circular(5),
          bottomLeft: Radius.circular(5),
        ),
      ),
      onSelected: (e) {
        switch (e) {
          case 'Gemini':
           aiService.selectedService(0);
          case 'Hugging Face':
            aiService.selectedService(1);
          case 'Local AI':
            aiService.selectedService(2);
        }
      },
    );
  }

  List<PopupMenuItem<String>> buildItems() {
    return services.keys
        .toList()
        .map((e) => PopupMenuItem<String>(
            value: e,
            child: Wrap(
              spacing: 10,
              children: <Widget>[
                Text(e),
              ],
            )))
        .toList();
  }
}
