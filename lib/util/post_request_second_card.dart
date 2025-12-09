import 'package:flutter/material.dart';

class PostRequestSecondCard extends StatefulWidget {
  const PostRequestSecondCard({super.key});

  @override
  State<PostRequestSecondCard> createState() => _PostRequestSecondCardState();
}

class _PostRequestSecondCardState extends State<PostRequestSecondCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.15),
          spreadRadius: 1,
          blurRadius: 5,
          offset: Offset(0, 2),
        )
      ], color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          //upload icon and text
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.35),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                  gradient: LinearGradient(
                    colors: [
                      Color(0xffFE9A00),
                      Color(0xffF54900),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.photo_album_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                "Upload Photo (Optional)",
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
          SizedBox(
            height: 12,
          ),

          //drag drop box
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xff46ECD5)),
              borderRadius: BorderRadius.circular(16),
              color: Color(0xffF7FEFD),
            ),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.35),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 4),
                      )
                    ], shape: BoxShape.circle, color: Colors.white),
                    child: Icon(
                      Icons.upload_outlined,
                      color: Color(0xff009689),
                      size: 32,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Click to upload or drag and drop",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "PNG, JPG up to 5MB",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xff6A7282),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
