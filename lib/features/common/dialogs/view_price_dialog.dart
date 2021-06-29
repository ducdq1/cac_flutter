import 'package:flutter/material.dart';

import 'view_price_dialog_widget.dart';
import 'package:citizen_app/features/paht/data/models/paht_model.dart';

import 'package:citizen_app/features/paht/data/models/product_model.dart';
Future showViewPriceDialog({
  BuildContext context,
  String giaBan,
  String ngayCapNhat,
  String giaNhap,
  Icon icon,
  Function onSubmit,
  ProductModel model
}) async {
  return await showDialog(
    context: context,
    builder: (_) => ViewPriceDialog(
      icon: icon,
      giaNhap: giaNhap,
      onSubmit: onSubmit,
      giaBan: giaBan,
      ngayCapNhat: ngayCapNhat,
      model: model,
    ),
  );
}
