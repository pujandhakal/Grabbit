import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PostRequestFirstCard extends StatefulWidget {
  const PostRequestFirstCard({super.key});

  @override
  State<PostRequestFirstCard> createState() => _PostRequestFirstCardState();
}

class _PostRequestFirstCardState extends State<PostRequestFirstCard> {
  String? _selectedValue;
  final List<String> dropDownItems = [
    "Electronics",
    "Clothing",
    "Groceries",
    "Home & Kitchen",
    "Sports & Fitness",
    "Books & Stationery",
    "Health & Beauty",
    "Others"
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withValues(alpha: 0.15),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2))
        ],
        color: Colors.white,
      ),
      child: Column(
        children: [
          //product name
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.35),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 2))
                    ],
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(colors: [
                      Color(0xff00BBA7),
                      Color(0xff0092B8),
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                child: SvgPicture.asset(
                  "assets/images/productName_icon.svg",
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                "Product Name",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                width: 2,
              ),
              Text(
                "*",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          TextField(
            decoration: InputDecoration(
                hintText: "e.g., Local Churpi",
                hintStyle: TextStyle(color: Color(0xff717182), fontSize: 14),
                // filled: true,
                // fillColor: Color(0xFFF8F8F8),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Color(0xFFE5E7EB),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Color(0xFFE5E7EB),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Color(0xff00BBA7)))),
          ),
          SizedBox(
            height: 20,
          ),

          //desc
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.35),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    )
                  ],
                  gradient: LinearGradient(
                    colors: [Color(0xff2B7FFF), Color(0xff4F39F6)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: SvgPicture.asset("assets/images/productDesc_icon.svg"),
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                "Description / Details",
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
          SizedBox(
            height: 12,
          ),
          TextField(
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "e.g., Sakey samma Chaurey gai ko moi le baneko",
              hintStyle: TextStyle(
                fontSize: 14,
                color: Color(0xff717182),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Color(0xFFE5E7EB),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Color(0xff00BBA7),
                ),
              ),
            ),
          ),

          SizedBox(
            height: 20,
          ),

          //category and quantity
          Row(children: [
            //category
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.35),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            )
                          ],
                          gradient: LinearGradient(
                            colors: [
                              Color(0xffAD46FF),
                              Color(0xffE60076),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(
                          Icons.local_offer_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Category",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        "*",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  DropdownButtonFormField(
                    initialValue: _selectedValue,
                    icon: Icon(Icons.expand_more),
                    hint: Text("Select"),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 2, vertical: 15),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Color(0xFFE5E7EB),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Color(0xff00BBA7),
                        ),
                      ),
                    ),
                    selectedItemBuilder: (BuildContext context) {
                      return dropDownItems.map<Widget>((String item) {
                        return SizedBox(
                          width: 110,
                          child: Text(
                            item,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        );
                      }).toList();
                    },
                    items: dropDownItems.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedValue = newValue;
                      });
                    },
                  )
                ],
              ),
            ),

            SizedBox(
              width: 12,
            ),

            //quantity
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.35),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 2))
                          ],
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff615FFF),
                              Color(0xff9810FA),
                            ],
                          ),
                        ),
                        child: SvgPicture.asset(
                            height: 16,
                            width: 16,
                            "assets/images/productName_icon.svg"),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Quantity",
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                      hintText: "e.g., 2 pcs",
                      hintStyle:
                          TextStyle(color: Color(0xff717182), fontSize: 14),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Color(0xffE5E7EB),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Color(0xff00BBA7),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ])
        ],
      ),
    );
  }
}
