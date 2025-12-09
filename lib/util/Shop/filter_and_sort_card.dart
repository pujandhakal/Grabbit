import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FilterAndSortCard extends StatefulWidget {
  const FilterAndSortCard({super.key});

  @override
  State<FilterAndSortCard> createState() => _FilterAndSortCardState();
}

class _FilterAndSortCardState extends State<FilterAndSortCard> {
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

  String? _selectedSortValue;
  final List<String> sortItems = [
    "Nearest First",
    "Newest First",
    "Urgent First",
    "Highest Budget",
  ];

  bool _giveVerse = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.25),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2),
            )
          ],
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          //filter & sort
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/images/filter_icon.svg'),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Filter & Sort Requests",
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
              Text(
                "Clear All",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff009689),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 18,
          ),

          //category
          Row(
            children: [
              Icon(
                Icons.category_outlined,
                color: Color(0xff009689),
                size: 16,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                "Category",
                style: TextStyle(
                  color: Color(0xff4A5565),
                ),
              ),
            ],
          ),

          SizedBox(
            height: 8,
          ),

          DropdownButtonFormField(
              initialValue: _selectedValue,
              icon: Icon(
                Icons.expand_more,
                color: Color(
                  0xffD1D5DC,
                ),
                size: 22,
              ),
              hint: Text(
                "All Categories",
                style: TextStyle(color: Colors.black),
              ),
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Color(0xffD1D5DC),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Color(0xff01AEAD),
                      ))),
              items: dropDownItems.map((String item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedValue = newValue;
                });
              }),

          SizedBox(
            height: 12,
          ),

          //sort by
          Row(
            children: [
              SvgPicture.asset(
                'assets/images/filter_icon.svg',
                width: 16,
                height: 16,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                "Sort By",
                style: TextStyle(
                  color: Color(0xff4A5565),
                ),
              )
            ],
          ),

          SizedBox(
            height: 8,
          ),

          DropdownButtonFormField(
              hint: Text(
                sortItems[0],
                style: TextStyle(color: Colors.black),
              ),
              initialValue: _selectedSortValue,
              icon: Icon(
                Icons.expand_more,
                color: Color(
                  0xffD1D5DC,
                ),
                size: 22,
              ),
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Color(0xffD1D5DC),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Color(0xff01AEAD),
                  ),
                ),
              ),
              items: sortItems.map((String sortItem) {
                return DropdownMenuItem(value: sortItem, child: Text(sortItem));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSortValue = newValue;
                });
              }),

          SizedBox(
            height: 20,
          ),

          //show only new request
          Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 6),
            decoration: BoxDecoration(
              border: BoxBorder.all(
                color: Color(0xff96F7E4),
              ),
              color: Color(0xffEDFEFE),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    //Icon
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xff00BBA7),
                          borderRadius: BorderRadius.circular(10)),
                      child: SvgPicture.asset(
                          "assets/images/new_request_icon.svg"),
                    ),

                    SizedBox(
                      width: 12,
                    ),

                    //column text
                    Column(
                      children: [
                        Text("Show only new requests"),
                        Text(
                          "Focus on fresh opportunities",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff4A5565),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                //toggle button
                Transform.scale(
                  scale: 0.7,
                  child: Switch(
                    activeThumbColor: Color(0xff00BBA7),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey.withValues(alpha: 0.35),
                    trackOutlineColor:
                        WidgetStateProperty.all(Colors.transparent),
                    value: _giveVerse,
                    // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (bool newValue) {
                      setState(() {
                        _giveVerse = newValue;
                      });
                    },
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
