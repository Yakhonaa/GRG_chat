import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_1/back/controller.dart';
import 'package:flutter_application_1/data/messages_class.dart';
import 'package:flutter_application_1/widgets/chat_page.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class MessageScreen extends StatefulWidget {
  final String senderID;
  final String chatID;
  const MessageScreen({
    super.key,
    required this.senderID,
    required this.chatID,
  });

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  TextEditingController controllerMessage = TextEditingController();
  List<Message> messageList = [];
  final FocusNode focusNode = FocusNode();
  final ScrollController scrollController = ScrollController();
  late StompClient stompClient;

  @override
  void initState() {
    super.initState();
    connect();
    print(["isConnected", stompClient.connected]);
    getMessages(widget.chatID).then((messagesList) {
      setState(() {
        messageList = messagesList;
      });
    });
  }

  void _scrollToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        final double maxScrollExtent =
            scrollController.position.maxScrollExtent;
        scrollController.jumpTo(maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InternalChat(
      senderID: widget.senderID,
      chatID: widget.chatID,
      stompClient: stompClient,
      messageList: messageList,
      scrollController: scrollController,
    );
  }

  void connect() {
    stompClient = StompClient(
      config: StompConfig(
        url: 'ws://localhost:8080/ws',
        onConnect: (StompFrame frame) {
          subscribe();
        },

        onWebSocketError: (dynamic error) => print(error.toString()),
      ),
    );
    stompClient.activate();
  }

  void subscribe() {
    stompClient.subscribe(
      destination: '/topic/chat/' + widget.chatID,
      callback: onCallBack,
    );
  }

  void onCallBack(StompFrame frame) {
    final dynamic result = json.decode(frame.body!);
    print("ANSWER ACQUIRED");
    if (result is int) {
      print("we are not in here");
      setState(() {
        messageList.removeWhere((m) => m.id == result);
      });
    } else if (result[0] is int && result[1] is String) {
      int messageInternalIdx = messageList.indexWhere((m) => m.id == result[0]);
      setState(() {
        messageList.elementAt(messageInternalIdx).content = result[1];
      });
    } else {
      print("are we in else?");
      final newMessage = Message.fromJson(result);
      setState(() {
        messageList.add(newMessage);
        _scrollToBottom();
      });
    }
  }
}
