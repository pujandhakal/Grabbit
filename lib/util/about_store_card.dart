import 'package:flutter/material.dart';

class AboutStoreCard extends StatelessWidget {
  const AboutStoreCard({super.key});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xffCBFBF1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.info_outline,
                  size: 18,
                  color: Color(0xff009689),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "About Store",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "Premium fashion store offering latest trends in clothing, accessories, and footwear. We pride ourselves on quality products and excellent customer service. Visit us for the best deals in Kathmandu!",
            style: TextStyle(color: Color(0xff364153)),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Icon(
                Icons.local_offer_outlined,
                size: 18,
                color: Color(0xff009689),
              ),
              SizedBox(
                width: 8,
              ),
              Text("Specialties:")
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Wrap(
            runSpacing: 8,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Color(0xffF0FDFA),
                  border: Border.all(
                    color: Color(0xff96F7E4),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Clothing",
                  style: TextStyle(
                    color: Color(0xff00786F),
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Color(0xffF0FDFA),
                  border: Border.all(
                    color: Color(0xff96F7E4),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Fashion",
                  style: TextStyle(
                    color: Color(0xff00786F),
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Color(0xffF0FDFA),
                  border: Border.all(
                    color: Color(0xff96F7E4),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Accessories",
                  style: TextStyle(
                    color: Color(0xff00786F),
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Color(0xffF0FDFA),
                  border: Border.all(
                    color: Color(0xff96F7E4),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Footwear",
                  style: TextStyle(
                    color: Color(0xff00786F),
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
