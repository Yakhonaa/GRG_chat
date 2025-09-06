import 'dart:convert';

import 'package:stomp_dart_client/stomp_dart_client.dart';

void sendMessage(
  String messageContent,
  String sentAt,
  String senderID,
  String chatID,
  StompClient stompClient,
) {
  if (stompClient.connected == true) {
    stompClient.send(
      destination: '/app/chat/${chatID}',
      body: json.encode({
        'content': messageContent,
        'senderId': senderID,
        'chatId': int.parse(chatID),
        'sentAt': sentAt,
      }),
    );
  } else {
    print("Disconnected");
  }
}

void deleteMessage(int messageID, String chatID, StompClient stompClient) {
  if (stompClient.connected == true) {
    stompClient.send(
      destination: '/app/chat/${chatID}/delete',
      body: messageID.toString(),
    );
  } else {
    print("Disconnected");
  }
}

void editMessage(
  int messageId,
  String newText,
  String chatID,
  StompClient stompClient,
) {
  print([messageId, newText]);
  if (newText != "") {
    if (stompClient.connected == true) {
      stompClient.send(
        destination: '/app/chat/${chatID}/edit',
        body: json.encode({'messageId': messageId, 'newText': newText}),
      );
    } else {
      print("Disconnected");
    }
  }
}
