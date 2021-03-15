import 'package:flutter/material.dart';

class FormTools {
  static void requestFocus(
      {FocusNode currentFocusNode,
      FocusNode nextFocusNode,
      BuildContext context}) {
    currentFocusNode.unfocus();
    if (nextFocusNode != null) {
      FocusScope.of(context).requestFocus(nextFocusNode);
    }
  }
}
