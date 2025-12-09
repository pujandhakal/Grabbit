import 'package:flutter/material.dart';

class StoreLocationCard extends StatefulWidget {
  const StoreLocationCard({super.key});

  @override
  State<StoreLocationCard> createState() => _StoreLocationCardState();
}

class _StoreLocationCardState extends State<StoreLocationCard> {
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
                  color: Color(0xffFFE2E2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: Color(0xffE7000B),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "Location",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Image.asset('assets/images/Container.png'),
          SizedBox(
            height: 16,
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 250, 250, 250),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Color(0xffE5E7EB),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.25),
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        )
                      ]),
                  child: Icon(
                    Icons.near_me_outlined,
                    size: 18,
                    color: Color(0xff009689),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Thamel, Kathmandu 44600",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Near Kathmandu Guest House, opposite to Himalayan Java Coffee",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff4A5565),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
