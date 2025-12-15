import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grabbit/pages/chat_list_screen.dart';
import 'package:grabbit/pages/user/my_requests_screen.dart';
import 'package:grabbit/pages/user/post_request_page.dart';
import 'package:grabbit/pages/user/user_profile_page.dart';
import 'package:grabbit/util/live_request_card.dart';
import 'package:grabbit/util/quick_action_card.dart';
import 'package:grabbit/util/search_bar.dart';
import 'package:grabbit/util/trending_deals_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        title: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //grabbit logo
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Grabbit",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_pin,
                        size: 18,
                        color: Colors.white,
                      ),
                      Text(
                        "Kathmandu, Nepal",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  )
                ],
              ),

              // //user pp
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfilePage(),
                    ),
                  );
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage("https://picsum.photos/200"),
                ),
              ),
            ],
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff00BBA7), Color(0xff009689)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight)),
        ),
      ),

      //Bottom navigation bar

      // bottomNavigationBar: Stack(
      //   children: [
      //     Container(
      //       padding: EdgeInsets.symmetric(vertical: 14),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         children: [
      //           InkWell(
      //             onTap: () {},
      //             borderRadius: BorderRadius.circular(28),
      //             child: Container(
      //               padding: EdgeInsets.symmetric(horizontal: 22, vertical: 4),
      //               child: Column(
      //                 mainAxisSize: MainAxisSize.min,
      //                 children: [
      //                   Icon(
      //                     Icons.home_outlined,
      //                     color: Color(0xff00BBA7),
      //                     size: 24,
      //                   ),
      //                   SizedBox(
      //                     height: 2,
      //                   ),
      //                   Text(
      //                     "Home",
      //                     style: TextStyle(
      //                       fontSize: 12,
      //                       color: Color(0xff00BBA7),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //           InkWell(
      //             onTap: () {
      //               Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (context) => MyRequestsScreen(),
      //                 ),
      //               );
      //             },
      //             borderRadius: BorderRadius.circular(28),
      //             child: Container(
      //               padding: EdgeInsets.symmetric(horizontal: 22, vertical: 4),
      //               child: Column(
      //                 mainAxisSize: MainAxisSize.min,
      //                 children: [
      //                   SvgPicture.asset(
      //                     "assets/images/productDesc_icon.svg",
      //                     colorFilter: ColorFilter.mode(
      //                         Color(0xff99A1AF), BlendMode.srcIn),
      //                   ),
      //                   SizedBox(
      //                     height: 2,
      //                   ),
      //                   Text(
      //                     "Requests",
      //                     style: TextStyle(
      //                       fontSize: 12,
      //                       color: Color(0xff99A1AF),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //           Spacer(),
      //           InkWell(
      //             onTap: () {
      //               Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (context) => ChatListScreen(),
      //                 ),
      //               );
      //             },
      //             borderRadius: BorderRadius.circular(28),
      //             child: Container(
      //               padding: EdgeInsets.symmetric(horizontal: 22, vertical: 4),
      //               child: Column(
      //                 mainAxisSize: MainAxisSize.min,
      //                 children: [
      //                   Icon(
      //                     Icons.chat_bubble_outline,
      //                     color: Color(0xff99A1AF),
      //                     size: 24,
      //                   ),
      //                   SizedBox(
      //                     height: 2,
      //                   ),
      //                   Text(
      //                     "Chats",
      //                     style: TextStyle(
      //                       fontSize: 12,
      //                       color: Color(0xff99A1AF),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //           InkWell(
      //             onTap: () {
      //               Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                       builder: (context) => UserProfilePage()));
      //             },
      //             borderRadius: BorderRadius.circular(28),
      //             child: Container(
      //               padding: EdgeInsets.symmetric(horizontal: 22, vertical: 4),
      //               child: Column(
      //                 mainAxisSize: MainAxisSize.min,
      //                 children: [
      //                   Icon(
      //                     Icons.person_outline,
      //                     color: Color(0xff99A1AF),
      //                   ),
      //                   SizedBox(
      //                     height: 2,
      //                   ),
      //                   Text(
      //                     "Profile",
      //                     style: TextStyle(
      //                       fontSize: 12,
      //                       color: Color(0xff99A1AF),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),

      //     //Add new request button

      //     Positioned(
      //       top: 0,
      //       left: MediaQuery.of(context).size.width / 2 - 20,
      //       child: Container(
      //         width: 56,
      //         height: 56,
      //         decoration: BoxDecoration(
      //           shape: BoxShape.circle,
      //           boxShadow: [
      //             BoxShadow(
      //                 color: Colors.grey.withValues(alpha: 0.5),
      //                 spreadRadius: 2,
      //                 blurRadius: 5,
      //                 offset: Offset(0, 3))
      //           ],
      //           gradient: LinearGradient(colors: [
      //             Color.fromARGB(255, 8, 189, 171),
      //             Color.fromARGB(255, 1, 110, 100),
      //             // Color(0xff009689),
      //           ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      //         ),
      //         child: Material(
      //           color: Colors.transparent,
      //           child: InkWell(
      //             borderRadius: BorderRadius.circular(28),
      //             onTap: () {
      //               Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                       builder: (context) => PostRequestPage()));
      //             },
      //             child: Icon(
      //               Icons.add,
      //               size: 34,
      //               color: Colors.white,
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),

      // bottomNavigationBar: BottomNavigationBar(
      //     type: BottomNavigationBarType.fixed,
      //     selectedItemColor: Color(0xff009689),
      //     items: [
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.home_outlined),
      //         label: "Home",
      //       ),
      //       BottomNavigationBarItem(
      //           icon: Icon(Icons.description_outlined), label: "Requests"),

      //       BottomNavigationBarItem(
      //           icon: Icon(Icons.chat_bubble_outline), label: "Chats"),
      //       BottomNavigationBarItem(
      //           icon: Icon(Icons.account_circle_outlined), label: "Profile")
      //     ]),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              SearchBars(),
              SizedBox(
                height: 24,
              ),

              //Quick Actions

              Text(
                "Quick Actions",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Wrap(
                  children: [
                    QuickActionCard(
                      icon: Icons.shopping_bag_outlined,
                      color: Color(0xff00BBA7),
                      text: "Post a Request",
                    ),
                    QuickActionCard(
                      icon: Icons.store_outlined,
                      color: Color(0xff0092B8),
                      text: "Nearby Shops",
                    ),
                    QuickActionCard(
                      icon: Icons.message_outlined,
                      color: Color(0xff155DFC),
                      text: "Offers & Chats",
                    ),
                    QuickActionCard(
                      //TODO: Change the icon to AssetImage icon from figma
                      icon: Icons.star_border,
                      //TODO: Change the color to Gradient
                      color: Color(0xFFFE9A00),
                      text: "Favourites",
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),

              //Live Requests

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Live Requests",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyRequestsScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            "View all",
                            style: TextStyle(color: Color(0xff00BBA7)),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Color(0xff00BBA7),
                          )
                        ],
                      )),
                ],
              ),
              LiveRequestCard(
                productName: "Looking for iPhone 14 Pro Max Cover",
                time: "2 mins ago",
                noOfShopResponded: 2,
              ),
              SizedBox(
                height: 12,
              ),
              LiveRequestCard(
                productName: "Looking for Sony WH-1000XM5 Headphones",
                time: "15 mins ago",
                noOfShopResponded: 5,
              ),
              SizedBox(
                height: 12,
              ),
              LiveRequestCard(
                productName: "Looking for MacBook Air M2 Charger",
                time: "28 mins ago",
                noOfShopResponded: 3,
              ),
              SizedBox(
                height: 12,
              ),
              LiveRequestCard(
                productName: "Looking for Nike Air Max 270 - Size 42",
                time: "1 hour ago",
                noOfShopResponded: 1,
              ),
              SizedBox(
                height: 20,
              ),

              //Trending Deals

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Trending Deals",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Row(
                        children: [
                          Text(
                            "See all",
                            style: TextStyle(color: Color(0xff00BBA7)),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Color(0xff00BBA7),
                          )
                        ],
                      ))
                ],
              ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    TrendingDealsCard(
                      imageURL: "assets/images/earbuds.jpg",
                      productName: "Samsung Galaxy Buds Pro",
                      shopName: "Tech World",
                      currentPrice: "9,500",
                      beforePrice: "12,000",
                      discount: 21,
                      peopleJoined: 12,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    TrendingDealsCard(
                      imageURL: "assets/images/shoe.jpg",
                      productName: "Adidas Running Shoes",
                      shopName: "Sports Zone",
                      currentPrice: "6,800",
                      beforePrice: "8,500",
                      discount: 20,
                      peopleJoined: 5,
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
