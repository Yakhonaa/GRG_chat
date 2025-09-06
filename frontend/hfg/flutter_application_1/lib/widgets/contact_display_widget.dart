import 'package:flutter/material.dart';
import 'package:flutter_application_1/back/controller.dart';
import 'package:flutter_application_1/pages/contact_page.dart';

class ContactDisplayWidget extends StatefulWidget {
  final String contactUserName;
  final String chatID;
  const ContactDisplayWidget({
    super.key,
    required this.contactUserName,
    required this.chatID,
  });

  @override
  State<ContactDisplayWidget> createState() => _ContactDisplayWidgetState();
}

class _ContactDisplayWidgetState extends State<ContactDisplayWidget> {
  String? menuItem = 'e1';
  bool? deleteConfirm = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      color: Color.fromARGB(255, 40, 80, 80),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              goToContactPage();
            },
            icon: Icon(Icons.arrow_back),
          ),
          SizedBox(width: 60),
          SizedBox(
            width: 100,
            height: 50,
            child: Text(
              widget.contactUserName,
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: PopupMenuButton<String>(
              onSelected: (String result) {
                if (result == 'Clear') {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Confirmation'),
                        content: Text(
                          'Are you sure you want to delete this Chat?',
                        ),
                        actions: [
                          FilledButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll<Color>(
                                Colors.red,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              clearChat(widget.chatID);
                            },
                            child: Text(
                              'Clear',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),

                          FilledButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'Clear',
                  child: Text('Clear chat'),
                ),
              ],
              child: Icon(Icons.more_vert), // The icon itself
            ),
          ),
        ],
      ),
    );
  }

  void goToContactPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ContactPage();
        },
      ),
    );
  }
}
