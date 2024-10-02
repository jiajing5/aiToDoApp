import 'package:flutter/material.dart';
import 'package:todoapp/model/aiData.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:todoapp/services/geminiService.dart';
import 'package:todoapp/services/huggingService.dart';
import 'package:todoapp/services/localAIService.dart';
import 'package:todoapp/pages/serviceSelected.dart';
import 'package:flutter/services.dart';

class aiChatPage extends StatefulWidget {
  const aiChatPage({super.key});

  @override
  State<aiChatPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<aiChatPage> {
  TextEditingController _textEditingController = TextEditingController(); //建議要配合dispose當widget撤銷時釋放內容
  String _result = '';
  int _selectedIndex = 0;

  // @override
  // void dispose(){
  //   _textEditingController.dispose();
  //   super.dispose();
  // }

  @override
  void initState() {
    super.initState();
    context.read<ChatItems>().fetchChat();
    // _result = context.read<ChatItems>().chats.last;
    // print("26$_result");
  }

  @override
  Widget build(BuildContext context) {
    final aiService = Provider.of<ChatItems>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Stack(children: [
            Markdown(
            data:aiService.chats.last??'',),
            
            Positioned(
            right: 5,
              child: IconButton(onPressed: (){
                Clipboard.setData(ClipboardData(text: aiService.chats.last));
              }, icon: Icon(Icons.copy),)),
            
          ],),
        ),
      // children: [
      //   Flexible(child: Markdown(
      //     data: aiService.chats.last,
      //     // aiService.chats.length == 0? 'Hi': aiService.chats.last
      //   )),
        // Text(aiService.serviceSelected.toString()),
        Row(children: [
          Expanded(child: TextField(controller: _textEditingController,)),
          CustomServiceSelect(),
          ElevatedButton(onPressed: ()async{
            // _result = await Geminiservice().sendRequest(_textEditingController.text);
            // _result = await Huggingservice().sendRequest(_textEditingController.text);
            // if (mounted) { setState((){});} //沒寫內容就會刷新整個畫面

            // context
            //   .read<ChatItems>()
            //   .getGeminiResult(_textEditingController.text);
            
            // _result =  await Huggingservice().sendRequest(_textEditingController.text);
            // print("74$_textEditingController.text");
            // aiService.addChat(_result);
            
            int index = aiService.serviceSelected;
            switch (index) {
              case 0: _result =  await Geminiservice().sendRequest(_textEditingController.text);
            aiService.addChat(_result);
              case 1: _result =  await Huggingservice().sendRequest(_textEditingController.text);
            aiService.addChat(_result);
              case 2: _result =  await LocalAIService().sendRequest(_textEditingController.text);
            aiService.addChat(_result);
            }
            _textEditingController.clear();
          },
          
          
           child: Text('Send')),
        ],)
      ]
    );
  }
}