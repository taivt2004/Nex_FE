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

  static const homeBottomMenu = Assets.homeBottomMenu;
  static const homeActionBtn = Assets.homeActionBtn;
  static const homeCryptActives = Assets.homeCryptActives;
  static const homeTopbar = Assets.homeTopbar;
  static const homeQrscan = Assets.homeQrscan;

  static const homeCryptoActives = Assets.homeCryptActives;
  static const homeTopBar = Assets.homeTopbar;
  static const homeQrScan = Assets.homeQrscan;
}
