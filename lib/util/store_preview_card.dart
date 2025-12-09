import 'package:flutter/material.dart';
import 'package:grabbit/util/Shop/gradient_icon.dart';

class StorePreviewCard extends StatelessWidget {
  const StorePreviewCard({super.key});

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
                        style: TextStyle(
                          fontSize: 16,
                        ),
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
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.15),
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        )
                      ],
                      color: Color(0xffFFFBEB),
                      border: Border.all(
                        color: Color(0xffFEE685),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: Color(0xffFE9A00),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          "4.8",
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "234 reviews",
                          style:
                              TextStyle(fontSize: 10, color: Color(0xff4A5565)),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xffF0FDFA),
                      border: Border.all(
                        color: Color(0xff96F7E4),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Color(0xff00786F),
                          size: 18,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          "850m away",
                          style: TextStyle(
                            color: Color(0xff00786F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Divider(
            color: Color(0xffE5E7EB),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Color(0xffECFDF5),
                    border: Border.all(
                      color: Color(0xffB9F8CF),
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Color(0xff00C950),
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Open Now",
                        style: TextStyle(color: Color(0xff008236)),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Color(0xffF3F4F6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule_outlined,
                        size: 16,
                        color: Color(0xff4A5565),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        "Closes 9:00 PM",
                        style: TextStyle(color: Color(0xff364153)),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
