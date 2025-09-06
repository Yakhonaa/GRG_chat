import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/messages_class.dart';
import 'package:flutter_application_1/widgets/contact_display_widget.dart';
import 'package:flutter_application_1/widgets/message_screen.dart';

class ChatPage extends StatefulWidget {
  final String contactUserName;
  final String chatID;
  final String senderID;
  const ChatPage({
    super.key,
    required this.contactUserName,
    required this.chatID,
    required this.senderID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController controllerMessage = TextEditingController();
  List<Message> messageList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ContactDisplayWidget(
            contactUserName: widget.contactUserName,
            chatID: widget.chatID,
          ),

          // This Container holds your TextField and is now at the bottom.
          Expanded(
            child: MessageScreen(
              senderID: widget.senderID,
              chatID: widget.chatID,
            ),
          ),
        ],
      ),
    );
  }
}
