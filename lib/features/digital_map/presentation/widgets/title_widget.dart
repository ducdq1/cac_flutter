import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';

class TitleWidget extends StatefulWidget {
  final String title;
  final ScrollController scrollController;

  TitleWidget({Key key, @required this.title, this.scrollController})
      : super(key: key);

  @override
  _TitleWidgetState createState() => _TitleWidgetState();
}

class _TitleWidgetState extends State<TitleWidget> {
  double opacity = 1.0;

  @override
  void initState() {
    widget.scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    double percent = 1 - (widget.scrollController.offset / 190);
    setState(() {
      opacity = percent;
    });
    if (opacity >= 1 || widget.scrollController.offset == 0)
      setState(() {
        opacity = 1;
      });
    if (opacity <= 0)
      setState(() {
        opacity = 0;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Text(
        widget.title,
        style: TextStyle(
            color: Colors.black,
            fontSize: FONT_HUGE + 2,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
