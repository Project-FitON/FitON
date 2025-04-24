import 'package:flutter/material.dart';
import 'package:flutter_media_downloader/flutter_media_downloader.dart';

class TryOnTopDownloadComponent extends StatelessWidget {
  final double width;
  final double height;
  final String currentImageUrl;

  const TryOnTopDownloadComponent({
    super.key,
    this.width = 75,
    this.height = 77,
    required this.currentImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final mediaDownloader = MediaDownload();

    return SizedBox(
      width: width,
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                await mediaDownloader.downloadMedia(
                  context,
                  currentImageUrl,
                );
              },
              borderRadius: BorderRadius.circular(12),
              highlightColor: Colors.white.withOpacity(0.3),
              splashColor: Colors.white.withOpacity(0.5),
              child: SizedBox(
                width: 30,
                height: 29,
                child: Image.asset(
                  'assets/images/feed/download.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}