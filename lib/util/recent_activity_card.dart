import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecentActivityCard extends StatelessWidget {
  const RecentActivityCard({super.key});

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
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xffF3E8FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.timeline,
                  size: 18,
                  color: Color(0xff9810FA),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "Recent Activity",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                width: 8,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Color(0xffF3E8FF),
                ),
                child: Text(
                  "Fast Responder",
                  style: TextStyle(
                    color: Color(0xff8200DB),
                    fontSize: 12,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Color(0xffB9F8CF)),
              color: Color(0xffF0FDF4),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.15),
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ]),
                      child: Icon(
                        Icons.task_alt,
                        size: 18,
                        color: Color(0xff00A63E),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Text("Responded to a request for Laptop Charger"),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 44,
                    ),
                    Icon(
                      Icons.schedule_outlined,
                      size: 14,
                      color: Color(0xff4A5565),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "30 minutes ago",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff4A5565),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Color(0xffB9F8CF)),
              color: Color(0xffF0FDF4),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.15),
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ]),
                      child: Icon(
                        Icons.task_alt,
                        size: 18,
                        color: Color(0xff00A63E),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Text("Responded to a request for Winter Jacket"),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 44,
                    ),
                    Icon(
                      Icons.schedule_outlined,
                      size: 14,
                      color: Color(0xff4A5565),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "1 hour ago",
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
          SizedBox(
            height: 16,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Color(0xff96F7E4)),
              color: Color(0xffF0FDFA),
            ),
            child: Text(
              "✨ This store typically responds within 15 minutes",
              style: TextStyle(fontSize: 10),
            ),
          )
        ],
      ),
    );
  }
}
