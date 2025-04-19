import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget buildGameImage({
  required String imageUrl,
  required String title,
  double? height,
  double? width,
  BoxFit fit = BoxFit.cover,
}) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    height: height,
    width: width,
    fit: fit,
    placeholder: (context, url) => _buildPlaceholder(),
    errorWidget: (context, url, error) => _buildErrorWidget(title),
  );
}

Widget _buildPlaceholder() {
  return Container(
    color: Colors.grey[300],
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 8),
          Text('Loading...', style: TextStyle(fontSize: 12))
        ],
      ),
    ),
  );
}

Widget _buildErrorWidget(String title) {
  return Container(
    color: Colors.grey[200],
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, size: 40, color: Colors.grey[500]),
          SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}
