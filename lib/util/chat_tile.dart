import 'package:flutter/material.dart';

class ChatTile extends StatefulWidget {
  final String shopName;
  final String message;
  final String timeStamp;
  final String imageLink;
  final bool isUnread;
  const ChatTile({
    super.key,
    required this.shopName,
    required this.message,
    required this.timeStamp,
    required this.imageLink,
    this.isUnread = true,
  });

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        title: Text(
          widget.shopName,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        subtitle: Text(widget.message),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.timeStamp,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xff99A1AF),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            widget.isUnread
                ? Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Color(0xff00B8DB),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.35),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          )
                        ]),
                    child: Text(
                      "2",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(widget.imageLink),
              // "https://picsum.photos/100"
            ),
            Positioned(
              top: 32,
              left: 30,
              child: Container(
                height: 16,
                width: 16,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
