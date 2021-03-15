// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldWidget extends StatefulWidget {
  TextFieldWidget(
      {@required this.controller,
      @required this.textInputType,
      this.onTap,
      this.icon,
      this.obscureText,
      this.suffixIcon,
      this.focusNode,
      this.onFieldSubmitted,
      @required this.isDone,
      this.maxLength,
      this.validator,
      @required this.color,
      @required this.isShowSuffixIcon,
      this.onChange,
      this.errorText,
      this.key,
      this.maxLines,
      this.hintText});
  final Key key;
  final TextEditingController controller;
  final TextInputType textInputType;
  final Icon icon;
  final bool obscureText;
  final Widget suffixIcon;
  final FocusNode focusNode;
  final Function onFieldSubmitted;
  final bool isDone;
  final int maxLength;
  final Function validator;
  final Color color;
  final Function onTap;
  final bool isShowSuffixIcon;
  final Function onChange;
  final String errorText;
  final int maxLines;
  final String hintText;
  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.key,
      onChanged: widget.onChange,
      onTap: widget.onTap,
      cursorColor: Colors.blue,
      obscuringCharacter: "*",
      focusNode: widget.focusNode,
      onFieldSubmitted: widget.onFieldSubmitted,
      textInputAction:
          widget.isDone ? TextInputAction.done : TextInputAction.next,
      obscureText: widget.obscureText == null ? false : widget.obscureText,
      style: GoogleFonts.inter(fontSize: FONT_MIDDLE, color: Color(0xff617882)),
      maxLength: widget.maxLength == null ? null : widget.maxLength,
      maxLines: widget.maxLines == null ? 1 : widget.maxLines,
      decoration: InputDecoration(
          hintText: widget.hintText,
          border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(8.0),
              ),
              borderSide: BorderSide(color: Color(0xffC7D0DB), width: 1)),
          errorText: widget.errorText,
          counter: Offstage(),
          suffixIcon: widget.isShowSuffixIcon
              ? Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: widget.suffixIcon == null
                      ? Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              widget.controller.clear();
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
                      : widget.suffixIcon,
                )
              : null,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),
              borderSide: BorderSide(color: Color(0xffC7D0DB), width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),
              borderSide: BorderSide(color: Color(0xffC7D0DB), width: 1))),
      keyboardType: widget.textInputType,
      validator: widget.validator,
      controller: widget.controller,
    );
  }
}

void changeFocus(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}
