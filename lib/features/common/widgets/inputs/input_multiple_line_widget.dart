import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/validate/validate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'input_decorator_custom.dart';
import 'text_form_field_custom.dart';

class InputMultipleLineWidget extends StatefulWidget {
  final String label;
  final bool isRequired;
  final FocusNode focusNode;
  final TextInputType textInputType;
  final TextEditingController controller;
  final List<Validate> validates;
  final double scrollPadding;
  final bool readOnly;
  final String defaultValue;
  final String hintText;
  final int minLines;
  final int maxLines;
  final Function focusAction;
  final Function focusError;
  final TextInputAction textInputAction;
  final TextAlignVertical textAlignVertical;

  InputMultipleLineWidget({
    this.label,
    this.isRequired = true,
    @required this.focusNode,
    @required this.controller,
    this.scrollPadding = 200.0,
    this.textInputType = TextInputType.text,
    this.validates,
    this.readOnly = false,
    this.defaultValue,
    this.maxLines = 2,
    this.minLines = 1,
    this.hintText,
    this.focusAction,
    this.focusError,
    this.textInputAction = TextInputAction.next,
    this.textAlignVertical = TextAlignVertical.center,
  });

  @override
  _InputMultipleLineWidgetState createState() =>
      _InputMultipleLineWidgetState();
}

class _InputMultipleLineWidgetState extends State<InputMultipleLineWidget> {
  bool _isVisible = false;
  bool _isFocus = false;

  @override
  void initState() {
    if (widget.controller.text.isEmpty) {
      widget.controller.text = widget.defaultValue ?? '';
    } else {
      _isVisible = true;
    }
    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        _isFocus = true;
      } else {
        _isFocus = false;
      }
      //setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormFieldCustom(
        controller: widget.controller,
        readOnly: widget.readOnly,
        focusNode: widget.focusNode,
        textInputAction: widget.textInputAction,
        minLines: widget.minLines,
        maxLines: widget.minLines,
        textAlignVertical: widget.textAlignVertical,
        keyboardType: TextInputType.multiline,
        style: GoogleFonts.inter(
          fontSize: FONT_EX_MIDDLE,
          color: PRIMARY_TEXT_COLOR,
        ),
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
        cursorColor: PRIMARY_COLOR,
        cursorWidth: 0.8,
        scrollPadding: EdgeInsets.only(bottom: widget.scrollPadding),
        decoration: CInputDecoration(
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
          suffixIcon: _isVisible
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
}
