import 'package:flutter/material.dart';
import 'package:grabbit/pages/chat_list_screen.dart';
import 'package:grabbit/pages/user/home_page.dart';
import 'package:grabbit/pages/user/my_requests_screen.dart';
import 'package:grabbit/pages/user/user_profile_page.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({super.key});

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  int _currentIndex = 0;

  //List of screens
  final List<Widget> _screens = [
    HomePage(),
    MyRequestsScreen(),
    ChatListScreen(),
    UserProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
    );
  }
}
