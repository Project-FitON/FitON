import 'package:flutter/material.dart';

class ProductComponent extends StatelessWidget {
  final String title;
  final double realPrice;
  final double discountPrice;
  final int discountPercentage;
  final VoidCallback onTap; // Callback function to handle button tap

  const ProductComponent({
    super.key,
    this.title = 'Long Sleeves Crop Top For Girls',
    this.realPrice = 4399,
    this.discountPrice = 5000,
    this.discountPercentage = 20,
    required this.onTap, // Pass the callback in the constructor
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Trigger the onTap action when clicked
      child: Container(
        constraints: BoxConstraints(maxWidth: 200),
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.grey[800], // Add some background color for the button
          borderRadius: BorderRadius.circular(6), // Smaller border radius
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Price row
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '${realPrice.toInt()} Rs',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${discountPrice.toInt()} Rs',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '[-$discountPercentage%]',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            // Product title
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
