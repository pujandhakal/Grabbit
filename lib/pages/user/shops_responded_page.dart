import 'package:flutter/material.dart';
import 'package:grabbit/util/already_requested_product_card.dart';
import 'package:grabbit/util/response_filter_card.dart';
import 'package:grabbit/util/shops_responded_list_card.dart';

class ShopsRespondedPage extends StatefulWidget {
  const ShopsRespondedPage({super.key});

  @override
  State<ShopsRespondedPage> createState() => _ShopsRespondedPageState();
}

class _ShopsRespondedPageState extends State<ShopsRespondedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.withValues(alpha: 0.5),
        automaticallyImplyLeading: false,
        leading: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.chevron_left),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Responses",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Color(0xff00C950),
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  "3 shops have responded",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xff4A5565),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              //pre-request card
              AlreadyRequestedProductCard(),
              SizedBox(
                height: 16,
              ),

              //two filter
              ResponseFilterCard(),

              SizedBox(
                height: 16,
              ),

              //list of shops responded
              ShopsRespondedListCard(),
            ],
          ),
        ),
      ),
    );
  }
}
