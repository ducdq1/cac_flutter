import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/validate/validate.dart';
import 'package:citizen_app/features/common/widgets/inputs/input_decorator_custom.dart';
import 'package:citizen_app/features/common/widgets/inputs/text_form_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class OnInputAddressClickListener {
  onClick(String id);
}

class InputAddressWidget extends StatefulWidget {
  final FocusNode focusNode;
  final Function focusError;
  final TextEditingController controller;
  final String label;
  final bool isRequired;
  final List<Validate> validates;
  final double scrollPadding;
  final bool scrollPaddingForTop;
  final String id;
  final State ctx;
  String hint;
  final Key key;

  InputAddressWidget({
    this.controller,
    this.focusNode,
    this.label,
    this.scrollPaddingForTop = false,
    this.isRequired = true,
    this.ctx,
    this.validates,
    this.scrollPadding = 150,
    @required this.id,
    this.focusError,
    this.hint,
    this.key,
  });
  @override
  _InputAddressWidgetState createState() => _InputAddressWidgetState();
}

class _InputAddressWidgetState extends State<InputAddressWidget> {
  bool _readOnly = true;

  @override
  void initState() {
    widget.hint = trans(SELECT_);
    widget.controller.text = widget.hint;
    widget.controller.addListener(() {
      if (widget.controller.text.isEmpty) {
        widget.controller.text = widget.hint;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: TextFormFieldCustom(
        controller: widget.controller,
        readOnly: _readOnly,
        onTap: () {
          (widget.ctx as OnInputAddressClickListener).onClick(widget.id);
        },
        focusNode: widget.focusNode,
        style: GoogleFonts.inter(
          fontSize: FONT_EX_MIDDLE,
          color: PRIMARY_TEXT_COLOR,
        ),
        validator: (String value) {
          if (widget.validates != null) {
            if (value == widget.hint) {
              widget.focusError(widget.focusNode);
              return trans(LABEL_REQUIRED_FIELD_SELECTED);
            }
            for (var validate in widget.validates) {
              if (validate.validate(value) != null) {
                widget.focusError(widget.focusNode);
                return validate.validate(value);
              }
            }
          }
          return null;
        },
        scrollPadding: widget.scrollPaddingForTop
            ? EdgeInsets.only(top: widget.scrollPadding)
            : EdgeInsets.only(bottom: widget.scrollPadding),
        decoration: CInputDecoration(
          isMandate: widget.isRequired,
          labelText: widget.label,
          helperText: '',
          labelStyle: GoogleFonts.inter(
            fontSize: FONT_SMALL,
            color: PRIMARY_TEXT_COLOR,
            fontWeight: FontWeight.bold,
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
          suffixIcon: Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xff617882),
            size: 16,
          ),
        ),
      ),
    );
  }
}
