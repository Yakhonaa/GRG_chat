import 'package:flutter/material.dart';

final ValueNotifier<bool> isEditing = ValueNotifier(false);
final ValueNotifier<int> editingMessageId = ValueNotifier(-1);
ValueNotifier<List> contacts = ValueNotifier([]);
final ValueNotifier<String> currentUsername = ValueNotifier("");
final ValueNotifier<String> currentUserId = ValueNotifier("0");