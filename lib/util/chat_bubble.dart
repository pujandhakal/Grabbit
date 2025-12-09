import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  const ChatBubble({super.key});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: EdgeInsets.only(bottom: 22),
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
          "Hi! I saw your response to my req for a red hoodie.",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
