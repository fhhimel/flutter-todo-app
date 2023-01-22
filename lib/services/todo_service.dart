import 'dart:convert';

import 'package:http/http.dart' as http;

class TodoService {
  static Future<bool> deleteById(int id)async{
    final url = "http://192.168.0.105:5000/api/todo/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    return response.statusCode == 200;
  }
  static Future<List?> fetchTodos()async{
    final url = "http://192.168.0.105:5000/api/todo";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if(response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final result = json as List;
      return result;
    }
    else {
      return null;
    }
  }

  static Future<bool> updateTodo(int id, Map body) async {
    final url = "http://192.168.0.105:5000/api/todo/$id";
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {
        "Content-Type": "application/json"
      },
    );
    return response.statusCode == 200;
  }
  static Future<bool> addTodo(Map body) async {
    final url = "http://192.168.0.105:5000/api/todo";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {
        "Content-Type": "application/json"
      },
    );
    return response.statusCode == 200;
  }

}