import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grabbit/util/Shop/gradient_icon.dart';

class JoinGroupbuyCard extends StatefulWidget {
  const JoinGroupbuyCard({super.key});

  @override
  State<JoinGroupbuyCard> createState() => _JoinGroupbuyCardState();
}

class _JoinGroupbuyCardState extends State<JoinGroupbuyCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(25, 0, 0, 0),
            offset: Offset(0, 20),
            blurRadius: 25,
            spreadRadius: -5,
          ),
          BoxShadow(
            color: Color.fromARGB(25, 0, 0, 0),
            offset: Offset(0, 8),
            blurRadius: 10,
            spreadRadius: -6,
          ),
        ],
      ),
      child: Column(
        children: [
          //image with stack of tags
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: Image.network(
                  "https://picsum.photos/400/200",
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.5),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [0.1, 0.7],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Column(
                  children: [
                    Container(
                      width: 90,
                      padding: EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 12,
                      ),
                      margin: EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xffFB2C36),
                            Color(0xffFF6900),
                            Color(0xffF6339A),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.electric_bolt_sharp,
                            size: 12,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "21% off",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 12,
                      ),
                      margin: EdgeInsets.only(bottom: 4),
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xffAD46FF),
                            Color(0xffF6339A),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_fire_department_outlined,
                            size: 12,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "Trending",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 12,
                      ),
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xffFDC700),
                            Color(0xffFF6900),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/star_icon.svg',
                            height: 12,
                            width: 12,
                            colorFilter: ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "Hot Deal",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.8),
                        Colors.black.withValues(alpha: 0.6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(25, 0, 0, 0),
                        offset: Offset(0, 20),
                        blurRadius: 25,
                        spreadRadius: -5,
                      ),
                      BoxShadow(
                        color: Color.fromARGB(25, 0, 0, 0),
                        offset: Offset(0, 8),
                        blurRadius: 10,
                        spreadRadius: -6,
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.schedule_outlined,
                        color: Color(0xffFFB86A),
                        size: 16,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        "Ends in 3h",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),

          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                //title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Organic Coffee Beans 1kg",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Color(0xffF9FAFB),
                        border: Border.all(
                          color: Color(0xffE5E7EB),
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Color(0xff00BBA7),
                            size: 18,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "2.1 km",
                            style: TextStyle(
                              color: Color(0xff6A7282),
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),

                //rating
                Row(
                  children: [
                    Text(
                      "Daily Groceries",
                      style: TextStyle(
                        color: Color(0xff4A5565),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Color(0xffFEFCE8),
                        border: Border.all(color: Color(0xffFFF085)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 18,
                            color: Color(0xffFDC700),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            "4.7",
                            style: TextStyle(
                              color: Color(0xff364153),
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),

                //groupbuy price
                Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(bottom: 16, top: 16),
                  decoration: BoxDecoration(
                    color: Color(0xffF0FDFA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Color(0xffCBFBF1),
                    ),
                  ),
                  child: Column(
                    children: [
                      //price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "GroupBuy Price",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff6A7282),
                                ),
                              ),
                              Text(
                                "Rs. 950",
                                style: TextStyle(
                                  fontSize: 36,
                                  color: Color(0xff009689),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Regular Price",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff99A1AF),
                                ),
                              ),
                              Text(
                                "Rs. 1,200",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xff99A1AF),
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Color(0xff99A1AF),
                                ),
                              )
                            ],
                          )
                        ],
                      ),

                      //divider
                      Divider(
                        color: Color(0xffCBFBF1),
                        thickness: 1,
                      ),

                      SizedBox(
                        height: 8,
                      ),

                      //you saved
                      Row(children: [
                        Container(
                          padding: EdgeInsets.all(6),
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffDCFCE7),
                          ),
                          child: Icon(
                            Icons.trending_up,
                            color: Color(0xff00A63E),
                            size: 16,
                          ),
                        ),
                        Text(
                          "You save Rs. 840",
                          style: TextStyle(
                            color: Color(0xff00A63E),
                          ),
                        ),
                      ])
                    ],
                  ),
                ),

                //groupbuy progress
                Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Color(0xffF0FDFA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Color(0xffCBFBF1),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              GradientIconCard(
                                icon: Icons.people_outlined,
                                gradientColors: [
                                  Color(0xff00BBA7),
                                  Color(0xff00B8DB),
                                ],
                                padding: 8,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Group Progress",
                                    style: TextStyle(
                                      color: Color(0xff4A5565),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "22",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xff009689),
                                        ),
                                      ),
                                      Text(
                                        "/ 25 joined",
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "83%",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Color(0xff009689),
                                ),
                              ),
                              Text(
                                "complete",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff6A7282),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      //progress bar

                      //row icon text
                    ],
                  ),
                ),

                //join button
              ],
            ),
          ),
        ],
      ),
    );
  }
}
