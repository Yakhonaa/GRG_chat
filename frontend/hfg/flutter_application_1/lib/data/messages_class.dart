
class Message {
  int id;
  int chatId;
  String senderId;
  String content;
  String sentAt;

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.sentAt,
  });

  // Factory constructor to create a Message from a JSON map
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as int,
      chatId: json['chatId'] as int,
      senderId: json['senderId'] as String,
      content: json['content'] as String,
      sentAt: json['sentAt'] as String,
    );
  }
}
