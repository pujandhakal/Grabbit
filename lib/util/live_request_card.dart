import 'package:flutter/material.dart';
import 'package:grabbit/pages/user/shops_responded_page.dart';

class LiveRequestCard extends StatelessWidget {
  final String productName;
  final String time;
  final int noOfShopResponded;
  const LiveRequestCard(
      {super.key,
      required this.productName,
      required this.time,
      required this.noOfShopResponded});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShopsRespondedPage(),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.15),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //content
            Expanded(
              child: Column(
                children: [
                  Text(
                    productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 18,
                            color: Color(0xff6A7282),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            time,
                            style: TextStyle(
                                fontSize: 14, color: Color(0xff6A7282)),
                          )
                        ],
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shop_outlined,
                              size: 18,
                              color: Color(0xff009689),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              "$noOfShopResponded shops responded",
                              style: TextStyle(
                                  color: Color(0xff009689), fontSize: 14),
                            ),
                          ])
                    ],
                  )
                ],
              ),
            ),

            //live indicator
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Color(0xffCBFBF1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Live",
                style: TextStyle(color: Color(0xff009689), fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
