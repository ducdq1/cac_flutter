import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ToggleNotificationWidget extends StatefulWidget {
  final String icon;
  final String label;
  final bool value;
  final Function callback; //bool

  ToggleNotificationWidget({this.icon, this.label, this.value, this.callback});
  @override
  _ToggleNotificationWidgetState createState() =>
      _ToggleNotificationWidgetState();
}

class _ToggleNotificationWidgetState extends State<ToggleNotificationWidget> {
  bool _isSwitched;

  @override
  void initState() {
    _isSwitched = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Color(0xffB9B9B9), width: 0.3))),
      child: Row(
        children: [
          SvgPicture.asset(
            SVG_ASSETS_PATH + widget.icon,
            width: 24,
            height: 24,
            fit: BoxFit.fill,
          ),
          SizedBox(width: 17),
          Expanded(
            child: Text(
              widget.label,
              style: GoogleFonts.inter(
                fontSize: FONT_MIDDLE,
                fontWeight: FontWeight.normal,
                color: PRIMARY_TEXT_COLOR,
              ),
            ),
          ),
          Switch(
            materialTapTargetSize: MaterialTapTargetSize.padded,
            value: _isSwitched,
            activeColor: Colors.white,
            activeTrackColor: PRIMARY_COLOR,
            onChanged: (bool value) {
              setState(() {
                _isSwitched = !_isSwitched;
              });
            },
          )
        ],
      ),
    );
  }
}
