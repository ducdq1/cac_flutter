import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/features/paht/data/models/paht_model.dart';
import 'package:citizen_app/features/paht/presentation/bloc/detailed_paht_bloc/detailed_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/widgets/path_detail_page/media_tabview_widgets/listview_image_horizontal_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class PahtMediaTabViewWidget extends StatefulWidget {
  final PahtModel poiDetail;

  PahtMediaTabViewWidget({Key key, this.poiDetail}) : super(key: key);

  @override
  _PahtMediaTabViewWidgetState createState() => _PahtMediaTabViewWidgetState();
}

class _PahtMediaTabViewWidgetState extends State<PahtMediaTabViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.poiDetail.placeImages ==null || widget.poiDetail.placeImages.isEmpty ?
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                trans(NO_DATA),
                style: GoogleFonts.inter(
                  color: PRIMARY_TEXT_COLOR,
                  fontSize: FONT_MIDDLE,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ) : SizedBox(),
            widget.poiDetail.placeImages.isNotEmpty
                ? ListViewImageHorizontalWidget(
                    photos: widget.poiDetail.placeImages)
                : SizedBox(),
            widget.poiDetail.placeImages.isNotEmpty
                ? SizedBox(height: 44)
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
