import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/widgets/buttons/outline_custom_button.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class FingerPrintDialogWidget extends StatefulWidget {
  @override
  _FingerPrintDialogWidgetState createState() =>
      _FingerPrintDialogWidgetState();
}

class _FingerPrintDialogWidgetState extends State<FingerPrintDialogWidget>
    with SingleTickerProviderStateMixin
    implements OnButtonClickListener {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.linearToEaseOut);
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20.0),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    trans(FINGERPRINT_SETTINGS),
                    style: GoogleFonts.inter(
                      fontSize: FONT_MIDDLE,
                      color: PRIMARY_TEXT_COLOR,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 32),
                Center(
                  child: SvgPicture.asset(SVG_ASSETS_PATH + 'fingerprint.svg'),
                ),
                SizedBox(height: 28),
                Text(
                  trans(REQUIRE_FINGERPRINT_SENSOR),
                  style: GoogleFonts.inter(
                    fontSize: FONT_MIDDLE,
                    color: PRIMARY_TEXT_COLOR,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                OutlineCustomButton(label: trans(CANCEL), ctx: this)
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  onClick(String id) {
    Navigator.of(context).pop();
  }
}
