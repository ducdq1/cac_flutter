import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class SearchFormFieldWidget extends StatefulWidget {
  SearchFormFieldWidget(
      {@required this.isSearch,
      @required this.isShowClearSearch,
      @required this.searchController,
      @required this.searchFocus,
      @required this.onChanged,
      @required this.onEditingComplete,
        this.onClear});

  bool isSearch;
  bool isShowClearSearch;
  TextEditingController searchController;
  FocusNode searchFocus;
  Function onChanged;
  Function onEditingComplete;
  Function onClear;
  @override
  State<SearchFormFieldWidget> createState() => _SearchFormFieldWidgetState();
}

class _SearchFormFieldWidgetState extends State<SearchFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 40,
          child: TextFormField(
              onTap: () {
                setState(() {
                  widget.isSearch = true;
                  widget.isShowClearSearch =
                      widget.searchController.text.isNotEmpty ? true : false;
                });
              },
              focusNode: widget.searchFocus,
              onChanged: widget.onChanged,
              onEditingComplete: widget.onEditingComplete,
              textInputAction: TextInputAction.search,
              onFieldSubmitted: (value) =>
                  FocusScope.of(context).requestFocus(FocusNode()),
              controller: widget.searchController,
              style: GoogleFonts.inter(
                  color: Color.fromRGBO(255, 255, 255, 0.6),
                  fontSize: FONT_EX_SMALL,
                  fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.6),
                    fontSize: FONT_EX_SMALL,
                    fontWeight: FontWeight.w600),
                hintText: 'B???n c???n t??m g?? n??o ?' ,
                focusColor: Color.fromRGBO(0, 0, 0, 0.25),
                filled: true,
                fillColor: Color.fromRGBO(0, 0, 0, 0.25),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color.fromRGBO(255, 255, 255, 0.6),
                ),
                contentPadding: EdgeInsets.fromLTRB(10, 0, 30, 0),
                labelStyle: GoogleFonts.inter(
                    color: Color.fromRGBO(255, 255, 255, 0.6),
                    fontSize: FONT_EX_SMALL,
                    fontWeight: FontWeight.w600),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(48.0),
                    borderSide: BorderSide(
                        color: Color.fromRGBO(0, 0, 0, 0.25), width: 0)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(48.0),
                    borderSide: BorderSide(
                        color: Color.fromRGBO(0, 0, 0, 0.25), width: 0)),
              )),
        ),
        widget.isShowClearSearch
            ? Positioned(
          right: 0,

              child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 7, 10, 0),
                  child: InkWell(
                    onTap: () {
                      widget.searchController.clear();
                      widget.onClear();
                      setState(() {
                        widget.isShowClearSearch = false;
                      });
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SvgPicture.asset(
                        SVG_ASSETS_PATH + 'icon_clear.svg',
                        height: 20,
                        width: 20,
                      ),
                    ),
                  )),
            )
            : Text('')
      ],
    );
  }
}

void changeFocus(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}
