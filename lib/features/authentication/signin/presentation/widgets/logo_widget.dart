import 'package:citizen_app/core/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // child: SvgPicture.asset(
      //   SVG_ASSETS_PATH + 'citizens_logo.svg'
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
              IMAGE_ASSETS_PATH + 'icon_menu_bds.png',
                  width: 80,
                  height: 90,
          )
        ],
      ),
    );
  }
}