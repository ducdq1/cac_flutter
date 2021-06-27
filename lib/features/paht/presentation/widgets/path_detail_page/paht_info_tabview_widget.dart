import 'package:citizen_app/core/functions/handle_time.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/datetime_converter.dart';
import 'package:citizen_app/features/paht/data/models/paht_model.dart';
import 'package:citizen_app/features/paht/data/models/product_model.dart';
import 'package:citizen_app/features/paht/data/models/tonkho_model.dart';
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
  final ProductModel productModel;
  final TonKhoModel tonKhoModel;
  final bool isViewTonKho;
  PahtInfoTabViewWidget({Key key, this.productModel, this.tonKhoModel, this.isViewTonKho = true})
      : super(key: key);

  @override
  _PahtInfoTabViewWidgetState createState() => _PahtInfoTabViewWidgetState();
}

class _PahtInfoTabViewWidgetState extends State<PahtInfoTabViewWidget> {
  @override
  Widget build(BuildContext context) {
    //if (state is DetailedPahtSuccess) {
    return Container(
      color: Color.fromARGB(153, 250, 245, 232),
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowGlow();
          return false;
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 16),
            Expanded(
              child: ReportWidget(
                productModel: widget.productModel,
                tonKhoModel: widget.tonKhoModel,
                isViewTonKho: widget.isViewTonKho,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
