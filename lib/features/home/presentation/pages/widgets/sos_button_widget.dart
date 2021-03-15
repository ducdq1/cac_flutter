import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'water_ripple_button_widget.dart';

class SOSButtonWidget extends StatefulWidget {
  @override
  _SOSButtonWidgetState createState() => _SOSButtonWidgetState();
}

class _SOSButtonWidgetState extends State<SOSButtonWidget>
    with TickerProviderStateMixin {
  double _sizeSos = 50;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: Container(
            width: 96,
            height: 96,
            child: WaterRippleButtonWidget(color: Colors.red, count: 6),
          ),
        ),
        GestureDetector(
          onTapDown: (TapDownDetails detail) {
            setState(() {
              _sizeSos = 45;
            });
          },
          onTapUp: (TapUpDetails detail) async {
            setState(() {
              _sizeSos = 50;
            });
            await Future.delayed(Duration(milliseconds: 200));
            await Navigator.pushNamed(context, '/SOS');
          },
          child: Center(
            child: AnimatedSize(
              curve: Curves.easeIn,
              vsync: this,
              duration: Duration(seconds: 1),
              child: Container(
                height: _sizeSos,
                width: _sizeSos,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(64),
                  color: Colors.red,
                ),
                child: Center(
                  child: Text(
                    'sos'.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: FONT_LARGE,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
