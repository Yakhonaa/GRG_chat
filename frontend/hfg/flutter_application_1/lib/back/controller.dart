import 'dart:convert';

import 'package:flutter_application_1/data/messages_class.dart';
import 'package:flutter_application_1/data/notifiers.dart';
import 'package:http/http.dart' as http;

Future<String> register(username, password) async {
  print([username, password]);
  final uri = Uri.parse(
    'http://localhost:8080/register',
  ).replace(queryParameters: {'username': username, 'password': password});
  final response = await http.get(uri);
  final String dbResponse = response.body;
  return dbResponse;
}

Future<String> addContact(newContactName) async {
  final uri = Uri.parse('http://localhost:8080/addNewContact').replace(
    queryParameters: {
      'username': currentUsername.value,
      'contactName': newContactName,
    },
  );
  final response = await http.get(uri);
  final String dbResponse = response.body;
  return dbResponse;
}

Future<String> getUserId(username) async {
  final uri = Uri.parse('http://localhost:8080/getUserId').replace(
    queryParameters: {'username': username}
  );
  final response = await http.get(uri);
  final String dbResponse = response.body;
  return dbResponse;
}


Future<String> getChatId(user2) async {
  final uri = Uri.parse(
    'http://localhost:8080/getChatId',
  ).replace(queryParameters: {'user1': currentUsername.value, 'user2': user2});
  final response = await http.get(uri);
  final String dbResponse = response.body;
  return dbResponse;
}

Future<String> searchContact(contactName) async {
  final uri = Uri.parse(
    'http://localhost:8080/searchForContact',
  ).replace(queryParameters: {'username': contactName});
  final response = await http.get(uri);
  final String dbResponse = response.body;
  return dbResponse;
}

Future<List<dynamic>> login(username, password) async {
  currentUsername.value = username;
  print([username, password]);
  final uri = Uri.parse(
    'http://localhost:8080/login',
  ).replace(queryParameters: {'username': username, 'password': password});
  final response = await http.get(uri);
  final List<dynamic> jsonResponse = json.decode(response.body);
  print(jsonResponse);
  return jsonResponse;
}

Future<List<Message>> getMessages(chatID) async {
  // Correctly format the URI with query parameters
  final uri = Uri.parse(
    'http://localhost:8080/getHistory',
  ).replace(queryParameters: {'chatIdParam': chatID});

  // Use http.get() instead of http.post()
  try {
    final response = await http.get(uri);
    final List<dynamic> jsonResponse = json.decode(response.body);

    // Map each item in the list to a Message object using the factory constructor
    return jsonResponse.map((json) => Message.fromJson(json)).toList();
  } catch (error) {
    throw Exception('Failed to connect to the server: $error');
  }
  // Return the response body.
  // Make sure to add error handling as discussed in previous answers.
}

clearChat(chatID) async {
  final uri = Uri.parse(
    'http://localhost:8080/clearChat',
  ).replace(queryParameters: {'chatIdParam': chatID});
  try {
    final response = await http.delete(uri);
    return response.body;
  } catch (error) {
    throw Exception('Failed to delete $error');
  }
}
