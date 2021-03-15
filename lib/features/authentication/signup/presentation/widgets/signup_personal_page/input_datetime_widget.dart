import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/validate/validate.dart';
import 'package:citizen_app/features/common/widgets/inputs/input_decorator_custom.dart';
import 'package:citizen_app/features/common/widgets/inputs/text_form_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class InputDatetimeWidget extends StatefulWidget {
  final String hintText;
  final List<Validate> validates;
  final double scrollPadding;
  final TextEditingController controller;

  InputDatetimeWidget(
      {this.hintText,
      this.validates,
      this.scrollPadding = 200.0,
      this.controller});
  @override
  _InputDatetimeWidgetState createState() => _InputDatetimeWidgetState();
}

class _InputDatetimeWidgetState extends State<InputDatetimeWidget> {
  DateTime _selectedDate = DateTime.now();
  FocusNode _focusNode = FocusNode();
  // TextEditingController _controller = TextEditingController();
  bool _isFocus = false;

  Future _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(_selectedDate.year - 150),
      lastDate: DateTime(_selectedDate.year + 10),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      widget.controller.text = '${picked.day}/${picked.month}/${picked.year}';
    }
  }

  @override
  void initState() {
    if (widget.controller.text.isNotEmpty) {
      final date = widget.controller.text.split('/');
      _selectedDate = DateTime(
        int.parse(date.last),
        int.parse(date[1]),
        int.parse(date.first),
      );
    }
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
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
        controller: widget.controller,
        readOnly: true,
        focusNode: _focusNode,
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
        onTap: () {
          _selectDate(context);
        },
        style: GoogleFonts.inter(
          fontSize: FONT_EX_MIDDLE,
          color: PRIMARY_TEXT_COLOR,
          fontWeight: FontWeight.normal,
        ),
        scrollPadding: EdgeInsets.only(bottom: widget.scrollPadding),
        decoration: CInputDecoration(
          helperText: '',
          isMandate: true,
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
          labelText: widget.hintText,
          labelStyle: GoogleFonts.inter(
            fontSize: FONT_SMALL,
            color: _isFocus ? PRIMARY_TEXT_COLOR : SECONDARY_TEXT_COLOR,
            fontWeight: _isFocus ? FontWeight.bold : FontWeight.normal,
          ),
          suffixIcon: Material(
            color: Colors.transparent,
            child: InkWell(
              // onTap: () {
              //   _selectDate(context);
              // },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 20,
                height: 20,
                child: SvgPicture.asset(
                  SVG_ASSETS_PATH + 'icon_date_picker.svg',
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
