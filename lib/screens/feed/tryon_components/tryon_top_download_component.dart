import 'package:flutter/material.dart';

class TryOnTopDownloadComponent extends StatelessWidget {
  const TryOnTopDownloadComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset('assets/images/feed/download.png'),
      onPressed: () {
        print("Download button clicked! (No functionality)");
      },
    );
  }
}
