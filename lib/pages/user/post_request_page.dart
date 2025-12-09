import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grabbit/util/post_request_first_card.dart';
import 'package:grabbit/util/post_request_second_card.dart';
import 'package:grabbit/util/post_request_third_card.dart';

class PostRequestPage extends StatefulWidget {
  const PostRequestPage({super.key});

  @override
  State<PostRequestPage> createState() => _PostRequestPageState();
}

class _PostRequestPageState extends State<PostRequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.chevron_left,
              color: Colors.white,
            )),
        toolbarHeight: 70,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Post What You Need",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
                SizedBox(
                  width: 3,
                ),
                SvgPicture.asset("assets/images/star_icon.svg"),
              ],
            ),
            SizedBox(
              height: 3,
            ),
            Row(
              children: [
                Text(
                  "Nearby shops will see your request",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            )
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff009689), Color(0xff0092B8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              //product details
              SizedBox(
                height: 20,
              ),
              PostRequestFirstCard(),

              SizedBox(
                height: 20,
              ),

              //upload photo
              PostRequestSecondCard(),
              SizedBox(
                height: 20,
              ),

              //when do you need
              PostRequestThirdCard(),
              SizedBox(
                height: 20,
              ),

              //Delivery Location
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 0, bottom: 20, left: 20, right: 20),
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff00BBA7),
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              )),
          child: Text(
            "Post Request",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
