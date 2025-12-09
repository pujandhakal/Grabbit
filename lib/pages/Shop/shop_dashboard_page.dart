import 'package:flutter/material.dart';
import 'package:grabbit/pages/user/home_page.dart';
import 'package:grabbit/util/Shop/customer_request_card.dart';
import 'package:grabbit/util/Shop/filter_and_sort_card.dart';
import 'package:grabbit/util/Shop/gradient_icon.dart';
import 'package:grabbit/util/Shop/shop_dashboard_card.dart';

class ShopDashboardPage extends StatefulWidget {
  const ShopDashboardPage({super.key});

  @override
  State<ShopDashboardPage> createState() => _ShopDashboardPageState();
}

class _ShopDashboardPageState extends State<ShopDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        toolbarHeight: 70,
        flexibleSpace: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.25),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2),
            )
          ]),
        ),
        actions: [
          Icon(
            Icons.notifications_outlined,
            size: 24,
          ),
          SizedBox(
            width: 8,
          ),
          GradientIconCard(
            iconSize: 16,
            padding: 6,
            radius: 10,
            icon: Icons.person_2_outlined,
            gradientColors: [
              Color(0xffAD46FF),
              Color(0xffE60076),
            ],
          ),
          Icon(
            Icons.keyboard_arrow_down,
            size: 18,
          ),
          SizedBox(
            width: 14,
          )
        ],
        title: Row(
          children: [
            GradientIconCard(
              padding: 12,
              iconSize: 24,
              icon: Icons.shop_2_outlined,
              gradientColors: [
                Color(0xff00BBA7),
                Color(0xff0092B8),
              ],
            ),
            SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Kathmandu Electronics",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text(
                  "Connect with customers near you",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xff6A7282),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Stack(children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GradientIconCard(
                    icon: Icons.chat_bubble_outline,
                    gradientColors: [Color(0xff2B7FFF), Color(0xff4F39F6)],
                    padding: 12,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Inbox",
                    style: TextStyle(color: Color(0xff4A5565), fontSize: 12),
                  ),
                ],
              ),
              Positioned(
                left: 26,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Text(
                    "7",
                    style: TextStyle(color: Colors.white, fontSize: 8),
                  ),
                ),
              ),
            ]),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GradientIconCard(
                  icon: Icons.shop_2_outlined,
                  gradientColors: [Color(0xff00BBA7), Color(0xff0092B8)],
                  padding: 12,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "Shop Profile",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xff4A5565),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GradientIconCard(
                  icon: Icons.history,
                  gradientColors: [Color(0xffAD46FF), Color(0xffE60076)],
                  padding: 12,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "History",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xff4A5565),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GradientIconCard(
                  icon: Icons.help_outline,
                  gradientColors: [Color(0xffFE9A00), Color(0xffF54900)],
                  padding: 12,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "Support",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xff4A5565),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Wrap(
                children: [
                  ShopDashboardCard(
                    topRightText: "+3 today",
                    cardName: "New Requests",
                    number: "12",
                    color: Color(0xffEDFEFE),
                    iconName: Icons.timer_outlined,
                    gradients: [Color(0xff00BBA7), Color(0xff0092B8)],
                  ),
                  ShopDashboardCard(
                    topRightText: "+5 today",
                    cardName: "Responses Sent",
                    number: "28",
                    color: Color(0xffEEF3FF),
                    iconName: Icons.send_outlined,
                    gradients: [Color(0xff2B7FFF), Color(0xff4F39F6)],
                  ),
                  ShopDashboardCard(
                    topRightText: "2 urgent",
                    cardName: "Pending Convos",
                    number: "7",
                    color: Color(0xffFCF4FB),
                    iconName: Icons.chat_outlined,
                    gradients: [Color(0xffAD46FF), Color(0xffE60076)],
                  ),
                  ShopDashboardCard(
                    topRightText: "12 reviews",
                    cardName: "Shop Rating",
                    number: "4.8",
                    color: Color(0xffFFF8EC),
                    iconName: Icons.star_outline,
                    gradients: [Color(0xffFE9A00), Color(0xffF54900)],
                  ),
                ],
              ),

              SizedBox(
                height: 16,
              ),

              //Filter and Sort card
              FilterAndSortCard(),
              SizedBox(
                height: 16,
              ),

              //customer request card
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Requests Near You",
                    style: TextStyle(fontSize: 20),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "See all",
                      style: TextStyle(color: Color(0xff00B5A9)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              CustomerRequestCard(
                title: "Looking for Red Hoodie",
                isNew: true,
                personName: "Rajesh K.",
                description:
                    "Need a red hoodie, size L, preferably cotton material. Looking for good quality.",
                distance: "350m",
                time: "10 minutes",
                money: "2000-3000",
              ),
              SizedBox(
                height: 12,
              ),
              CustomerRequestCard(
                title: "iPhone 14 Pro Case",
                isNew: true,
                isUrgent: true,
                personName: "Priya S.",
                description:
                    "Looking for a durable phone case for iPhone 14 Pro, preferably with drop protection.",
                distance: "1.2km",
                time: "25 minutes",
                money: "1500",
              ),
              SizedBox(
                height: 12,
              ),
              CustomerRequestCard(
                title: "2kg Basmati Rice",
                personName: "Amit P.",
                description:
                    "Need good quality basmati rice, 2kg pack. Prefer India Gate or similar brand.",
                distance: "500m",
                time: "3 hour",
                money: "800-1000",
              ),
              SizedBox(
                height: 12,
              ),
              CustomerRequestCard(
                title: "Wireless Headphones",
                isUrgent: true,
                personName: "Sneha M.",
                description:
                    "Looking for wireless headphones with good battery life. Budget friendly options preferred.",
                distance: "800m",
                time: "1.5 hour",
                money: "3000-5000",
              ),
              SizedBox(
                height: 16,
              ),

              //remove this btn
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Text("Go to user Home Screen"),
              ),

              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
