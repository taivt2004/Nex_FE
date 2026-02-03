import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nexpaylab/app/network/endpoints.dart';
import 'package:nexpaylab/gen/assets.gen.dart';
import 'package:nexpaylab/shared/ui/widget/custom_network_image.dart';

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

  static $AssetsIconsHomeBottomMenuGen get homeBottomMenu =>
      Assets.icons.home.bottomMenu;

  static $AssetsIconsHomeActionBtnGen get homeActionBtn =>
      Assets.icons.home.actionBtn;

  static $AssetsIconsHomeCryptActivesGen get homeCryptActives =>
      Assets.icons.home.cryptActives;

  static $AssetsIconsHomeTopbarGen get homeTopbar =>
      Assets.icons.home.topbar;

  static $AssetsIconsHomeQrscanGen get homeQrscan =>
      Assets.icons.home.qrscan;

  static $AssetsIconsHomeCryptActivesGen get homeCryptoActives =>
      Assets.icons.home.cryptActives;

  static $AssetsIconsHomeQrscanGen get homeQrScan =>
      Assets.icons.home.qrscan;
}
