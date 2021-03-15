import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

const PADDING_CONTENT_HORIZONTAL = 16.0;
const SIZE_ARROW_BACK_ICON = 20.0;

class AppBarBaseWidget extends StatelessWidget implements PreferredSizeWidget {
  AppBarBaseWidget(
      {this.actions,
      this.leading,
      this.title,
      this.toolBarHeight,
      this.isTitleHeaderWidget,
      this.titleHeaderWidget,
      this.centerTitle,
      this.bottom,
      this.onPop,
      this.isShowLeading})
      : preferredSize = Size.fromHeight(toolBarHeight);
  final List<Widget> actions;
  final String title;
  final Size preferredSize;
  final double toolBarHeight;
  final bool isTitleHeaderWidget;
  final Widget titleHeaderWidget;
  final bool centerTitle;
  final Widget bottom;
  final Function onPop;
  final Widget leading;
  final bool isShowLeading;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: bottom,
      actions: actions ?? actions,
      backgroundColor: Colors.transparent,
      leading: isShowLeading
          ? leading != null
              ? leading
              : IconButton(
                  icon: SvgPicture.asset(
                    SVG_ASSETS_PATH + 'icon_arrow_back.svg',
                    width: SIZE_ARROW_BACK_ICON,
                    height: SIZE_ARROW_BACK_ICON,
                  ),
                  onPressed: () {
                    if (onPop == null) {
                      Navigator.pop(context);
                    } else {
                      onPop();
                    }
                  },
                )
          : SizedBox(),
      toolbarHeight: toolBarHeight ?? toolBarHeight,
      centerTitle: centerTitle,
      elevation: 0,
      title: isTitleHeaderWidget
          ? titleHeaderWidget
          : Text(
              title,
              style: GoogleFonts.openSans(
                color: Colors.white,
                fontSize: FONT_EX_LARGE,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
