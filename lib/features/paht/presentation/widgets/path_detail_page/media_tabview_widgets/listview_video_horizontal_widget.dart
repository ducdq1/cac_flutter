import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:citizen_app/features/paht/data/models/media_model.dart';

import 'listview_video_item_widget.dart';

class ListViewVideoHorizontalWidget extends StatefulWidget {
  final List<LocationUrlModel> videos;

  ListViewVideoHorizontalWidget({this.videos});

  @override
  _ListViewVideoHorizontalWidgetState createState() =>
      _ListViewVideoHorizontalWidgetState();
}

class _ListViewVideoHorizontalWidgetState
    extends State<ListViewVideoHorizontalWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        SVG_ASSETS_PATH + 'icon_video.svg',
                      ),
                      SizedBox(height: 18),
                      Text(
                        trans(PROCESSING_RESULT),
                        style: GoogleFonts.inter(
                          fontSize: FONT_EX_LARGE,
                          color: PRIMARY_TEXT_COLOR,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  height: 160,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) {
                      return ListViewVideoItemWidget(
                        url: widget.videos != null
                            ? widget.videos[index].relLocation
                            : null,
                      );
                    },
                    itemCount: widget.videos?.length ?? 2,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
