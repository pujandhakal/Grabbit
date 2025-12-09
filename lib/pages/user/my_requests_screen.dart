import 'package:flutter/material.dart';
import 'package:grabbit/pages/user/post_request_page.dart';
import 'package:grabbit/util/my_requests_card.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.grey.withValues(
          alpha: 0.25,
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          "My Requests",
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          Icon(Icons.filter_list),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff009689),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostRequestPage(),
            ),
          );
        },
        child: Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: ListView(
          children: [
            MyRequestsCard(
              imageURL: "https://picsum.photos/250",
              isActive: true,
            ),
            MyRequestsCard(
              imageURL: "https://picsum.photos/251",
              isActive: true,
            ),
            MyRequestsCard(
              imageURL: "https://picsum.photos/252",
              isActive: false,
              isCompleted: true,
            ),
            MyRequestsCard(
              imageURL: "https://picsum.photos/253",
              isActive: false,
              isPending: true,
            ),
            MyRequestsCard(
              imageURL: "https://picsum.photos/254",
              isActive: false,
              isExpired: true,
            ),
          ],
        ),
      ),
    );
  }
}
