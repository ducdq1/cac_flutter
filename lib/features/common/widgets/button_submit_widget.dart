import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonSubmitWidget extends StatelessWidget {
  ButtonSubmitWidget({@required this.onPressed, @required this.text});
  final Function onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 54.0,
          child: RaisedButton(
            onPressed: this.onPressed,
            color: COLOR_BUTTON_SUBMIT,
            child: Text(
              this.text,
              style: TextStyle(
                  color: COLOR_TEXT_BUTTON_SUBMIT,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            shape: StadiumBorder(),
          ),
        ));
  }
}
