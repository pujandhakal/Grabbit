import 'package:flutter/material.dart';

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
              Positioned(
                top: 16,
                right: 16,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 12,
                      ),
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
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),

          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                //title
                Row(
                  children: [
                    Text(
                      "Organic Coffee Beans 1kg",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                )

                //rating

                //groupbuy price

                //groupbuy progress

                //join button
              ],
            ),
          ),
        ],
      ),
    );
  }
}
