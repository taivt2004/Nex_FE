import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nexpaylab/endpoint.dart';
import 'package:nexpaylab/gen/assets.gen.dart';
import 'package:nexpaylab/share/ui/widget/custom_network_image.dart';

Widget loadImage(
  String imagePath, {
  BoxFit boxFit = BoxFit.cover,
  double? width,
  double? height,
}) {
  if (imagePath.startsWith('https://')) {
    return loadNetworkImage(
      imagePath,
      boxFit: boxFit,
      width: width,
      height: height,
    );
  }
  return Image.file(
    File(imagePath),
    fit: boxFit,
    width: width,
    height: height,
    alignment: Alignment.center,
  );
}

Widget loadNetworkImage(
  String imageName, {
  BoxFit boxFit = BoxFit.cover,
  double? width,
  double? height,
}) {
  if (imageName.startsWith('http://') || imageName.startsWith('https://')) {
    return CustomNetworkImage(url: imageName, width: width, height: height);
  }
  var imagePath = imageName;
  if (!imageName.startsWith('/')) {
    imagePath = '/$imageName';
  }
  return CustomNetworkImage(
    url: '${Endpoint.cdnUrl}$imagePath',
    width: width,
    height: height,
  );
}

extension SvgImageExt on SvgGenImage {
  Widget load({double? width, double? height, Color? color}) {
    return svg(
      // package: Strings.packageName,
      width: width,
      height: height,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
    );
  }
}

extension ImageExt on AssetGenImage {
  Widget load({double? width, double? height, Color? color}) {
    return image(
      // package: Strings.packageName,
      width: width,
      height: height,
      color: color,
    );
  }
}

class AppAssets {
  const AppAssets._();

  static const fonts = Assets.fonts;
  static const googleFonts = Assets.googleFonts;
  static const icons = Assets.icons;
  static const images = Assets.images;

  static const homeBottomMenu = Assets.iconsHomeBottomMenu;
  static const homeActionBtn = Assets.iconsHomeActionBtn;
  static const homeCryptActives = Assets.iconsHomeCryptActives;
  static const homeTopbar = Assets.iconsHomeTopbar;
  static const homeQrscan = Assets.iconsHomeQrscan;

  static const homeCryptoActives = Assets.iconsHomeCryptActives;
  static const homeQrScan = Assets.iconsHomeQrscan;
}
