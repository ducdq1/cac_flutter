import 'package:flutter/material.dart';

import 'feature_product_info_dialog_widget.dart';
import 'package:citizen_app/features/paht/data/models/paht_model.dart';

import 'package:citizen_app/features/paht/data/models/product_model.dart';
Future showViewFeatureProductDialog({
  BuildContext context,
  Icon icon,
  Function onSubmit,
  ProductModel model
}) async {
  return await showDialog(
    context: context,
    builder: (_) =>  ViewFeatureProductDialog(
        icon: icon,
        onSubmit: onSubmit,
        model: model,
    ),
  );
}
