import 'package:flutter/material.dart';

class MyRequestsCard extends StatefulWidget {
  final bool isActive;
  final bool isCompleted;
  final bool isPending;
  final bool isExpired;
  final String imageURL;
  const MyRequestsCard({
    super.key,
    required this.isActive,
    required this.imageURL,
    this.isCompleted = false,
    this.isPending = false,
    this.isExpired = false,
  });

  @override
  State<MyRequestsCard> createState() => _MyRequestsCardState();
}

class _MyRequestsCardState extends State<MyRequestsCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.25),
              blurRadius: 5,
              offset: Offset(0, 2),
            )
          ]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //image
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(14),
                  child: Image(
                    image: NetworkImage(widget.imageURL),
                    width: 60,
                    height: 60,
                  ),
                ),
                SizedBox(
                  width: 16,
                ),

                //column content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("iPhone 15 Pro 256GB"),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          if (widget.isActive)
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xffDCFCE7),
                                border: Border.all(
                                  color: Color(0xffB9F8CF),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "Active",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff008236),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else if (widget.isCompleted)
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xffDBEAFE),
                                border: Border.all(
                                  color: Color(0xffBEDBFF),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Color(0xff2B7FFF),
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "Completed",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff1447E6),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else if (widget.isPending)
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xffFEF9C2),
                                border: Border.all(
                                  color: Color(0xffFFF085),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Color(0xffF0B100),
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "Pending",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xffA65F00),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else if (widget.isExpired)
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xffF3F4F6),
                                border: Border.all(
                                  color: Color(0xffE5E7EB),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Color(0xff6A7282),
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "Expired",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff364153),
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
                              vertical: 4,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xffF3F4F6),
                              border: Border.all(
                                color: Color(0xffE5E7EB),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "Electronics",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 16,
                                color: Color(0xff6A7282),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                "2 hrs ago",
                                style: TextStyle(
                                  color: Color(0xff6A7282),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 14,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                size: 16,
                                color: Color(0xff6A7282),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                "5 responses",
                                style: TextStyle(
                                  color: Color(0xff6A7282),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(
                        color: Color(0xffE5E7EB),
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Budget: ₹95,000",
                        style: TextStyle(
                          color: Color(0xff009689),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

          //go to shop responded page icon
          Icon(
            Icons.chevron_right,
            size: 20,
            color: Color(0xff99A1AF),
          ),
        ],
      ),
    );
  }
}
