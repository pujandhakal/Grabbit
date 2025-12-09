import 'package:flutter/material.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';

class CustomerReviewsCard extends StatefulWidget {
  const CustomerReviewsCard({super.key});

  @override
  State<CustomerReviewsCard> createState() => _CustomerReviewsCardState();
}

class _CustomerReviewsCardState extends State<CustomerReviewsCard> {
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
          ),
        ],
      ),
      child: Column(
        children: [
          //Row contenent
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xffFEF3C6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.star_rounded,
                      size: 18,
                      color: Color(0xffE17100),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Customer Reviews",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text(
                        "See All",
                        style: TextStyle(
                          color: Color(0xff009689),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Color(0xff009689),
                      )
                    ],
                  ))
            ],
          ),
          SizedBox(
            height: 16,
          ),

          //4.8 star
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Color(0xffFEE685),
              ),
              color: Color(0xffFFFBEB),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "4.8",
                          style: TextStyle(fontSize: 30),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Icon(
                          Icons.star_rounded,
                          size: 20,
                          color: Color(0xffFE9A00),
                        ),
                        Icon(
                          Icons.star_rounded,
                          size: 20,
                          color: Color(0xffFE9A00),
                        ),
                        Icon(
                          Icons.star_rounded,
                          size: 20,
                          color: Color(0xffFE9A00),
                        ),
                        Icon(
                          Icons.star_rounded,
                          size: 20,
                          color: Color(0xffFE9A00),
                        ),
                        Icon(
                          Icons.star_rounded,
                          size: 20,
                          color: Color(0xffFE9A00),
                        ),
                      ],
                    ),
                    Text(
                      "Based on 234 reviews",
                      style: TextStyle(fontSize: 12, color: Color(0xff4A5565)),
                    )
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "5⭐",
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        LinearPercentIndicator(
                          width: 64,
                          lineHeight: 8,
                          percent: 0.85,
                          backgroundColor: Color(0xffFEE685),
                          progressColor: Color(0xffFE9A00),
                          barRadius: Radius.circular(10),
                          padding: EdgeInsets.zero,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          "85%",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Text(
                          "4⭐",
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        LinearPercentIndicator(
                          width: 64,
                          lineHeight: 8,
                          percent: 0.6,
                          backgroundColor: Color(0xffFEE685),
                          progressColor: Color(0xffFE9A00),
                          barRadius: Radius.circular(10),
                          padding: EdgeInsets.zero,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          "60%",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),

          SizedBox(
            height: 16,
          ),

          //people's comment

          Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Color(0xffE5E7EB),
              ),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage("https://picsum.photos/208"),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          children: [
                            Text("Priya Sharma"),
                            SizedBox(
                              height: 2,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  size: 20,
                                  color: Color(0xffFE9A00),
                                ),
                                Icon(
                                  Icons.star_rounded,
                                  size: 20,
                                  color: Color(0xffFE9A00),
                                ),
                                Icon(
                                  Icons.star_rounded,
                                  size: 20,
                                  color: Color(0xffFE9A00),
                                ),
                                Icon(
                                  Icons.star_rounded,
                                  size: 20,
                                  color: Color(0xffFE9A00),
                                ),
                                Icon(
                                  Icons.star_rounded,
                                  size: 20,
                                  color: Color(0xffFE9A00),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      "2 days ago",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff6A7282),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 52,
                    ),
                    Expanded(
                      child: Text(
                        "Excellent service! Found exactly what I was looking for. The staff was very helpful and friendly.",
                        style: TextStyle(
                          color: Color(0xff364153),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),

          SizedBox(
            height: 12,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Color(0xffE5E7EB),
              ),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage("https://picsum.photos/210"),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          children: [
                            Text("Amit Kumar"),
                            SizedBox(
                              height: 2,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  size: 20,
                                  color: Color(0xffFE9A00),
                                ),
                                Icon(
                                  Icons.star_rounded,
                                  size: 20,
                                  color: Color(0xffFE9A00),
                                ),
                                Icon(
                                  Icons.star_rounded,
                                  size: 20,
                                  color: Color(0xffFE9A00),
                                ),
                                Icon(
                                  Icons.star_rounded,
                                  size: 20,
                                  color: Color(0xffFE9A00),
                                ),
                                Icon(
                                  Icons.star_outline_rounded,
                                  size: 20,
                                  color: Color(0xffD1D5DC),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      "5 days ago",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff6A7282),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 52,
                    ),
                    Expanded(
                      child: Text(
                        "Good collection and reasonable prices. Quick response to my request.",
                        style: TextStyle(
                          color: Color(0xff364153),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
