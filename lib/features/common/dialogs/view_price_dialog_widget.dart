import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:citizen_app/core/functions/handle_time.dart';

class ViewPriceDialog extends StatefulWidget {
  final String giaNhap;
  final Function onSubmit;
  final String giaBan;
  final String ngayCapNhat;
  final Icon icon;

  ViewPriceDialog(
      {this.onSubmit, this.giaBan, this.icon, this.giaNhap, this.ngayCapNhat});

  @override
  _ViewPiceDialogState createState() => _ViewPiceDialogState();
}

class _ViewPiceDialogState extends State<ViewPriceDialog>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
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
    return Center(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'NGÀY CẬP NHẬT: ' + formatTime(widget.ngayCapNhat),
                  softWrap: true,
                  style: TextStyle(
                      fontSize: FONT_MIDDLE,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(
                height: 40,
                thickness: 2,
              ),
              SizedBox(height: 30),
              Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                Text(
                  'Giá nhập: ',
                  softWrap: true,
                  style: TextStyle(
                      fontSize: FONT_EX_LARGE,
                      color: Color(0xffff8000),
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Expanded(
                  child: Text(
                    widget.giaNhap ?? '',
                    style: TextStyle(
                      fontSize: FONT_EX_LARGE,
                      color: Color(0xffff8000),
                    ),
                    textAlign: TextAlign.left,
                  ),
                )
              ]),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Giá bán lẽ:  ',
                    style: TextStyle(
                        fontSize: FONT_EX_MIDDLE,
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  Expanded(
                    child: Text(
                     widget.giaBan ?? '',
                      style: TextStyle(
                        fontSize: FONT_EX_MIDDLE,
                        color: Colors.lightBlue,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  )
                ],
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    elevation: 0,
                    color: PRIMARY_COLOR,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: PRIMARY_COLOR),
                    ),
                    child: Center(
                      child: Text(
                        '        Đóng        ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: FONT_EX_SMALL,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
