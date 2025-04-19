import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:developer' as developer;

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      maxHeightDiskCache: 1000,
      memCacheHeight: 1000,
      fadeInDuration: const Duration(milliseconds: 500),
      httpHeaders: {
        'Accept': 'image/jpeg,image/png,image/*',
        'User-Agent': 'Mozilla/5.0 (Android 10; Mobile)',
      },
      placeholder:
          (_, __) => Container(
            color: Colors.grey[850],
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),
          ),
      errorWidget: (_, url, error) {
        developer.log('Image load error: $url - $error');
        return Container(
          color: Colors.grey[850],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 30),
              const SizedBox(height: 8),
              Text(
                'Image load failed\n${error.toString().split('\n').first}',
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
