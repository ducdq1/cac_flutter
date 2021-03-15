import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/features/common/widgets/layouts/base_layout_widget.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/digital_map/presentation/blocs/filter_category/filter_category_bloc.dart';
import 'package:citizen_app/features/digital_map/presentation/blocs/marker_info/marker_info_bloc.dart';
import 'package:citizen_app/features/digital_map/presentation/pages/digital_map_body.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DigitalMapPage extends StatefulWidget {
  DigitalMapPage({Key key}) : super(key: key);

  @override
  _DigitalMapPageState createState() => _DigitalMapPageState();
}

class _DigitalMapPageState extends State<DigitalMapPage> {
  @override
  Widget build(BuildContext context) {
    return BaseLayoutWidget(
      title: trans(TITLE_DIGITAL_MAP_SCREEN),
      centerTitle: true,
      body: BlocProvider<MarkerInfoBloc>(
        create: (context) => singleton<MarkerInfoBloc>(),
        child: BlocProvider<FilterCategoryBloc>(
          create: (context) =>
              singleton<FilterCategoryBloc>()..add(ListFilterCategoryFetched()),
          child: DigitalMapBody(),
        ),
      ),
    );
  }
}
