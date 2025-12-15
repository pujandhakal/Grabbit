import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grabbit/pages/chat_list_screen.dart';
import 'package:grabbit/pages/user/home_page.dart';
import 'package:grabbit/pages/user/my_requests_screen.dart';
import 'package:grabbit/pages/user/post_request_page.dart';
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
      bottomNavigationBar: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(0, Icons.home_outlined, "Home"),
                _buildNavItem(1, Icons.description_outlined, "Requests",
                    isSvg: true),
                Spacer(),
                _buildNavItem(2, Icons.chat_bubble_outline, "Chats"),
                _buildNavItem(3, Icons.person_outline, "Profile"),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: MediaQuery.of(context).size.width / 2 - 20,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3))
                ],
                gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 8, 189, 171),
                  Color.fromARGB(255, 1, 110, 100),
                  // Color(0xff009689),
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PostRequestPage()));
                  },
                  child: Icon(
                    Icons.add,
                    size: 34,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label,
      {bool isSvg = false}) {
    bool isActive = _currentIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(28),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 22, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isSvg
                ? SvgPicture.asset(
                    "assets/images/productDesc_icon.svg",
                    colorFilter: ColorFilter.mode(
                      isActive ? Color(0xff00BBA7) : Color(0xff99A1AF),
                      BlendMode.srcIn,
                    ),
                  )
                : Icon(
                    icon,
                    color: isActive ? Color(0xff00BBA7) : Color(0xff99A1AF),
                    size: 24,
                  ),
            SizedBox(
              height: 2,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? Color(0xff00BBA7) : Color(0xff99A1AF),
              ),
            )
          ],
        ),
      ),
    );
  }
}
