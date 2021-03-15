import 'package:citizen_app/core/functions/handle_time.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/datetime_converter.dart';
import 'package:citizen_app/features/paht/data/models/paht_model.dart';
import 'package:citizen_app/features/paht/presentation/bloc/detailed_paht_bloc/detailed_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/widgets/path_detail_page/info_tabview_widgets/emotion_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/path_detail_page/info_tabview_widgets/location_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'info_tabview_widgets/report_widget.dart';
import 'info_tabview_widgets/result_widget.dart';
import 'skeletons_widget.dart/skeleton_detailed_paht_widget.dart';

class PahtInfoTabViewWidget extends StatefulWidget {
  final PahtModel poiDetail;

  PahtInfoTabViewWidget(
      {Key key,
        this.poiDetail, })
      : super(key: key);

  @override
  _PahtInfoTabViewWidgetState createState() => _PahtInfoTabViewWidgetState();
}

class _PahtInfoTabViewWidgetState extends State<PahtInfoTabViewWidget> {
  @override
  Widget build(BuildContext context) {
        //if (state is DetailedPahtSuccess) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowGlow();
                return false;
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     SizedBox(width:16),
                    ReportWidget(
                      poiDetail: widget.poiDetail,
                      name: widget.poiDetail.name,
                      createdTime: formatTime(
                          widget.poiDetail.createdDate),
                      category:widget.poiDetail.fromCategory ==null? "": widget.poiDetail.fromCategory.name,
                      description: widget.poiDetail.address,
                    ),
                    SizedBox(height: 18),
                    LocationWidget(
                      address: widget.poiDetail.address,
                      lattitude: widget.poiDetail.lat.toString(),
                      longitude: widget.poiDetail.lng.toString(),
                      name: widget.poiDetail.name,
                    ),
                    SizedBox(height: 60),

                  ],
                ),
              ),
            ),
          );
        // } else {
        //   return SingleChildScrollView(child: SkeletonDetailedPahtWidget());
        // }

  }
}
