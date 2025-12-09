import 'package:flutter/material.dart';
import 'package:grabbit/util/long_button.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Get Started with Grabbit",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //I am user

              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedOption = "user";
                  });
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image(
                        image: AssetImage('assets/images/user.png'),
                        height: 160,
                        width: 400,
                        fit: BoxFit.cover,
                      ),
                    ),
                    selectedOption == "user"
                        ? Container(
                            width: 400,
                            height: 160,
                            decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                              child: Icon(
                                Icons.check_circle,
                                size: 80,
                                color: Colors.green,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),

              SizedBox(
                height: 10,
              ),

              Text(
                "I'm a User",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              Text(
                "Find and request products from local stores.",
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  color: Color(0xFF4A879C).withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),

              SizedBox(
                height: 32,
              ),

              //I am Shop

              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedOption = "shop";
                  });
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image(
                        image: AssetImage("assets/images/shop.png"),
                        height: 160,
                        width: 400,
                        fit: BoxFit.cover,
                      ),
                    ),
                    selectedOption == "shop"
                        ? Container(
                            height: 160,
                            width: 400,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 80,
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),

              SizedBox(
                height: 10,
              ),

              Text(
                "I'm a Shop",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                "Manage your store and fulfill customer requests.",
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  color: Color(0xFF4A879C).withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),

              SizedBox(
                height: 60,
              ),

              //buttons
              //continue with Email
              LongButton(
                btnName: "Continue with Email",
                color: Color(0xFF0DBAF2),
              ),
              SizedBox(
                height: 8,
              ),
              //continue with google
              LongButton(
                btnName: "Continue with Google",
                color: Color(0xFFE8F0F5),
              ),

              SizedBox(
                height: 8,
              ),

              //Agree Terms and conditions Text
              Text(
                "By continuing, you agree to our Terms of Service and Privacy Policy.",
                style: TextStyle(
                  color: Color(0xFF4A879C),
                  fontSize: 12,
                  fontWeight: FontWeight.w100,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
