import 'package:flutter/cupertino.dart';

class RouterWidget {
  BuildContext context;
  Function route;

  RouterWidget({this.context, this.route});

  static void navigateToPage(context, route) {
    Future.delayed(Duration.zero, () {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => route));
    });
  }
}
