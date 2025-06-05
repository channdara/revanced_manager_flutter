import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedNetworkImageWidget extends StatelessWidget {
  const CachedNetworkImageWidget({super.key, required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if ((imageUrl ?? '').isEmpty) return const SizedBox();
    return CachedNetworkImage(
      imageUrl: imageUrl ?? '',
      fit: BoxFit.cover,
    );
  }
}
