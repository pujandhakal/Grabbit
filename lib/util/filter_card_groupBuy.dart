import 'package:flutter/material.dart';

class FilterCardGroupbuy extends StatefulWidget {
  const FilterCardGroupbuy({super.key});

  @override
  State<FilterCardGroupbuy> createState() => _FilterCardGroupbuyState();
}

class _FilterCardGroupbuyState extends State<FilterCardGroupbuy> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        right: 20,
        left: 20,
        top: 16,
        bottom: 28,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(25, 0, 0, 0),
              offset: Offset(0, 10),
              blurRadius: 15,
              spreadRadius: -3,
            ),
            BoxShadow(
              color: Color.fromARGB(25, 0, 0, 0),
              offset: Offset(0, 4),
              blurRadius: 6,
              spreadRadius: -4,
            ),
          ]),
      child: Row(children: [
        // Filters button
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 18,
          ),
          margin: EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(25, 0, 0, 0),
                offset: Offset(0, 4),
                blurRadius: 6,
                spreadRadius: -1,
              ),
              BoxShadow(
                color: Color.fromARGB(25, 0, 0, 0),
                offset: Offset(0, 2),
                blurRadius: 4,
                spreadRadius: -2,
              ),
            ],
            border: Border.all(
              color: Color(0xff96F7E4),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.tune,
                size: 16,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "Filters",
                style: TextStyle(
                  color: Color(0xff00786F),
                ),
              ),
            ],
          ),
        ),

        //Filter option row
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                //tags
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff00B8DB),
                          Color(0xff009689),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(80, 0, 187, 167),
                          offset: Offset(0, 4),
                          blurRadius: 6,
                          spreadRadius: -1,
                        ),
                        BoxShadow(
                          color: Color.fromARGB(80, 0, 187, 167),
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          spreadRadius: -2,
                        ),
                      ]),
                  child: Text(
                    "All",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Color(0xffE5E7EB),
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(25, 0, 0, 0),
                          offset: Offset(0, 4),
                          blurRadius: 6,
                          spreadRadius: -1,
                        ),
                        BoxShadow(
                          color: Color.fromARGB(25, 0, 0, 0),
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          spreadRadius: -2,
                        ),
                      ]),
                  child: Text(
                    "Electronics",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Color(0xffE5E7EB),
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(25, 0, 0, 0),
                          offset: Offset(0, 4),
                          blurRadius: 6,
                          spreadRadius: -1,
                        ),
                        BoxShadow(
                          color: Color.fromARGB(25, 0, 0, 0),
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          spreadRadius: -2,
                        ),
                      ]),
                  child: Text(
                    "Fashion",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Color(0xffE5E7EB),
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(25, 0, 0, 0),
                          offset: Offset(0, 4),
                          blurRadius: 6,
                          spreadRadius: -1,
                        ),
                        BoxShadow(
                          color: Color.fromARGB(25, 0, 0, 0),
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          spreadRadius: -2,
                        ),
                      ]),
                  child: Text(
                    "Groceries",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Color(0xffE5E7EB),
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(25, 0, 0, 0),
                          offset: Offset(0, 4),
                          blurRadius: 6,
                          spreadRadius: -1,
                        ),
                        BoxShadow(
                          color: Color.fromARGB(25, 0, 0, 0),
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          spreadRadius: -2,
                        ),
                      ]),
                  child: Text(
                    "Health",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
