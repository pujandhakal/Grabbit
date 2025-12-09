import 'package:flutter/material.dart';

class AlreadyRequestedProductCard extends StatelessWidget {
  const AlreadyRequestedProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.25),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //photo
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Color(0xffCCFAF7)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    "assets/images/earbuds.jpg",
                    width: 92,
                    height: 92,
                  ),
                ),
              ),

              SizedBox(
                width: 16,
              ),

              //column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Red Hoodie, Size L",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Color(0xffF0FDFA),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Color(0xff96F7E4),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_offer_outlined,
                          size: 14,
                          color: Color(0xff009689),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          "Clothing",
                          style:
                              TextStyle(fontSize: 12, color: Color(0xff009689)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Color(0xffF3F4F6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule_outlined,
                          size: 14,
                          color: Color(0xff4A5565),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          "Posted 2 hours ago",
                          style:
                              TextStyle(fontSize: 12, color: Color(0xff4A5565)),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),

          //Active tag
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff00C950),
                  Color(0xff009966),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              "Active",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
