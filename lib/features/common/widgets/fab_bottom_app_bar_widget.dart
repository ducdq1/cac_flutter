import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FABBottomAppBarItem {
  FABBottomAppBarItem({this.icon, this.text, this.iconActive});
  Widget icon;
  Widget iconActive;
  String text;
}

class FABBottomAppBarWidget extends StatefulWidget {
  FABBottomAppBarWidget({
    this.items,
    this.centerItemText,
    this.height: 70.0,
    this.iconSize: 30.0,
    this.backgroundColor,
    this.color,
    this.selectedColor,
    this.notchedShape,
    this.onTabSelected,
  }) {
    assert(this.items.length == 2 || this.items.length == 4);
  }
  final List<FABBottomAppBarItem> items;
  final String centerItemText;
  final double height;
  final double iconSize;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final NotchedShape notchedShape;
  final ValueChanged<int> onTabSelected;

  @override
  State<StatefulWidget> createState() => FABBottomAppBarWidgetState();
}

class FABBottomAppBarWidgetState extends State<FABBottomAppBarWidget> {
  int _selectedIndex = 0;

  _updateIndex(int index) {
    widget.onTabSelected(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: _updateIndex,
      );
    });
    items.insert(items.length >> 1, _buildMiddleTabItem());

    return BottomAppBar(
      notchMargin: 18,
      shape: widget.notchedShape,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
      color: widget.backgroundColor,
    );
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: widget.iconSize),
            Text(
              widget.centerItemText ?? '',
              style: TextStyle(color: widget.color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    FABBottomAppBarItem item,
    int index,
    ValueChanged<int> onPressed,
  }) {
    Color color = _selectedIndex == index ? widget.selectedColor : widget.color;
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          elevation: 0,
          child: InkWell(
              onTap: () => onPressed(index),
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: _selectedIndex == index
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Color(0xffEBEEF0))
                    : null,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _selectedIndex == index ? item.iconActive : item.icon,
                    SizedBox(
                      width: 5,
                      height: 5,
                    ),
                    Text(
                        item.text  ,
                      style: GoogleFonts.inter(
                          color: color,
                          fontWeight: FontWeight.w800,
                          fontSize: 14 *
                              sqrt(MediaQuery.of(context).size.height *
                                      MediaQuery.of(context).size.height +
                                  MediaQuery.of(context).size.width *
                                      MediaQuery.of(context).size.width) *
                              0.001),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
