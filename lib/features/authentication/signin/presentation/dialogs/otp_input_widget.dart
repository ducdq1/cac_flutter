import 'package:citizen_app/core/resources/colors.dart';
import 'package:flutter/material.dart';

class OTPInputWidget extends StatefulWidget {
  final FocusNode node;
  final Function enter;

  OTPInputWidget({this.node, this.enter});

  @override
  _OTPInputWidgetState createState() => _OTPInputWidgetState();
}

class _OTPInputWidgetState extends State<OTPInputWidget> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 44,
      margin: EdgeInsets.all(6),
      child: TextField(
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: BORDER_COLOR,
              width: 0.6,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: PRIMARY_COLOR,
              width: 0.6,
            ),
          ),
          contentPadding: EdgeInsets.all(4),
        ),
        onChanged: (String value) {
          if(value.trim().isNotEmpty) {
            widget.node.nextFocus();
            widget.enter(value.trim());
          } else {
            controller.clear();
          }
        },
      ),
    );
  }
}
