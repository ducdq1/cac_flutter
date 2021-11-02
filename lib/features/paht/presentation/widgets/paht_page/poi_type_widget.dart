import 'dart:ui';

import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/validate/empty_validate.dart';
import 'package:citizen_app/core/utils/validate/phone_validate.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:citizen_app/features/common/widgets/inputs/input_validate_custom_widget.dart';
import 'package:citizen_app/features/common/widgets/widgets.dart';
import 'package:citizen_app/features/home/presentation/bloc/bloc/home_page_bloc.dart';
import 'package:citizen_app/features/home/presentation/pages/home_page.dart';
import 'package:citizen_app/features/paht/data/models/category_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

const SIZE_ICON = 20.0;

class PoiTypeWidget extends StatefulWidget {
  final ScrollController scrollController;
  final StopScrollController stopScrollController;
  final Function(String) onChange;
  final String initialValue;

  PoiTypeWidget(
      {Key key,
      this.scrollController,
      this.stopScrollController,
      this.onChange,
      this.initialValue})
      : super(key: key);

  @override
  _PoiTypeWidgetState createState() => _PoiTypeWidgetState();
}

class _PoiTypeWidgetState extends State<PoiTypeWidget>
    implements OnButtonClickListener {
  TextEditingController textEditingController;
  FocusNode _focusNode;

  @override
  void initState() {
    textEditingController = new TextEditingController();
    _focusNode = new FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return  null;
  }

  @override
  onClick(String id) {
  }
}
