import 'package:flutter/material.dart';
import 'package:flutter_application_1/back/controller.dart';
import 'package:flutter_application_1/data/notifiers.dart';
import 'package:flutter_application_1/pages/chat_page.dart';
import 'package:flutter_application_1/widgets/message_menu.dart';
import 'package:flutter_application_1/widgets/search.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => ContactPageState();
}

class ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: contacts,
        builder: (context, value, child) {
          print(contacts.value);
          return Column(
            children: [
              MySearchBar(),
              if (contacts.value.length == 1)
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text("Your chats will appear here"),
                  ),
                ),
              if (contacts.value.length > 1)
                Expanded(
                  child: ListView.builder(
                    itemCount: contacts.value.length - 1,
                    itemBuilder: (context, index) {
                      index++;
                      final contact_name = contacts.value.elementAt(index);
                      return GestureDetector(
                        onSecondaryTapDown: (details) {
                          showDeleteMenu(context, details, contact_name);
                        },
                        child: GestureDetector(
                          onTap: () {
                            goToChat(contact_name);
                          },
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 25, 30, 40),
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                width: 2,
                                color: Color.fromARGB(255, 90, 90, 90),
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Text(
                                  contact_name,
                                  style: TextStyle(fontSize: 26),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void goToChat(contact_name) async {
    String chatID = await getChatId(contact_name);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ChatPage(
            contactUserName: contact_name,
            senderID: currentUsername.value,
            chatID: chatID,
          );
        },
      ),
    );
  }

  void getGetChatId(contact_name) async {
    String chatID = await getChatId(contact_name);
    print(chatID);
  }
}
