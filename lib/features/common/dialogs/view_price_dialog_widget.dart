import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:citizen_app/core/functions/handle_time.dart';
import 'package:citizen_app/features/paht/data/models/paht_model.dart';

import 'package:citizen_app/features/paht/data/models/product_model.dart';

class ViewPriceDialog extends StatefulWidget {
  final String giaNhap;
  final Function onSubmit;
  final String giaBan;
  final String ngayCapNhat;
  final Icon icon;
  final ProductModel model;

  ViewPriceDialog(
      {this.onSubmit,
      this.giaBan,
      this.icon,
      this.giaNhap,
      this.ngayCapNhat,
      this.model});

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
    int userType = pref.getInt('userType');
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.only(top: 20.0, bottom: 20),
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
              Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.orange.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Giá nhập: ',
                            softWrap: true,
                            style: TextStyle(
                                fontSize: FONT_EX_LARGE,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 10),
                          Text(
                            widget.giaNhap ?? '',
                            style: TextStyle(
                              fontSize: FONT_EX_MIDDLE,
                              color: Colors.orange,
                            ),
                            textAlign: TextAlign.left,
                          )
                        ]),
                  )),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.lightBlue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Giá bán lẽ:  ',
                          style: TextStyle(
                              fontSize: FONT_EX_LARGE,
                              color: Colors.lightBlue,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.giaBan ?? '',
                          style: TextStyle(
                            fontSize: FONT_EX_MIDDLE,
                            color: Colors.lightBlue,
                          ),
                          textAlign: TextAlign.left,
                        )
                      ]),
                ),
              ),
              userType == 3
                  ? SizedBox()
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.green.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                'Giá khuyến mãi:  ',
                                style: TextStyle(
                                    fontSize: FONT_EX_LARGE,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),Image.asset(
                                  ICONS_ASSETS + 'hot_deal1.png',
                                  width: 32,
                                  height: 32,
                                ),
                            ]),
                            SizedBox(height: 10),
                            Text(
                              widget.model.priceKM ?? 'Chưa có giá',
                              style: TextStyle(
                                fontSize: FONT_EX_MIDDLE,
                                color: Colors.green,
                              ),
                              textAlign: TextAlign.left,
                            )
                          ],
                        ),
                      ),
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
