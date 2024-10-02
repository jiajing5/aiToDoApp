import 'package:flutter/material.dart';
import 'package:todoapp/pages/addTodo.dart';
import 'package:todoapp/utils/colorSetting.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/itemData.dart';
import 'package:todoapp/services/httpService.dart';
import 'package:todoapp/pages/aiChatPage.dart';
import 'package:todoapp/pages/apiKeyPage.dart';

class todoList extends StatefulWidget {
  const todoList({super.key});

  @override
  State<todoList> createState() => _todoListState();
}

class _todoListState extends State<todoList> with SingleTickerProviderStateMixin{
  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController!.addListener(() {
      setState(() {});
    });
/////GET
    HttpService().getTodos().then((data){
      context.read<Item>().sendData(data);
      print("Data received: $data");
    }).catchError((error){
      print("Error fetching data: $error");
    });
    
    // data2 = Provider.of<Item>(context);
    print("data2${context.read<Item>().data}");
    // print("data長度${data.length}");
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

/////錯誤處理
  void createTodo(Map result)async{
    var service = HttpService();
    try{
      await service.postTodo({"title":result["title"], "description":result["description"], "todoValue": false});
    }
    catch(e){
      print(e);
    }
  }
  void putTodo(Item data)async{
    var service = HttpService();
    try{
      await service.updateTodo(data);
    }
    catch(e){
      print(e);
    }
  }
  void delTodo(String title)async{
    var service = HttpService();
    try{
      await service.deleteTodo(title);
    }
    catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
  final data = context.watch<Item>().data;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Todo APP'),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                icon: Icon(Icons.key),
                text: "API Key",
              ),
              Tab(
                icon: Icon(Icons.computer),
                text: "AI",
              ),
              Tab(
                icon: Icon(Icons.book),
                text: "未完成",
              ),
              Tab(
                icon: Icon(Icons.bookmark),
                text: "已完成",
              )
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Apikeypage(),
            aiChatPage(),
            ListView(
              children: [
                ...data.entries.map((e) {
                  if (e.value.todoValue == false) {
                    return _todoListTile(e.value.title!, e.value.description!,
                        e.value.todoValue!);
                  }
                  else {
                    return Card();
                  }
                })
              ],
            ),
            ListView(
              children: [
                ...data.entries.map((e) {
                  if (e.value.todoValue == true) {
                    return _todoListTile(e.value.title!, e.value.description!,
                        e.value.todoValue!);
                  }
                  else {
                    return Card();
                  }
                })
              ],
            ),
          ],
        ),
        floatingActionButton: _tabController!.index == 2
        ?FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onPressed: () async {
              final result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return AddTodo();
              }));
            // print(result);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(result!=null ? result['title']:"Data Build"),
            ));
            
            if (result != null && result['title'] != ''){
              final addValue = {
                "${result["title"]}": Item(title:result["title"], description:result["description"], todoValue: false)
              };
              context.read<Item>().addData(addValue);
///////POST
              createTodo(result);

              print(context.read<Item>().data);
            }
          },
          child: Icon(Icons.add)): null
    ));
  }

  // List<Card> _todoList(Map<String, Item> data) => data.entries.map((e) {
  //       // print("e: $e");
  //       // print("e.value: ${e.value}");
  //       // print("e.value['title']: ${e.value['title']}");
  //       return _todoListTile(
  //           e.value['title'], e.value['description'], e.value['todoValue']);
  //     }).toList();

  Card _todoListTile(String title, String description, bool todoValue) => Card(
          child: ListTile(
        leading: Checkbox(
            onChanged: (bool? value) {
               final data = context.read<Item>().data;
               data[title] = Item(title:title, description: description, todoValue:value);
               context.read<Item>().updateData(data);
               print(context.read<Item>().data[title]!.todoValue);

    //////PUT    HttpService().updateTodo(data[title]!);
           
               putTodo(data[title]!);
            },
            value: todoValue),
        title: Text(title),
        subtitle: Text(description),
        trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              final data = context.read<Item>().data;
              print(data[title]);
              context.read<Item>().deleteData(title);

  ////////DELETE  HttpService().deleteTodo(title);
              delTodo(title);
            }),
      ));
}