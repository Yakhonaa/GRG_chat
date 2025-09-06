import 'package:flutter/material.dart';
import 'package:flutter_application_1/back/controller.dart';
import 'package:flutter_application_1/data/notifiers.dart';
import 'package:flutter_application_1/pages/registration_page.dart';

class MySearchBar extends StatefulWidget {
  const MySearchBar({super.key});

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      color: Color.fromARGB(255, 40, 80, 80),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              goToMain();
            },
            icon: Icon(Icons.arrow_back),
          ),
          SizedBox(width: 20),

          Expanded(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search for new contacts...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
          ),
          Container(
            width: 50,
            height: 50,
            child: IconButton(
              onPressed: () async {
                String searchResult = await searchContact(
                  searchController.text,
                );
                if (searchResult != "User does not exist") {
                  if (!contacts.value.contains(searchResult)) {
                    contacts.value = [...contacts.value, searchResult];
                    print("VALUE ADDED");

                    // invoke sql adding
                    String addingResult = await addContact(searchResult);
                    print(addingResult);
                  }
                }
              },
              icon: Icon(Icons.search),
            ),
          ),
        ],
      ),
    );
  }

  void goToMain() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return RegistrationPage();
        },
      ),
    );
  }
}
