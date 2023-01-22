import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/services/todo_service.dart';

class AddTodoScreen extends StatefulWidget{
  final Map? todo;
  const AddTodoScreen({
    super.key,
    this.todo,
});
  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if(todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            isEdit? "Edit Todo" : "Add Todo"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: "Title"
            ),
          ),
          SizedBox(height: 20,),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
                hintText: "Description"
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(height: 20,),
          ElevatedButton(onPressed: isEdit ? updateData : submitData, child: Text(
              isEdit ? "Update" : "Submit"))
        ],
      ),
    );
  }
  Future<void> updateData() async {
    final todo = widget.todo;
    if(todo == null) {
      print("You cannot call update without todo data");
      return;
    }
    final id = todo['id'];
    final title = titleController.text;
    final description = descriptionController.text;

    final body = {
      "title": title,
      "description": description,
    };

    final isSuccess = await TodoService.updateTodo(id, body);
    if(isSuccess) {
      showSuccessMessage("Updated!");
    }
    else {
      showErrorMessage("Failed");
    }


  }

  Future<void> submitData() async {

    final title = titleController.text;
    final description = descriptionController.text;

    final body = {
      "title": title,
      "description": description,
    };

    final isSuccess = await TodoService.addTodo(body);
    if(isSuccess) {
      titleController.text="";
      descriptionController.text="";
      showSuccessMessage("Success");
    }
    else {
      showErrorMessage("Failed");
    }

  }
  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  void showErrorMessage(String message) {
    final snackBar = SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}