import 'package:flutter/material.dart';

class CustomerRequestCard extends StatelessWidget {
  final String title;
  final bool isNew;
  final bool isUrgent;
  final String personName;
  final String description;
  final String distance;
  final String time;
  final String money;

  const CustomerRequestCard(
      {super.key,
      required this.title,
      this.isNew = false,
      this.isUrgent = false,
      required this.personName,
      required this.description,
      required this.distance,
      required this.time,
      required this.money});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.25),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //title
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                width: 6,
              ),
              isNew
                  ? Container(
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                      decoration: BoxDecoration(
                        color: Color(0xff00BBA7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "New",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    )
                  : SizedBox.shrink(),
              SizedBox(
                width: 6,
              ),
              isUrgent
                  ? Container(
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Color(0xffFB2C36),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "🔥Urgent",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),

          SizedBox(
            height: 2,
          ),

          //personName
          Text(
            "by $personName",
            style: TextStyle(fontSize: 12, color: Color(0xff6A7282)),
          ),

          SizedBox(
            height: 16,
          ),

          //Description
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xff364153),
            ),
          ),

          SizedBox(
            height: 16,
          ),

          //row icon plus text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.pin_drop_outlined,
                    color: Color(0xff00BBA7),
                    size: 16,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    "$distance away",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xff4A5565),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.watch_later_outlined,
                    color: Color(0xff00BBA7),
                    size: 16,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    "$time ago",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xff4A5565),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.attach_money,
                    color: Color(0xff008236),
                    size: 16,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    "Rs. $money",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xff008236),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(
            height: 16,
          ),

          //two buttons
          Row(
            children: [
              Expanded(
                flex: 55,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 26),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.45),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      )
                    ],
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff00BBA7),
                        Color(0xff0092B8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 16,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Respond",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                flex: 45,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffD1D5DC)),
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.visibility_outlined,
                        size: 16,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "View Details",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
