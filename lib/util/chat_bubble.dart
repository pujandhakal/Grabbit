import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  final bool isSent;
  final String message;
  const ChatBubble({
    super.key,
    required this.isSent,
    required this.message,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    if (widget.isSent == true) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(4),
                bottomLeft: Radius.circular(20),
              ),
              gradient: LinearGradient(
                colors: [
                  Color(0xff00BBA7),
                  Color(0xff009689),
                  Color(0xff0092B8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(130, 150, 247, 228),
                  blurRadius: 15,
                  spreadRadius: -3,
                  offset: Offset(0, 10),
                ),
                BoxShadow(
                  color: Color.fromARGB(130, 150, 247, 228),
                  blurRadius: 6,
                  spreadRadius: -4,
                  offset: Offset(0, 4),
                ),
              ]),
          child: Text(
            widget.message,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.only(bottom: 12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(4),
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(30, 0, 0, 0),
                offset: Offset(0, 4),
                spreadRadius: -1,
                blurRadius: 6,
              ),
              BoxShadow(
                color: Color.fromARGB(30, 0, 0, 0),
                offset: Offset(0, 2),
                spreadRadius: -2,
                blurRadius: 4,
              ),
            ],
          ),
          child: Text(
            widget.message,
            style: TextStyle(),
          ),
        ),
      );
    }
  }
}
