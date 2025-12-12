import 'package:flutter/material.dart';
import 'package:grabbit/util/Shop/gradient_icon.dart';
import 'package:grabbit/util/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: 70,
        shadowColor: Colors.grey.withValues(
          alpha: 0.25,
        ),
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.chevron_left,
            size: 20,
          ),
        ),
        actions: [
          Icon(
            Icons.more_vert,
            size: 20,
          ),
          SizedBox(
            width: 22,
          ),
        ],
        title: Row(
          children: [
            Stack(
              children: [
                GradientIconCard(
                  icon: Icons.shop,
                  gradientColors: [Color(0xff009689), Color(0xff0092B8)],
                  padding: 12,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tech Haven",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "Active now",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 24, left: 16, right: 16, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                  color: Color(0xffF9FAFB),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.25),
                      offset: Offset(0, 1),
                      blurRadius: 3,
                    ),
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.25),
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      spreadRadius: -1,
                    ),
                  ]),
              child: Icon(
                Icons.attach_file_outlined,
                color: Color(0xff4A5565),
                size: 20,
              ),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.emoji_emotions_outlined,
                    color: Color(0xff6A7282),
                  ),
                  hint: Text(
                    "Type a message...",
                    style: TextStyle(
                      color: Color(0xff99A1AF),
                    ),
                  ),
                  filled: true,
                  fillColor: Color(0xffF9FAFB),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Color(0xffE5E7EB),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Color(0xff009F90),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                color: Color(0xffD1D5DC),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.send_outlined,
                color: Color(0xff99A1AF),
                size: 20,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Color(0xffD1D5DC),
                                Colors.transparent,
                              ],
                              stops: [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Color(0xffE5E7EB),
                          ),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Text(
                          "Today",
                          style: TextStyle(
                            color: Color(0xff6A7282),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Color(0xffD1D5DC),
                                Colors.transparent,
                              ],
                              stops: [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ChatBubble(
                    isSent: true,
                    message:
                        "Hi! I saw your response to my request for a red hoodie.",
                  ),
                  ChatBubble(
                    isSent: false,
                    message:
                        "Hello! Yes, we have the red hoodie in size L available. It's premium cotton material and brand new.",
                  ),
                  ChatBubble(
                    isSent: true,
                    message: "Great! Can you send me a picture?",
                  ),
                  ChatBubble(
                    isSent: false,
                    message: "Here it is! This is our premium quality hoodie.",
                  ),
                  ChatBubble(
                    isSent: true,
                    message: "Looks perfect! What's your best price?",
                  ),
                  ChatBubble(
                    isSent: false,
                    message:
                        "I can offer you a special price. Regular price Rs. 2,500 - Special discount for you!",
                  ),
                  ChatBubble(
                    isSent: true,
                    message: "That's a great deal! When can I pick it up?",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
