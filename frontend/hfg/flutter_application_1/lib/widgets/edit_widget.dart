import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/notifiers.dart';

class EditWidget extends StatefulWidget {
  final TextEditingController messageController;

  const EditWidget({super.key, required this.messageController});

  @override
  State<EditWidget> createState() => _EditWidgetState();
}

class _EditWidgetState extends State<EditWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 17, 24, 25),
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 9,
            child: SingleChildScrollView(
              child: Align(
                child: Container(
                  margin: EdgeInsets.only(left: 15),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.messageController.text,
                    maxLines: 3, // or remove this to allow multiple lines
                    overflow: TextOverflow.ellipsis,
                  ), // show "..." if too long),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: IconButton(
              onPressed: () {
                isEditing.value = false;
                editingMessageId.value = -1;
                widget.messageController.text = "";
              },
              icon: Icon(Icons.cancel),
            ),
          ),
        ],
      ),
    );
  }
}
