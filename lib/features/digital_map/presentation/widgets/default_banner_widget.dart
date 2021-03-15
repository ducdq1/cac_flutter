import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';

class DefaultBannerWidget extends StatelessWidget {
  final String banner;
  const DefaultBannerWidget({Key key, this.banner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://neohouse.vn/wp-content/uploads/2019/11/biet-thu-nha-vuon-1-tang.jpg',
      // banner,
      width: MediaQuery.of(context).size.width,
      height: 500,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 220,
          decoration: BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [
                  0.05,
                  0.7,
                  1.5
                ],
                colors: [
                  Color(0x99000000),
                  Color(0x4A646464),
                  Color(0x00C4C4C4)
                ]),
          ),
          child: Center(
            child: Image.asset(
              IMAGE_ASSETS_PATH + 'default_marker_detail.png',
              width: 44,
              height: 41,
            ),
          ),
        );
      },
      errorBuilder:
          (BuildContext context, Object exception, StackTrace stackTrace) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 270,
          decoration: BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [
                  0.05,
                  0.7,
                  1.5
                ],
                colors: [
                  Color(0x99000000),
                  Color(0x4A646464),
                  Color(0x00C4C4C4)
                ]),
          ),
          child: Center(
            child: Image.asset(
              IMAGE_ASSETS_PATH + 'default_marker_detail.png',
              width: 44,
              height: 41,
            ),
          ),
        );
      },
    );
  }
}
