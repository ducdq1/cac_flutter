import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/validate/validate.dart';
import 'package:citizen_app/features/common/widgets/inputs/text_form_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'input_decorator_custom.dart';
import 'text_field_custom.dart';

class InputValidateCustomWidget extends StatefulWidget {
  final String label;
  final bool isRequired;
  final FocusNode focusNode;
  final Function(FocusNode) focusError;
  final TextInputType textInputType;
  final TextEditingController controller;
  final bool obscureText;
  final List<Validate> validates;
  final double scrollPadding;
  final bool readOnly;
  final String defaultValue;
  final Function focusAction;
  final TextInputAction textInputAction;
  final bool scrollPaddingForTop;
  final Function onEditingComplete;
  final int limitLength;
  final bool isShowBorder;
  final String hintText;

  InputValidateCustomWidget(
      {this.label,
      this.isRequired = true,
      @required this.focusNode,
      @required this.controller,
      this.scrollPadding = 200.0,
      this.obscureText = false,
      this.textInputType = TextInputType.text,
      this.validates,
      this.readOnly = false,
      this.defaultValue,
      this.scrollPaddingForTop = false,
      @required this.focusError,
      this.textInputAction = TextInputAction.next,
      this.focusAction,
      this.limitLength,
      this.onEditingComplete,
      this.isShowBorder = true,
      this.hintText = ''});

  @override
  _InputValidateCustomWidgetState createState() =>
      _InputValidateCustomWidgetState();
}

class _InputValidateCustomWidgetState extends State<InputValidateCustomWidget> {
  bool _isVisible = false;
  bool _obscureText = false;
  bool _isFocus = false;

  @override
  void initState() {
    if (widget.controller.text.isEmpty) {
      widget.controller.text = widget.defaultValue ?? '';
    }
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
      child: TextFormFieldCustom(
        onEditingComplete: widget.onEditingComplete,
        obscureText: _obscureText,
        controller: widget.controller,
        readOnly: widget.readOnly,
        focusNode: widget.focusNode,
        textInputAction: widget.textInputAction,

        style: GoogleFonts.inter(
          fontSize: FONT_MIDDLE,
          color: PRIMARY_TEXT_COLOR,
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(widget.limitLength),
          widget.textInputType == TextInputType.number
              ? FilteringTextInputFormatter.digitsOnly
              : FilteringTextInputFormatter.singleLineFormatter
        ],
        onFieldSubmitted: (String value) {
          widget.focusAction();
        },
        validator: (String value) {
          if (widget.validates != null) {
            for (var validate in widget.validates) {
              if (validate.validate(value) != null) {
                widget.focusError(widget.focusNode);
                return validate.validate(value);
              }
            }
          }
          return null;
        },
        keyboardType: widget.textInputType,
        cursorColor: PRIMARY_COLOR,
        cursorWidth: 0.8,
        scrollPadding: widget.scrollPaddingForTop
            ? EdgeInsets.only(top: widget.scrollPadding)
            : EdgeInsets.only(bottom: widget.scrollPadding),
        decoration: CInputDecoration(
          counter: Offstage(),
          isMandate: widget.isRequired,
          labelText: widget.label,
          helperText: '',
          hintText: widget.hintText,
          hintStyle: GoogleFonts.inter(
            fontSize: FONT_SMALL,
            color: SECONDARY_TEXT_COLOR,
            fontWeight: FontWeight.normal,
          ),
          labelStyle: GoogleFonts.inter(
            fontSize: FONT_SMALL,
            color: _isFocus ? PRIMARY_TEXT_COLOR : SECONDARY_TEXT_COLOR,
            fontWeight: _isFocus ? FontWeight.bold : FontWeight.normal,
          ),
          errorStyle: GoogleFonts.inter(
              color: Colors.red ,fontSize: FONT_SMALL),
          border: widget.isShowBorder
              ? OutlineInputBorder(
                  borderSide: BorderSide(color: PRIMARY_COLOR, width: 0.6),
                  borderRadius: BorderRadius.circular(8),
                )
              : UnderlineInputBorder(borderSide: BorderSide(color: BORDER_COLOR, width: 0.4)),
          enabledBorder: widget.isShowBorder
              ? OutlineInputBorder(
                  borderSide: BorderSide(color: PRIMARY_COLOR, width: 0.6),
                  borderRadius: BorderRadius.circular(8),
                )
              : UnderlineInputBorder(borderSide: BorderSide(color: BORDER_COLOR, width: 0.4)),
          focusedBorder: widget.isShowBorder
              ? OutlineInputBorder(
                  borderSide: BorderSide(color: PRIMARY_COLOR, width: 0.6),
                  borderRadius: BorderRadius.circular(8),
                )
              : UnderlineInputBorder(
                  borderSide: BorderSide(color: PRIMARY_COLOR, width: 1),
                ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (_isVisible && widget.obscureText == true)
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
                              !_obscureText
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
        },
      ),
    );
  }

  @override
  void dispose() {
    widget.focusNode.dispose();
    super.dispose();
  }
}
