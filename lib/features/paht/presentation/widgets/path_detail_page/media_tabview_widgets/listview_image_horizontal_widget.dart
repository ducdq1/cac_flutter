import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/paht/data/models/place_images_model.dart';
import 'package:citizen_app/features/paht/presentation/widgets/path_detail_page/media_tabview_widgets/listview_image_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ListViewImageHorizontalWidget extends StatefulWidget {
  final List<PlaceImagesModel> photos;

  ListViewImageHorizontalWidget({this.photos});

  @override
  _ListViewImageHorizontalWidgetState createState() =>
      _ListViewImageHorizontalWidgetState();
}

class _ListViewImageHorizontalWidgetState
    extends State<ListViewImageHorizontalWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              ],
            ),
          ),
          SizedBox(height: 4),
          Container(
            height: 160,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                return ListViewImageItemWidget(
                  url: widget.photos != null ? widget.photos[index] : null,
                  urls: widget.photos,
                );
              },
              itemCount: widget.photos?.length ?? 3,
            ),
          )
        ],
      ),
    );
  }
}
