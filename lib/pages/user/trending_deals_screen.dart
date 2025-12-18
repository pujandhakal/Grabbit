import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TrendingDealsScreen extends StatefulWidget {
  const TrendingDealsScreen({super.key});

  @override
  State<TrendingDealsScreen> createState() => _TrendingDealsScreenState();
}

class _TrendingDealsScreenState extends State<TrendingDealsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppBar(
            toolbarHeight: 70,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.chevron_left,
                color: Colors.white,
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset("assets/images/star_icon.svg"),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "GroupBuy Deals",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Unlock exclusive discounts together",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                )
              ],
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Container(
              height: kToolbarHeight + 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                gradient: LinearGradient(
                  colors: [
                    Color(0xff00B8DB),
                    Color(0xff00BBA7),
                    Color(0xff009689),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Positioned(
            top: kToolbarHeight + 50,
            left: 40,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white30),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.show_chart_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "8 Live Deals",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
