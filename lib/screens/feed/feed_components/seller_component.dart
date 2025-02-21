import 'package:flutter/material.dart';

class SellerComponent extends StatelessWidget {
  final String profileImage;
  final String name;
  final String followers;
  final VoidCallback onTap; // Callback function to handle tap action

  const SellerComponent({
    Key? key,
    this.profileImage = 'assets/images/feed/profile.jpg',
    this.name = 'Fashion',
    this.followers = '1k Followers',
    required this.onTap, // Required parameter for the onTap callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Trigger the onTap action when clicked
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: Image.asset(profileImage).image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 8), // spacing between image and text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  followers,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
