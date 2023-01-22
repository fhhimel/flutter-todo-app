
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_app/screens/todo_list.dart';


void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  //
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Todo",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: TodoListScreen(),
    );
  }
}