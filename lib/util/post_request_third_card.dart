import 'package:flutter/material.dart';

class PostRequestThirdCard extends StatefulWidget {
  const PostRequestThirdCard({super.key});

  @override
  State<PostRequestThirdCard> createState() => _PostRequestThirdCardState();
}

class _PostRequestThirdCardState extends State<PostRequestThirdCard> {
  String? _selectedOption;
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
                        Color(0xffFF2056),
                        Color(0xffE7000B),
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.schedule_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  "How soon do you need it?",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),

            //Radio
            RadioListTile(
              activeColor: Color(0xff00BBA7),
              title: Text(
                'Need Soon',
                style: TextStyle(fontSize: 16),
              ),
              subtitle: Text(
                "Within 30 Minutes",
                style: TextStyle(fontSize: 14, color: Color(0xff6A7282)),
              ),
              value: 'Need Soon',
              groupValue: _selectedOption,
              onChanged: (String? value) {
                setState(() {
                  _selectedOption = value;
                });
              },
            ),
            RadioListTile(
              activeColor: Color(0xff00BBA7),
              value: "This Week",
              title: Text("This Week"),
              subtitle: Text(
                "1-7 days",
                style: TextStyle(fontSize: 14, color: Color(0xff6A7282)),
              ),
              groupValue: _selectedOption,
              onChanged: (String? value) {
                setState(() {
                  _selectedOption = value;
                });
              },
            ),
            RadioListTile(
              activeColor: Color(0xff00BBA7),
              value: "Flexible",
              title: Text("Flexible"),
              subtitle: Text(
                "No rush",
                style: TextStyle(fontSize: 14, color: Color(0xff6A7282)),
              ),
              groupValue: _selectedOption,
              onChanged: (String? value) {
                setState(() {
                  _selectedOption = value;
                });
              },
            )
          ],
        ));
  }
}
