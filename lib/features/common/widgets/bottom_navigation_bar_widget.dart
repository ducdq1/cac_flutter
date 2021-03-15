import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  BottomNavigationBarWidget(
      {@required this.currentIndex,
      @required this.tabCount,
      @required this.activeColor,
      @required this.color,
      @required this.listIconTab,
      @required this.listTitleTab,
      @required this.onTap});
  final int currentIndex;
  final int tabCount;
  final List<IconData> listIconTab;
  final List<String> listTitleTab;
  final Color color;
  final Color activeColor;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      items: [
        for (int i = 0; i < tabCount; i++)
          BottomNavigationBarItem(
              icon: Icon(
                listIconTab[i],
                size: 25,
                color: color,
              ),
              title: Text(
                listTitleTab[i],
                style: TextStyle(color: color),
              ),
              activeIcon: Icon(
                listIconTab[i],
                size: 25,
                color: activeColor,
              )),
      ],
      onTap: onTap,
    );
  }
}
