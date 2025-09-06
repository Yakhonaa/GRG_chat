import 'package:flutter/material.dart';
import 'package:flutter_application_1/back/web_controller.dart';
import 'package:flutter_application_1/data/messages_class.dart';
import 'package:flutter_application_1/data/notifiers.dart';
import 'package:flutter_application_1/data/useful_functions.dart';
import 'package:flutter_application_1/widgets/edit_widget.dart';
import 'package:flutter_application_1/widgets/message_menu.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class InternalChat extends StatefulWidget {
  final String chatID;
  final String senderID;
  final List<Message> messageList;
  final StompClient stompClient;
  final ScrollController scrollController;
  const InternalChat({
    super.key,
    required this.senderID,
    required this.chatID,
    required this.stompClient,
    required this.messageList,
    required this.scrollController,
  });

  @override
  State<InternalChat> createState() => InternalChatState();
}

class InternalChatState extends State<InternalChat> {
  TextEditingController messageController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: widget.scrollController,
            itemCount: widget.messageList.length,
            itemBuilder: (context, index) {
              final message = widget.messageList[index];
              final userCondition = widget.senderID == message.senderId;
              return Row(
                mainAxisAlignment: userCondition
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onSecondaryTapDown: (details) {
                      ShowContextMenu(
                        context,
                        details,
                        widget.stompClient,
                        widget.chatID,
                        message,
                        messageController,
                      );
                    },
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.50,
                      ),
                      margin: EdgeInsets.only(
                        left: userCondition ? 0 : 6,
                        right: userCondition ? 6 : 0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          // SENDER SIDE
                          topLeft: Radius.circular(userCondition ? 15 : 5),
                          bottomLeft: Radius.circular(userCondition ? 15 : 5),
                          // CONTACT SIDE
                          topRight: Radius.circular(userCondition ? 5 : 15),
                          bottomRight: Radius.circular(userCondition ? 5 : 15),
                        ),
                        color: Color.fromARGB(255, index * 3 + 30, index, 60),
                      ),
                      child: Stack(
                        alignment: userCondition
                            ? AlignmentDirectional.centerEnd
                            : AlignmentDirectional.centerStart,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 12,
                              left: 12,
                              right: 35,
                            ),
                            child: Text(
                              message.content,
                              style: TextStyle(fontSize: 20, height: 1.0),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 5,
                            child: Text(
                              message.sentAt,
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        ValueListenableBuilder(
          valueListenable: isEditing,
          builder: (context, value, child) {
            return Column(
              children: [
                if (isEditing.value != false && editingMessageId.value != -1)
                  EditWidget(messageController: messageController),
                Container(
                  padding: EdgeInsets.all(4),
                  color: Color.fromARGB(255, 40, 80, 80),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 9,
                        child: Container(
                          //padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          color: Color.fromARGB(0, 40, 80, 80),
                          constraints: BoxConstraints(maxHeight: 100),
                          child: TextField(
                            maxLines: null,
                            focusNode: focusNode,
                            onSubmitted: (String messageText) {
                              String currentTime = getTime();
                              FocusScope.of(context).requestFocus(focusNode);
                              conditionalFunction(messageText, currentTime);
                            },
                            controller: messageController,
                            decoration: const InputDecoration(
                              hintText: 'Type a message...',
                              filled: true,
                              fillColor: Color.fromARGB(255, 40, 80, 80),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: IconButton(
                          onPressed: () {
                            String messageText = messageController.text;
                            String currentTime = getTime();
                            FocusScope.of(context).requestFocus(focusNode);
                            conditionalFunction(messageText, currentTime);
                          },
                          icon: Icon(Icons.send),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  void conditionalFunction(String messageText, String currentTime) {
    if (isEditing.value != false && editingMessageId.value != -1) {
      print(messageController.text);
      editMessage(
        editingMessageId.value,
        messageText,
        widget.chatID,
        widget.stompClient,
      );
      isEditing.value = false;
      editingMessageId.value = -1;
    } else {
      sendMessage(
        messageText,
        currentTime,
        widget.senderID,
        widget.chatID,
        widget.stompClient,
      );
    }
    messageController.text = '';
  }
}
