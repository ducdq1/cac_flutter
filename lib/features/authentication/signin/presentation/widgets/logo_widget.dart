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
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            shadowColor: Colors.indigo.withOpacity(0.5),
            elevation: 30,
            borderOnForeground: true,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Image.asset(
                IMAGE_ASSETS_PATH + 'cac_logo_new.png',
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
            ),
          )
        ],
      ),
    );
  }
}
