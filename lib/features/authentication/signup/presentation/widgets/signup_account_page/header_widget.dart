import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeaderWidget extends StatelessWidget {
  final String svgIcon;

  HeaderWidget({this.svgIcon});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SvgPicture.asset(
          SVG_ASSETS_PATH + (svgIcon ?? 'icon_profile.svg'),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
