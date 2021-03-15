import 'dart:math';

import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/paht/data/models/place_images_model.dart';
import 'package:citizen_app/features/paht/domain/entities/place_images_entity.dart';
import 'package:citizen_app/features/paht/presentation/pages/media_presenter_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/services.dart';
import 'package:citizen_app/features/paht/data/models/media_model.dart';

class ListViewImageItemWidget extends StatefulWidget {
  final PlaceImagesModel url;
  final List<PlaceImagesModel> urls;
  ListViewImageItemWidget({@required this.url, @required this.urls});

  @override
  _ListViewImageItemWidgetState createState() =>
      _ListViewImageItemWidgetState();
}

class _ListViewImageItemWidgetState extends State<ListViewImageItemWidget> {
  bool _shouldShowSkeleton = true;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MediaPresenterPage(
              urls: widget.urls,
              initialIndex: widget.urls.indexOf(widget.url),
            ),
          ),
        );
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(statusBarColor: PRIMARY_COLOR),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 120,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: Colors.grey[200],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                _shouldShowSkeleton
                    ? SkeletonAnimation(
                        child: Container(
                          width: 120.0,
                          height: 160.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )
                    : SizedBox(),
                Hero(
                  tag: widget.url ?? '${Random().nextInt(10000)}',
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: widget.url.imageUrl,
                    fit: BoxFit.cover,
                    width: 120.0,
                    height: 160.0,
                    imageErrorBuilder: (_, __, ___) {
                      _shouldShowSkeleton = false;
                      return Container(
                        width: 120.0,
                        height: 160.0,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            SVG_ASSETS_PATH + 'icon_none_image.svg',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
