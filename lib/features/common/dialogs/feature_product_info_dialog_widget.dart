import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:citizen_app/core/functions/handle_time.dart';
import 'package:citizen_app/features/paht/data/models/paht_model.dart';

import 'package:citizen_app/features/paht/data/models/product_model.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewFeatureProductDialog extends StatefulWidget {
  final Function onSubmit;
  final Icon icon;
  final ProductModel model;

  ViewFeatureProductDialog({this.onSubmit, this.icon, this.model});

  @override
  _ViewFeatureProductDialogState createState() =>
      _ViewFeatureProductDialogState();
}

class _ViewFeatureProductDialogState extends State<ViewFeatureProductDialog>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;
  TabController _controller;

  @override
  void initState() {
    super.initState();
    int userType = pref.getInt('userType');
    _controller = new TabController(length: userType == 3 ? 2 : 1, vsync: this);
    // controller =
    //     AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    // controller.addListener(() {
    //   setState(() {});
    // });
    // controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    int userType = pref.getInt('userType');
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          padding: const EdgeInsets.only(top: 00.0, bottom: 10),
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
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: ShapeDecoration(
                    color: PRIMARY_COLOR,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                  ),
                  height: 60,
                  child: Center(
                    child: Text(
                      'Thông tin sản phẩm',
                      softWrap: true,
                      style: TextStyle(
                          fontSize: FONT_LARGE,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Divider(
                height: 1,
              ),
              (widget.model.productType == 0 || widget.model.productType == 1) ? viewThongTinSPThietBi()
              : viewThongTinSPGach(),
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 20),
                  width: 160,
                  child: RaisedButton(
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
                        'Đóng',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: FONT_EX_SMALL,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget viewThongTinSPGach() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        customTitle("Tính năng:"),
        customText(widget.model.feature),
        customTitle("Đóng gói:"),
        customText(widget.model.dongGoi),
        customTitle("Nơi sản xuất:"),
        customText(widget.model.madeIn),
      ]),
    );
  }

  Widget viewThongTinSPThietBi() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        customTitle("Tính năng:"),
        customText(widget.model.feature),
        customTitle("Thông số kỹ thuật:"),
        customText(widget.model.thongSoKT),
        customTitle("Nơi sản xuất:"),
        customText(widget.model.madeIn),
        customTitle("Bảo hành:"),
        customText(widget.model.warranty)
      ]),
    );
  }

  Widget customText(String value){
    return  Padding(
      padding: EdgeInsets.only(top: 5),
      child: Text("  "+ (value ?? "--"),
          style: GoogleFonts.inter(
            fontSize: FONT_MIDDLE,
            color: PRIMARY_COLOR,
          )),
    );

  }

  Widget customTitle(String value){
    return  Padding(
      padding: EdgeInsets.only(top: 18),
      child: Text(value ?? "",
          style: GoogleFonts.inter(
            fontSize: FONT_MIDDLE,
            color: PRIMARY_TEXT_COLOR,
            fontWeight: FontWeight.w600,
          )),
    );

  }
}
