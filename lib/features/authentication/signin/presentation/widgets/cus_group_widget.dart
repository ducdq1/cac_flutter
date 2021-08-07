import 'dart:ui';

import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/validate/empty_validate.dart';
import 'package:citizen_app/core/utils/validate/phone_validate.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:citizen_app/features/common/widgets/inputs/input_validate_custom_widget.dart';
import 'package:citizen_app/features/common/widgets/inputs/input_validate_widget.dart';
import 'package:citizen_app/features/common/widgets/widgets.dart';
import 'package:citizen_app/features/home/presentation/bloc/bloc/home_page_bloc.dart';
import 'package:citizen_app/features/home/presentation/pages/home_page.dart';
import 'package:citizen_app/features/paht/data/models/category_model.dart';
import 'package:citizen_app/features/paht/presentation/bloc/category_paht_bloc/category_paht_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

const SIZE_ICON = 20.0;

class CusGroupWidget extends StatefulWidget {
  final ScrollController scrollController;
  final StopScrollController stopScrollController;
  final Function(int) onChange;
  final String initialValue;

  CusGroupWidget(
      {Key key,
      this.scrollController,
      this.stopScrollController,
      this.onChange,
      this.initialValue})
      : super(key: key);

  @override
  _CusGroupWidgetState createState() => _CusGroupWidgetState();
}

class _CusGroupWidgetState extends State<CusGroupWidget>
    implements OnButtonClickListener {
  TextEditingController textEditingController;
  FocusNode _focusNode;

  List<CategoryModel> listCategories =[];
  @override
  void initState() {
    listCategories.add(CategoryModel(type:0,name:"Công ty Xây Dựng"));
    listCategories.add(CategoryModel(type:1,name:"Công ty TK và Thi Công"));
    listCategories.add(CategoryModel(type:2,name:"Nhà thầu Xây Dựng"));
    listCategories.add(CategoryModel(type:3,name:"Thợ Xây Dựng"));
    listCategories.add(CategoryModel(type:4,name:"Thợ Điện Nước"));

    textEditingController = new TextEditingController();
    _focusNode = new FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return   Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child:  Stack(children: [
                          InputValidateWidget(
                            label:    'Nhóm khách hàng' ,
                            focusNode: _focusNode,
                            controller: textEditingController,
                            textInputAction: TextInputAction.done,
                            validates: [
                              EmptyValidate(),
                              //PasswordValidate(),
                            ],
                          ),
                            DropdownButton(
                              underline: SizedBox(),
                              isExpanded: true,
                              style: TextStyle(
                                  color: SECONDARY_TEXT_COLOR,
                                  fontSize: FONT_SMALL),
                              items: listCategories.map(
                                (val) {
                                  return DropdownMenuItem<CategoryModel>(
                                      value: val,
                                      child: Text(val.name),
                                      key: Key(val.type.toString()));
                                },
                              ).toList(),
                              onChanged: (val) {
                                 widget.onChange(val.type);
                                textEditingController.text = val.name;
                              },
                            ),
                          ]),
                      )
                    ]),
              ),
            ],
          );
        //return Center(child: MenuSkeletonWidget());
  }

  @override
  onClick(String id) {
  }
}
