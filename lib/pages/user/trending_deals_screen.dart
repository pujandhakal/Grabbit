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
        ],
      ),
    );
  }
}
