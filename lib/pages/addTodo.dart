import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  Map data = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(),
      body:ListView(children: [
        TextField(
          controller:_titleController,
          decoration:InputDecoration(hintText:'Title'),
        ),
        TextField(controller:_descriptionController,
        decoration:InputDecoration(hintText:'description'),),
        ElevatedButton(onPressed: (){
          setState(() {
            data['title'] = _titleController.text;
            data['description'] = _descriptionController.text;
          });
          Navigator.pop(context, data);
        }, child: Text('Add')),
      
      ],)
    );
  }
}