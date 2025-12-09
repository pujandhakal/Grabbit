import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ResponseFilterCard extends StatefulWidget {
  const ResponseFilterCard({super.key});

  @override
  State<ResponseFilterCard> createState() => _ResponseFilterCardState();
}

class _ResponseFilterCardState extends State<ResponseFilterCard> {
  final List<String> responseTypeItems = [
    "Nearest First",
    "Lowest Price",
    "Highest Rated",
    "Most Recent"
  ];

  final List<String> shopTypeItems = [
    "All Shops",
    "Available Now",
    "Verified Only"
  ];

  String? _selectedValue;
  String? _selectedValueForShop;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField(
              initialValue: responseTypeItems[0],
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIconConstraints: BoxConstraints(
                  minHeight: 28,
                  minWidth: 28,
                ),
                prefixIcon: Container(
                  padding: EdgeInsets.all(6),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Color(0xffCBFBF1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.swap_vert,
                    size: 18,
                    color: Color(0xff009689),
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
                    borderSide: BorderSide(
                      color: Color(0xff01B2AB),
                    )),
              ),
              icon: Icon(
                Icons.expand_more,
                color: Color(0xff717182),
                size: 16,
              ),
              selectedItemBuilder: (BuildContext context) {
                return responseTypeItems.map((String item) {
                  return DropdownMenuItem(
                    value: item,
                    child: SizedBox(
                      width: 75,
                      child: Text(
                        item,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  );
                }).toList();
              },
              items: responseTypeItems.map((String item) {
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
        ),
        SizedBox(
          width: 12,
        ),
        Expanded(
          child: DropdownButtonFormField(
              initialValue: shopTypeItems[0],
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIconConstraints: BoxConstraints(
                  minHeight: 28,
                  minWidth: 28,
                ),
                prefixIcon: Container(
                  padding: EdgeInsets.all(6),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffF3E8FF),
                  ),
                  child: Icon(
                    Icons.filter_list_rounded,
                    size: 18,
                    color: Color(0xff9810FA),
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
                  borderSide: BorderSide(
                    color: Color(0xff01B2AB),
                  ),
                ),
              ),
              icon: Icon(
                Icons.expand_more,
                color: Color(0xff717182),
                size: 16,
              ),
              selectedItemBuilder: (BuildContext context) {
                return shopTypeItems.map<Widget>((String item) {
                  return DropdownMenuItem(
                    value: item,
                    child: SizedBox(
                      width: 75,
                      child: Text(
                        item,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  );
                }).toList();
              },
              items: shopTypeItems.map((String item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedValueForShop = newValue;
                });
              }),
        ),
      ],
    );
  }
}
