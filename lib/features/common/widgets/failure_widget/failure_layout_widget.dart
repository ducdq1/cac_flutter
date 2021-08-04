import 'package:flutter/material.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
class FailureWidget extends StatelessWidget {
  final String message;
  final Function onPressed;
  final String labelButton;
  final Widget body;
  const FailureWidget(
      {Key key, this.message, this.onPressed, this.labelButton, this.body})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (message != null) {
      Fluttertoast.showToast(msg: message);
    }
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: Center(
        child: Column(
          children: [
            // Image.asset(
            //   IMAGE_ASSETS_PATH + "icon_none.png",
            //   height: 128,
            //   width: 160,
            // ),
            SvgPicture.asset(
              SVG_ASSETS_PATH + 'icon_none.svg',
              fit: BoxFit.scaleDown,
              // width: 24,
              // height: 24,
            ),
            SizedBox(
              height: 25,
            ),
            body,
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}

class SubmitButon extends StatelessWidget {
  final String label;
  final Function onPressed;
  const SubmitButon({Key key, this.onPressed, this.label}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 142,
        child: SizedBox(
          width: double.infinity,
          height: 44,
          child: OutlineButton(
            disabledBorderColor: DISABLE_COLOR,
            disabledTextColor: DISABLE_TEXT_COLOR,
            onPressed: onPressed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36),
            ),
            borderSide: BorderSide(color: PRIMARY_COLOR, width: 0.8),
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: FONT_MIDDLE,
                color: PRIMARY_COLOR,
              ),
            ),
          ),
        ));
  }
}
