import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/validate/validate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class InputValidateWidget extends StatefulWidget {
  final String label;
  final bool isRequired;
  final FocusNode focusNode;
  final Function focusAction;
  final TextInputType textInputType;
  final TextEditingController controller;
  final bool obscureText;
  final List<Validate> validates;
  final double scrollPadding;
  final TextInputAction textInputAction;
  final int limitLength;
  final bool readOnly;
  InputValidateWidget({
    this.label,
    this.isRequired = true,
    @required this.focusNode,
    this.controller,
    this.validates,
    this.focusAction,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.textInputType = TextInputType.text,
    this.scrollPadding = 150,
    this.limitLength,
    this.readOnly = false
  });
  @override
  _InputValidateWidgetState createState() => _InputValidateWidgetState();
}

class _InputValidateWidgetState extends State<InputValidateWidget> {
  bool _isVisible = false;
  bool _obscureText = false;
  bool _isFocus = false;

  @override
  void initState() {
    _obscureText = widget.obscureText;
    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        _isFocus = true;
      } else {
        _isFocus = false;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: TextFormField(
        obscureText: _obscureText,
        controller: widget.controller,
        readOnly: widget.readOnly,
        focusNode: widget.focusNode,
        textInputAction: widget.textInputAction,
        style: GoogleFonts.inter(
          fontSize: FONT_EX_MIDDLE,
          color: PRIMARY_TEXT_COLOR,
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(widget.limitLength),
          widget.textInputType == TextInputType.number
              ? FilteringTextInputFormatter.digitsOnly
              : FilteringTextInputFormatter.singleLineFormatter
        ],
        validator: (String value) {
          if (widget.validates != null) {
            for (var validate in widget.validates) {
              if (validate.validate(value) != null) {
                return validate.validate(value);
              }
            }
          }
          return null;
        },
        onFieldSubmitted: (String value) {
          widget.focusAction();
        },
        keyboardType: widget.textInputType,
        cursorColor: PRIMARY_COLOR,
        cursorWidth: 0.8,
        scrollPadding: EdgeInsets.only(bottom: widget.scrollPadding),
        decoration: InputDecoration(
          labelText: widget.label,
          helperText: '',
          labelStyle: GoogleFonts.inter(
            fontSize: _isFocus ? FONT_MIDDLE : FONT_MIDDLE,
            color: _isFocus ? PRIMARY_TEXT_COLOR : SECONDARY_TEXT_COLOR,
            fontWeight: _isFocus ? FontWeight.bold : FontWeight.normal,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: BORDER_COLOR, width: 0.6),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: BORDER_COLOR, width: 0.6),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: PRIMARY_COLOR, width: 0.6),
            borderRadius: BorderRadius.circular(8),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (_isVisible && widget.obscureText == false)
                  ? Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          widget.controller.clear();
                          _isVisible = false;
                          setState(() {});
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 20,
                          height: 20,
                          child: SvgPicture.asset(
                            SVG_ASSETS_PATH + 'icon_clear.svg',
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              widget.obscureText
                  ? Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          _obscureText = !_obscureText;
                          setState(() {});
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 40,
                          height: 40,
                          child: Center(
                            child: Icon(
                              _obscureText
                                  ? Icons.remove_red_eye
                                  : Icons.visibility_off_sharp,
                              color: Color(0xff617882),
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ),
        onChanged: (String value) {
          if (value.trim().isEmpty) {
            _isVisible = false;
          } else {
            _isVisible = true;
          }
          setState(() {});
        },
      ),
    );
  }

  @override
  void dispose() {
    // widget.focusNode.dispose();
    super.dispose();
  }
}
