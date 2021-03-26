import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputWithTitleWidget extends StatefulWidget {
  InputWithTitleWidget(
      {this.isRequired, this.textFieldWidget, this.titleInput,this.paddingTop = 10,this.fontSize=FONT_EX_LARGE});
  final String titleInput;
  final bool isRequired;
  final Widget textFieldWidget;
  final double paddingTop;
  final double fontSize;
  @override
  State<InputWithTitleWidget> createState() => _InputWithTitleWidgetState();
}

class _InputWithTitleWidgetState extends State<InputWithTitleWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0),
            child: Row(
              children: [
                Text(
                  widget.titleInput,
                  style: GoogleFonts.inter(
                      color: PRIMARY_TEXT_COLOR,
                      fontSize:  widget.fontSize,
                      fontWeight: FontWeight.bold),
                ),
                widget.isRequired
                    ? Text(
                        '*',
                        style: GoogleFonts.inter(
                            color: Colors.red,
                            fontSize:  widget.fontSize,
                            fontWeight: FontWeight.bold),
                      )
                    : SizedBox(),
              ],
            )),
        SizedBox(
          height: widget.paddingTop,
        ),
        widget.textFieldWidget
      ],
    );
  }
}
