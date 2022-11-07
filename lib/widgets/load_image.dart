import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zpass/util/image_utils.dart';

/// Load image from assets/url
class LoadImage extends StatelessWidget {
  
  const LoadImage(this.image, {
    super.key,
    this.width, 
    this.height,
    this.fit = BoxFit.cover, 
    this.format = ImageFormat.png,
    this.holderImg = 'ic_placeholder',
    this.cacheWidth,
    this.cacheHeight,
    this.holderError,
  });
  
  final String image;
  final double? width;
  final double? height;
  final BoxFit fit;
  final ImageFormat format;
  final String holderImg;
  final int? cacheWidth;
  final int? cacheHeight;
  final Widget? holderError;
  
  @override
  Widget build(BuildContext context) {

    if (image.isEmpty || image.startsWith('http')) {
      final Widget holder = LoadAssetImage(holderImg, height: height, width: width, fit: fit);
      return CachedNetworkImage(
        imageUrl: image,
        placeholder: (_, __) => holder,
        errorWidget: (_, __, dynamic error) => holderError ?? holder,
        width: width,
        height: height,
        fit: fit,
        memCacheWidth: cacheWidth,
        memCacheHeight: cacheHeight,
      );
    } else {
      return LoadAssetImage(image,
        height: height,
        width: width,
        fit: fit,
        format: format,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
      );
    }
  }
}

/// Assets Image
class LoadAssetImage extends StatelessWidget {
  
  const LoadAssetImage(this.image, {
    super.key,
    this.width,
    this.height, 
    this.cacheWidth,
    this.cacheHeight,
    this.fit,
    this.format = ImageFormat.png,
    this.color
  });

  final String image;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final int? cacheHeight;
  final BoxFit? fit;
  final ImageFormat format;
  final Color? color;
  
  @override
  Widget build(BuildContext context) {

    return Image.asset(
      ImageUtils.getImgPath(image, format: format),
      height: height,
      width: width,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      fit: fit,
      color: color,
      excludeFromSemantics: true,
    );
  }
}
