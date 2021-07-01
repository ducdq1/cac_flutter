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
  TabController _controller;

  @override
  void initState() {
    super.initState();
    int userType = pref.getInt('userType');
    _controller = new TabController(length:  userType == 3 ? 2 : 1, vsync: this);
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
          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
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
                    color: Theme.of(context).primaryColor,
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
                      'NGÀY CẬP NHẬT: ' + formatTime(widget.ngayCapNhat),
                      softWrap: true,
                      style: TextStyle(
                          fontSize: FONT_MIDDLE,
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
              Container(
                decoration:
                    new BoxDecoration(color: Theme.of(context).primaryColor),
                child: new TabBar(
                  indicatorColor: Colors.white,
                  indicatorWeight: 2,
                  controller: _controller,
                  tabs: userType == 3 ?  [
                    new Tab(
                      icon: const Icon(Icons.person_pin),
                      text: 'Giá Bán lẽ',
                    ),
                    new Tab(
                      icon: const Icon(Icons.home_work),
                      text: 'Giá Đại lý',
                    ),
                  ] : [new Tab(
                    icon: const Icon(Icons.home_work),
                    text: 'Đại lý',
                  ),],
                ),
              ),
              Expanded(
                child: Container(
                  child: new TabBarView(
                    controller: _controller,
                    children:  userType == 3? [
                      SingleChildScrollView(child: viewBanLe()),
                      SingleChildScrollView(child:viewDaiLy())
                    ] :
                    [ SingleChildScrollView(child:viewDaiLy())],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Container(
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
  Widget viewBanLe(){
return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.orange.shade50,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment:
                CrossAxisAlignment.start,
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
                    widget.model.price ?? '',
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
                  widget.model.salePrice ?? '',
                  style: TextStyle(
                    fontSize: FONT_EX_MIDDLE,
                    color: Colors.lightBlue,
                  ),
                  textAlign: TextAlign.left,
                )
              ]),
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.green.shade50,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.start,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(
                  'Giá bán đại lý:  ',
                  style: TextStyle(
                      fontSize: FONT_EX_LARGE,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ]),
              SizedBox(height: 10),
              Text(
                widget.model.priceDL ?? 'Chưa có giá',
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
      Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.orange.shade50,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'Giá nhập khuyến mãi:  ',
                    softWrap: true,
                    style: TextStyle(
                        fontSize: FONT_EX_LARGE,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.model.priceNHAPKM ?? '',
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
                Row(children: [
                  Text(
                    'Giá khuyến mãi bán lẽ:  ',
                    style: TextStyle(
                        fontSize: FONT_EX_LARGE,
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  Image.asset(
                    ICONS_ASSETS + 'hot_deal1.png',
                    width: 32,
                    height: 32,
                  ),
                ]),
                SizedBox(height: 10),
                Text(
                  widget.model.priceBLKM ?? '',
                  style: TextStyle(
                    fontSize: FONT_EX_MIDDLE,
                    color: Colors.lightBlue,
                  ),
                  textAlign: TextAlign.left,
                )
              ]),
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.green.shade50,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.start,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(
                  'Giá khuyến mãi đại lý :  ',
                  style: TextStyle(
                      fontSize: FONT_EX_LARGE,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Image.asset(
                  ICONS_ASSETS + 'hot_deal1.png',
                  width: 32,
                  height: 32,
                ),
              ]),
              SizedBox(height: 5),
              Text(
                widget.model.priceDLKM ?? 'Chưa có giá',
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
    ]);
  }

  Widget viewDaiLy(){
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Giá bán lẽ: ',
                        softWrap: true,
                        style: TextStyle(
                            fontSize: FONT_EX_LARGE,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.model.salePrice ?? '',
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
                    Row(children: [
                      Text(
                        'Giá khuyến mãi bán lẽ:  ',
                        style: TextStyle(
                            fontSize: FONT_EX_LARGE,
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      Image.asset(
                        ICONS_ASSETS + 'hot_deal1.png',
                        width: 32,
                        height: 32,
                      ),
                    ]),
                    SizedBox(height: 10),
                    Text(
                      widget.model.priceBLKM ?? '',
                      style: TextStyle(
                        fontSize: FONT_EX_MIDDLE,
                        color: Colors.lightBlue,
                      ),
                      textAlign: TextAlign.left,
                    )
                  ]),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.start,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(
                        'Giá bán đại lý:  ',
                      style: TextStyle(
                          fontSize: FONT_EX_LARGE,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ]),
                  SizedBox(height: 10),
                  Text(
                    widget.model.priceDL ?? 'Chưa có giá',
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
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.red.shade100,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.start,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(
                      'Giá khuyến mãi đại lý:  ',
                      style: TextStyle(
                          fontSize: FONT_EX_LARGE,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    Image.asset(
                      ICONS_ASSETS + 'hot_deal1.png',
                      width: 32,
                      height: 32,
                    ),
                  ]),
                  SizedBox(height: 10),
                  Text(
                    widget.model.priceDLKM ?? 'Chưa có giá',
                    style: TextStyle(
                      fontSize: FONT_EX_MIDDLE,
                      color: Colors.redAccent,
                    ),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
            ),
          ),

        ]);
  }
}
