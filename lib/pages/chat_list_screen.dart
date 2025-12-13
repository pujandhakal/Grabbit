import 'package:flutter/material.dart';
import 'package:grabbit/pages/chat_screen.dart';
import 'package:grabbit/util/chat_tile.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 144,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 1,
        shadowColor: Colors.grey.withValues(alpha: 0.25),
        flexibleSpace: SafeArea(
          child: Padding(
            padding: EdgeInsetsGeometry.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Chats",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.search_outlined,
                          color: Color(0xff4A5565),
                          size: 20,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Icon(
                          Icons.more_vert,
                          color: Color(0xff4A5565),
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search_outlined,
                      size: 20,
                      color: Color(0xff4A5565),
                    ),
                    hint: Text(
                      "Search chats...",
                      style: TextStyle(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Color(0xff009689),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(),
                  ),
                );
              },
              child: ChatTile(
                shopName: 'Tech Haven',
                message: 'We have your requested laptop in stock!',
                timeStamp: '10:45 AM',
                imageLink: 'https://picsum.photos/100',
              ),
            ),
            ChatTile(
              shopName: "StyleHub Boutique",
              message: "Thank you for your purchase! 😊",
              timeStamp: "Yesterday",
              imageLink: 'https://picsum.photos/101',
              isUnread: false,
            ),
            ChatTile(
              shopName: "Book Nook",
              message: "We found the book you were looking for",
              timeStamp: "Yesterday",
              imageLink: 'https://picsum.photos/101',
            )
          ],
        ),
      ),
    );
  }
}
