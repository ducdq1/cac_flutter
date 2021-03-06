import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/api.dart';
import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_bloc.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_state.dart';
import 'package:citizen_app/features/authentication/signin/presentation/signin_page.dart';
import 'package:citizen_app/features/common/dialogs/confirm_dialog.dart';
import 'package:citizen_app/features/customer/presentation/bloc/notification/notification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_transitions/route_transitions.dart';

class FABBottomAppBarItem {
  FABBottomAppBarItem({
    this.icon,
    this.text,
    this.iconActive,
    this.badgeCount = 0,
  });

  Widget icon;
  Widget iconActive;
  String text;
  final int badgeCount;
}

class FABBottomAppBarWidget extends StatefulWidget {
  FABBottomAppBarWidget(
      {this.items,
      this.centerItemText,
      this.height: 70.0,
      this.iconSize: 30.0,
      this.backgroundColor,
      this.color,
      this.selectedColor = PRIMARY_COLOR,
      this.notchedShape,
      this.onTabSelected,
      this.isBuildCenterButton = false}) {
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
  final bool isBuildCenterButton;

  @override
  State<StatefulWidget> createState() => FABBottomAppBarWidgetState();
}

class FABBottomAppBarWidgetState extends State<FABBottomAppBarWidget> {
  int _selectedIndex = 0;

  _updateIndex(int index) {
    if (_selectedIndex == index) {
      return;
    }


    if (index == 2 && getUserName() == null)  { // chua dang nhap
        showConfirmDialog(
          context: context,
          icon: Icon(
            Icons.logout,
            color: Colors.orangeAccent,
          ),
          title: '????? s??? d???ng t??nh n??ng n??y b???n ph???i c???p nh???t th??ng tin c?? nh??n',
          label: 'C???p nh???t',
          onSubmit: () {
            Navigator.of(context).push(
              PageRouteTransition(
                animationType: AnimationType.slide_right,
                builder: (context) => SignInPage(),
              ),
            );
          },
        );
      // BlocProvider.of<ProductCategoryBloc>(context)
      //     .add(ListProductCategoriesFetching());
    }else {
      widget.onTabSelected(index);
      setState(() {
        _selectedIndex = index;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    print('Selected _updateIndex ' + _selectedIndex.toString());
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return BlocBuilder<NotificationBloc, NotificationState>(
          builder: (BuildContext context, NotificationState state) {
        int badgeCount = 0;
        if (state is NotificationChange ) {
          badgeCount = state.value;
        }

        print('Update badge data: ' + badgeCount.toString());
        return _buildTabItem(
            item: widget.items[index],
            index: index,
            onPressed: _updateIndex,
            badgeCount: badgeCount);
      });
    });
    if (widget.isBuildCenterButton) {
      items.insert(items.length >> 1, _buildMiddleTabItem());
    }

    return BottomAppBar(
      notchMargin: 18,
      shape: widget.notchedShape,
      child: Container(
        padding: EdgeInsets.only(top: 0, left: 5, right: 5),
        decoration: BoxDecoration(
          color: Colors.white, //Color(0xffF8F2E3),//Colors.white,
          border: Border.all(color: Color(0xffE5E5E5), width: 1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(-2, -2), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items,
        ),
      ),
      color: Colors.white,
      //Colors.white,//Color(0xffF8F2E3),
      elevation: 0,
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
    int badgeCount,
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
                margin: EdgeInsets.all(5),
                decoration: null,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Stack(children: [
                      _selectedIndex == index ? item.iconActive : item.icon,
                      index != 2 || badgeCount <= 0
                          ? SizedBox()
                          : Positioned(
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(1),
                                decoration: new BoxDecoration(
                                  color: PRIMARY_COLOR,
                                  borderRadius: BorderRadius.circular(7.5),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 15,
                                  minHeight: 15,
                                ),
                                child: Center(
                                  child: Text(
                                    badgeCount.toString(),
                                    style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                    ]),
                    SizedBox(
                      width: 5,
                      height: 5,
                    ),
                    Text(
                      item.text,
                      style: GoogleFonts.inter(
                        color: color,
                        fontWeight: _selectedIndex == index
                            ? FontWeight.w700
                            : FontWeight.w500,
                        fontSize: _selectedIndex == index ? 13 : 12,
                      ),
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
