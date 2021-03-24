
import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FrameLabelWidget extends StatefulWidget {
  final String label;
  final Widget child;
  final EdgeInsets padding;

  FrameLabelWidget({@required this.label, @required this.child, this.padding});

  @override
  _FrameLabelWidgetState createState() => _FrameLabelWidgetState();
}

class _FrameLabelWidgetState extends State<FrameLabelWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 8),
            padding: widget.padding ?? EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Color(0xffB6B6B6),
                width: 0.5,
              ),
            ),
            child: widget.child,
          ),
          Positioned(
            left: 18,
            top: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                widget.label,
                style: GoogleFonts.roboto(
                  fontSize: FONT_SMALL,
                  color: PRIMARY_TEXT_COLOR,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
