import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

typedef OnTapImage = void Function();

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    required this.url,
    this.boxFit = BoxFit.fill,
    this.width,
    this.height,
    super.key,
  });
  final String url;
  final BoxFit boxFit;

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: boxFit,
      width: width,
      height: height,
      imageUrl: url,
      // placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
