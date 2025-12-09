import 'package:flutter/material.dart';

class TrendingDealsCard extends StatelessWidget {
  final String productName;
  final String imageURL;
  final String shopName;
  final String currentPrice;
  final String beforePrice;
  final int discount;
  final int peopleJoined;
  const TrendingDealsCard({
    super.key,
    required this.productName,
    required this.imageURL,
    required this.shopName,
    required this.currentPrice,
    required this.beforePrice,
    required this.discount,
    required this.peopleJoined,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 260,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.15),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2),
            )
          ]),
      child: Column(
        children: [
          //product Image
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              child: Stack(children: [
                Image.asset(
                  imageURL,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                        color: Color(0xff00BBA7),
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      "GroupBuy",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ]),
            ),
          ),

          SizedBox(
            height: 8,
          ),

          //product description
          Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //product name
                    Text(
                      productName,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 3,
                    ),

                    //store name
                    Text(
                      shopName,
                      style: TextStyle(fontSize: 12, color: Color(0xff6A7282)),
                    ),
                    SizedBox(
                      height: 8,
                    ),

                    //price
                    Row(
                      children: [
                        Text(
                          "Rs. $currentPrice",
                          style:
                              TextStyle(fontSize: 16, color: Color(0xff009689)),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          "Rs. $beforePrice",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff99A1AF),
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Color(0xff99A1AF),
                              decorationThickness: 1.5),
                        )
                      ],
                    ),

                    SizedBox(
                      height: 9,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //DISCOUNT
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                              color: Color(0xffCBFBF1),
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.local_offer_outlined,
                                size: 16,
                                color: Color(0xff009689),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "$discount% OFF",
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xff009689)),
                              )
                            ],
                          ),
                        ),

                        //PEOPLE JOINED
                        Row(
                          children: [
                            Icon(Icons.people_outline,
                                size: 16, color: Color(0xff6A7282)),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              "$peopleJoined Joined",
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xff6A7282)),
                            ),
                          ],
                        )
                      ],
                    )

                    //people joined
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
