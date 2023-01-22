import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/screens/add_todo.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/services/todo_service.dart';

import '../utils/snackbar_helper.dart';

class TodoListScreen extends StatefulWidget {
  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  bool isLoading = true;
  List items = [];
  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator(),),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(child: Text("No data to show"),),
            child: ListView.builder(
                itemCount: items.length,
                padding: EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  final id = item['id'];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text("${index+1}"),),
                      title: Text(item['title']),
                      subtitle: Text(item['description']),
                      trailing: PopupMenuButton(
                        onSelected: (value){
                          if(value == "edit"){
                            navigateToEditScreen(item);
                          }
                          else if(value == "delete"){
                            deleteById(id);
                          }
                        },
                        itemBuilder: (context){
                          return [
                            PopupMenuItem(
                              child: Text("Edit"),
                              value: "edit",
                            ),
                            PopupMenuItem(
                              child: Text("Delete"),
                              value: "delete",
                            ),
                          ];
                        },
                      ),
              ),
                  );
            }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: navigateToAddScreen, label: Icon(Icons.add)),
    );
  }

  Future<void> navigateToEditScreen(Map item) async {
    final route = MaterialPageRoute(builder: (context) => AddTodoScreen(todo: item,));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();

  }

  Future<void> navigateToAddScreen() async {
    final route = MaterialPageRoute(builder: (context) => AddTodoScreen());
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deleteById(int id) async {
    final isSuccess = await TodoService.deleteById(id);
    if(isSuccess){
      final filtered = items.where((element) => element['id'] != id).toList();
      setState(() {
        items = filtered;
      });
    }
    else{
      showErrorMessage(context, message: "Unable to delete!");
    }
  }

  Future<void> fetchTodo() async {
    final response = await TodoService.fetchTodos();
    if(response != null) {
      setState(() {
        items = response;
      });
    }
    else {
      showErrorMessage(context, message: "Something went wrong");
    }
    setState(() {
      isLoading = false;
    });
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


}