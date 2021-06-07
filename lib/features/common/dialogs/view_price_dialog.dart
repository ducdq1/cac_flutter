import 'package:flutter/material.dart';

import 'view_price_dialog_widget.dart';

Future showViewPriceDialog({
  BuildContext context,
  String giaBan,
  String ngayCapNhat,
  String giaNhap,
  Icon icon,
  Function onSubmit,
}) async {
  return await showDialog(
    context: context,
    builder: (_) => ViewPriceDialog(
      icon: icon,
      giaNhap: giaNhap,
      onSubmit: onSubmit,
      giaBan: giaBan,
      ngayCapNhat: ngayCapNhat,
    ),
  );
}
