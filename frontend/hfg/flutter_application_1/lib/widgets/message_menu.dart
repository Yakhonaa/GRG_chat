// Place this function inside your _MessageScreenState class.
import 'package:flutter/material.dart';
import 'package:flutter_application_1/back/web_controller.dart';
import 'package:flutter_application_1/data/notifiers.dart';

void ShowContextMenu(
  context,
  details,
  stompClient,
  chatID,
  message,
  messageController,
) {
  showMenu<String>(
    context: context,
    // The position where the menu will appear.
    // It's the location of the tap relative to the screen.
    position: RelativeRect.fromLTRB(
      details.globalPosition.dx,
      details.globalPosition.dy,
      details.globalPosition.dx + 1.0,
      details.globalPosition.dy + 1.0,
    ),
    items: <PopupMenuEntry<String>>[
      const PopupMenuItem<String>(value: 'Edit', child: Text('Edit message')),
      const PopupMenuItem<String>(
        value: 'Delete',
        child: Text('Delete message'),
      ),
    ],
  ).then((String? result) {
    if (result != null) {
      // Handle the selected option
      if (result == 'Edit') {
        messageController.text = message.content;
        isEditing.value = true;
        editingMessageId.value = message.id;
        //editMessage(message.content, stompClient);
      } else if (result == 'Delete') {
        deleteMessage(message.id, chatID, stompClient);
      }
    }
  });
}


void showDeleteMenu(
  context,
  details,
  contactName
) {
  showMenu<String>(
    context: context,
    position: RelativeRect.fromLTRB(
      details.globalPosition.dx,
      details.globalPosition.dy,
      details.globalPosition.dx + 1.0,
      details.globalPosition.dy + 1.0,
    ),
    items: <PopupMenuEntry<String>>[
      const PopupMenuItem<String>(value: 'Delete', child: Text('Delete chat')),
    ],
  ).then((String? result) {
    if (result != null) {
      // Handle the selected option
      if (result == 'Delete') {
  int indexToDelete = contacts.value.indexOf(contactName);
  print(indexToDelete);

  // Create a NEW list, not the same reference
  final newList = List.from(contacts.value);
  newList.removeAt(indexToDelete);

  contacts.value = newList; // now notifier will trigger
  print(newList);
}
    }
  });
}