import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TabBarCustomWidget extends StatefulWidget {
  final TabController controller;

  TabBarCustomWidget({this.controller});
  @override
  _TabBarCustomWidgetState createState() => _TabBarCustomWidgetState();
}

class _TabBarCustomWidgetState extends State<TabBarCustomWidget> {
  final tabs = [
    trans(TITLE_INFORMATION_SCREEN),
    trans(LABEL_MEDIA_PAHT),
    trans(LABEL_COMMENT)
  ];
  int _index;

  @override
  void initState() {
    _index = widget.controller.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorColor: Colors.transparent,
      controller: widget.controller,
      onTap: (int index) {
        setState(() {
          _index = index;
        });
      },
      tabs: tabs
          .asMap()
          .map((i, element) => MapEntry(
              i,
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    i == _index
                        ? Padding(
                            padding: const EdgeInsets.only(right: 3),
                            child: Icon(
                              Icons.circle,
                              color: Colors.white,
                              size: 6,
                            ),
                          )
                        : SizedBox(),
                    Text(
                      tabs[i].toUpperCase(),
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: FONT_SMALL,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )))
          .values
          .toList(),
    );
  }
}
