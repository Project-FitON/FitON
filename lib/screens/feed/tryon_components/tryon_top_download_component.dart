import 'package:flutter/material.dart';

class TryOnTopDownloadComponent extends StatelessWidget {
  final double width;
  final double height;

  const TryOnTopDownloadComponent({
    Key? key,
    this.width = 75,
    this.height = 77,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Download Button
          Container(
            width: 30,
            height: 29,
            child: Image.asset('assets/images/feed/download.png',fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}

