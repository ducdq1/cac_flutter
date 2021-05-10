import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';

class InputDialog extends StatefulWidget {
  final String value;
  final Function onSubmit;
  final String title;
  final Icon icon;

  InputDialog({this.onSubmit, this.value, this.icon, this.title});

  @override
  _InputDialogState createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;
  TextEditingController textEditingController;
  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    textEditingController.text = widget.value;
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20.0),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Center(
                //   child: widget.icon ??
                //       Icon(
                //         Icons.report_outlined,
                //         color: Colors.orangeAccent,
                //         size: 30,
                //       ),
                // ),
                // SizedBox(height: 20),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: FONT_LARGE,
                    color: PRIMARY_COLOR,
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                TextField(
                  maxLines: null,
                  controller: textEditingController,
                  style: TextStyle(
                    fontSize: FONT_MIDDLE,
                    color: PRIMARY_TEXT_COLOR,
                  ),
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '',
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: PRIMARY_COLOR),
                      ),
                      child: Center(
                        child: Text(
                         "Hủy bỏ",
                          style: TextStyle(
                            color: PRIMARY_COLOR,
                            fontSize: FONT_EX_SMALL,
                          ),
                        ),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        widget.onSubmit(textEditingController.text);
                      },
                      elevation: 0,
                      color: PRIMARY_COLOR,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: PRIMARY_COLOR),
                      ),
                      child: Center(
                        child: Text(
                          "Lưu thông tin",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: FONT_EX_SMALL,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
