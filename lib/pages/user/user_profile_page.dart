import 'package:flutter/material.dart';
import 'package:grabbit/pages/Shop/shop_dashboard_page.dart';
import 'package:grabbit/util/my_account_card.dart';
import 'package:grabbit/util/profile_card_container.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        // leading: IconButton(
        //     onPressed: () => Navigator.pop(context),
        //     icon: Icon(
        //       Icons.chevron_left,
        //       color: Colors.white,
        //     )),
        toolbarHeight: 70,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 16,
                ),
                Text(
                  "My Profile",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
                SizedBox(
                  width: 3,
                ),
              ],
            ),
            SizedBox(
              height: 3,
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff009689), Color(0xff0092B8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight)),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ProfileCardContainer(),
            SizedBox(
              height: 28,
            ),
            Expanded(
              child: ListView(
                children: [
                  Text(
                    "Account",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff6A7282),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(127, 229, 231, 235),
                          offset: Offset(0, 10),
                          blurRadius: 15,
                          spreadRadius: -3,
                        ),
                        BoxShadow(
                          color: Color.fromARGB(127, 229, 231, 235),
                          offset: Offset(0, 4),
                          blurRadius: 6,
                          spreadRadius: -4,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        MyAccountCard(
                          iconName: Icons.person_outline,
                          title: "Edit Profile",
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          color: Color(0xffF3F4F6),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Stack(
                          children: [
                            MyAccountCard(
                              iconName: Icons.location_on_outlined,
                              title: "Saved Addresses",
                            ),
                            Positioned(
                              top: 4,
                              right: 24,
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xff00B8DB),
                                      Color(0xff009689),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Text(
                                  "3",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          color: Color(0xffF3F4F6),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        MyAccountCard(
                          iconName: Icons.star_border_rounded,
                          title: "My Reviews",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff6A7282),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(127, 229, 231, 235),
                          offset: Offset(0, 10),
                          blurRadius: 15,
                          spreadRadius: -3,
                        ),
                        BoxShadow(
                          color: Color.fromARGB(127, 229, 231, 235),
                          offset: Offset(0, 4),
                          blurRadius: 6,
                          spreadRadius: -4,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        MyAccountCard(
                          iconName: Icons.notifications_outlined,
                          title: "Notifications",
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          color: Color(0xffF3F4F6),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        MyAccountCard(
                          iconName: Icons.settings_outlined,
                          title: "Preferences",
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Support",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff6A7282),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(127, 229, 231, 235),
                          offset: Offset(0, 10),
                          blurRadius: 15,
                          spreadRadius: -3,
                        ),
                        BoxShadow(
                          color: Color.fromARGB(127, 229, 231, 235),
                          offset: Offset(0, 4),
                          blurRadius: 6,
                          spreadRadius: -4,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        MyAccountCard(
                          iconName: Icons.help_outline,
                          title: "Help & Support",
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          color: Color(0xffF3F4F6),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        MyAccountCard(
                          iconName: Icons.info_outline,
                          title: "Terms & Conditions",
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  GestureDetector(
                    onDoubleTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShopDashboardPage(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Color(0xffFFE2E2),
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(150, 229, 231, 235),
                              offset: Offset(0, 10),
                              blurRadius: 15,
                              spreadRadius: -3,
                            ),
                            BoxShadow(
                              color: Color.fromARGB(150, 229, 231, 235),
                              offset: Offset(0, 4),
                              blurRadius: 6,
                              spreadRadius: -4,
                            )
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            size: 20,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            "Log Out",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  Text(
                    "Grabbit v1.0.0",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff99A1AF),
                    ),
                  ),
                  Text(
                    "Member since Nov 2025",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff99A1AF),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
