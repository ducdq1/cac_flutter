import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

abstract class OnLoadingDialogPopListener {
  onPop();
}

Future showLoadingDialog(BuildContext context, String title, [State state]) {
  final alert = AlertDialog(
    content: new Row(
      children: [
        SleekCircularSlider(
          appearance: CircularSliderAppearance(
            spinnerMode: true,
            size: 40,
            customColors: CustomSliderColors(
              dotColor: PRIMARY_COLOR,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 7),
          child: Text(
            title,
            style: GoogleFonts.inter(
              color: SECONDARY_TEXT_COLOR,
              fontSize: FONT_SMALL,
            ),
          ),
        ),
      ],
    ),
  );
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          if (state != null) {
            try {
              (state as OnLoadingDialogPopListener).onPop();
            } catch (e) {
              print(e);
              throw e;
            }
          }
          return true;
        },
        child: alert,
      );
    },
  );
}
