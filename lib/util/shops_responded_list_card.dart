import 'package:flutter/material.dart';
import 'package:grabbit/pages/user/Store_details_screen.dart';
import 'package:grabbit/util/Shop/gradient_icon.dart';

class ShopsRespondedListCard extends StatefulWidget {
  const ShopsRespondedListCard({super.key});

  @override
  State<ShopsRespondedListCard> createState() => _ShopsRespondedListCardState();
}

class _ShopsRespondedListCardState extends State<ShopsRespondedListCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.25),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2),
            )
          ]),
      child: Column(
        children: [
          //shop details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GradientIconCard(
                icon: Icons.storefront_outlined,
                iconSize: 32,
                gradientColors: [Color(0xff00BBA7), Color(0xff0092B8)],
                padding: 16,
              ),
              SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Fashion Hub Kathmandu",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Color(0xff155DFC),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffF0FDFA),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: Color(0xff00786F),
                              size: 16,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              "450m away",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff00786F),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffEFF6FF),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              color: Color(0xff155DFC),
                              size: 16,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              "5 mins ago",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff155DFC),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      //rating container
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffFFFBEB),
                          border: Border.all(
                            color: Color(0xffFEE685),
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: Color(0xffFE9A00),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              "4.8",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 6,
                      ),

                      //reviews
                      Text(
                        "(234 reviews)",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff6A7282),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),

          //product description
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
              color: Color(0xffF0FDFA),
              border: Border.all(
                color: Color(0xff96F7E4),
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Text(
                  "We have red hoodie in stock! Available in size L, premium cotton material.",
                ),
                SizedBox(
                  height: 12,
                ),
                Divider(
                  color: Color(0xff96F7E4),
                  thickness: 0.5,
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Text(
                      "Offered Price:",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff4A5565),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Rs. 2,500",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff008236),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),

          //two side by side buttons
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(
                      EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.all(Color(0xff00BBA7)),
                    shadowColor: WidgetStateProperty.all(
                      Colors.grey.withValues(alpha: 0.2),
                    ),
                    elevation: WidgetStateProperty.all(4),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoreDetailsScreen(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.visibility_outlined),
                      SizedBox(
                        width: 8,
                      ),
                      Text("View Store"),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xff46ECD5),
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 16,
                  color: Color(0xff009689),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
