import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

const PADDING_CONTENT_HORIZONTAL = 16.0;
const SIZE_ARROW_BACK_ICON = 24.0;

class AppBarHeadingWidget extends StatelessWidget {
  final String title;

  const AppBarHeadingWidget({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: SvgPicture.asset(
              SVG_ASSETS_PATH + 'icon_arrow_back.svg',
              width: SIZE_ARROW_BACK_ICON,
              height: SIZE_ARROW_BACK_ICON,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 25),
                child: Text(
                  'Thông tin sản phẩm',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    color: Colors.white,
                    fontSize: FONT_EX_LARGE,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
