import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class OnInputSearchSubmitListener {
  onSubmit(String keyword);
  onChange(String keyword);
}

class InputSearchWidget extends StatefulWidget {
  final State ctx;

  InputSearchWidget({this.ctx});

  @override
  _InputSearchWidgetState createState() => _InputSearchWidgetState();
}

class _InputSearchWidgetState extends State<InputSearchWidget> {
  TextEditingController _controller;
  bool _isVisible;

  @override
  void initState() {
    _isVisible = false;
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      child: TextField(
        controller: _controller,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: PRIMARY_COLOR,
        cursorWidth: 0.8,
        style: GoogleFonts.inter(
          fontSize: FONT_EX_MIDDLE,
          color: PRIMARY_TEXT_COLOR,
        ),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top: 0, bottom: 0, right: 10),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(48),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(48),
                borderSide: BorderSide.none),
            hintStyle: GoogleFonts.inter(
              fontSize: FONT_MIDDLE,
              color: SECONDARY_TEXT_COLOR,
              fontWeight: FontWeight.normal,
            ),
            fillColor: Color(0xffEBEEF0),
            filled: true,
            hintText: trans(ENTER_KEY_WORD_TO_SEARCH),
            prefixIcon: IconButton(
              icon: SvgPicture.asset(
                SVG_ASSETS_PATH + 'icon_search.svg',
              ),
              onPressed: () {},
            ),
            suffixIcon: _isVisible
                ? Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        _controller.clear();
                        _isVisible = false;
                        (widget.ctx as OnInputSearchSubmitListener)
                            .onChange('');
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
                : SizedBox()),
        onSubmitted: (String value) {
          (widget.ctx as OnInputSearchSubmitListener).onSubmit(value);
        },
        onChanged: (String value) {
          if (value.isEmpty) {
            _isVisible = false;
          } else {
            _isVisible = true;
          }
          setState(() {});
          (widget.ctx as OnInputSearchSubmitListener).onChange(value);
        },
      ),
    );
  }
}
