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
import 'package:citizen_app/features/paht/presentation/bloc/category_paht_bloc/category_paht_bloc.dart';
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
    return BlocBuilder<CategoryPahtBloc, CategoryPahtState>(
      builder: (context, state) {
        if (state is CategoryPahtSuccess) {
          if (widget.initialValue != null) {
            for (int i = 0; i < state.listCategories.length; i++) {
              if (int.parse(widget.initialValue) ==
                  state.listCategories[i].type) {
                textEditingController.text = state.listCategories[i].name;
              }
            }
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  SvgPicture.asset(
                    SVG_ASSETS_PATH + 'icon_category.svg',
                    width: SIZE_ICON,
                    height: SIZE_ICON,
                  ),
                ],
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: InputWithTitleWidget(
                          titleInput: trans(LABEL_POI_TYPE),
                          isRequired: true,
                          paddingTop: 5,
                          fontSize: FONT_MIDDLE,
                          textFieldWidget: Stack(children: [
                            InputValidateCustomWidget(
                              textInputType: TextInputType.text,
                              limitLength: 15,
                              scrollPaddingForTop: true,
                              scrollPadding: 200,
                              isShowBorder: false,
                              readOnly: true,
                              focusNode: _focusNode,
                              controller: textEditingController,
                              hintText: widget.initialValue == null
                                  ? trans(LABEL_POI_TYPE_CHOOSE)
                                  : '',
                              validates: [
                                EmptyValidate(),
                              ],
                              focusError: (FocusNode focusNode) {},
                            ),
                            DropdownButton(
                              underline: SizedBox(),
                              isExpanded: true,
                              style: TextStyle(
                                  color: SECONDARY_TEXT_COLOR,
                                  fontSize: FONT_SMALL),
                              items: state.listCategories.map(
                                (val) {
                                  return DropdownMenuItem<CategoryModel>(
                                      value: val,
                                      child: Text(val.name),
                                      key: Key(val.type.toString()));
                                },
                              ).toList(),
                              onChanged: (val) {
                                widget.onChange(val.type.toString());
                                textEditingController.text = val.name;
                              },
                            ),
                          ]),
                        ),
                      )
                    ]),
              ),
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  SvgPicture.asset(
                    SVG_ASSETS_PATH + 'icon_category.svg',
                    width: SIZE_ICON,
                    height: SIZE_ICON,
                  ),
                ],
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: InputWithTitleWidget(
                            titleInput: trans(LABEL_POI_TYPE),
                            isRequired: true,
                            paddingTop: 5,
                            fontSize: FONT_MIDDLE,
                            textFieldWidget: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: BORDER_COLOR, width: 0.6),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, top: 0, bottom: 0),
                                child: DropdownButton(
                                  underline: SizedBox(),
                                  isExpanded: true,
                                  style: TextStyle(
                                      color: SECONDARY_TEXT_COLOR,
                                      fontSize: FONT_SMALL),
                                  hint: Text(trans(LABEL_POI_TYPE_CHOOSE)
                                      //style: TextStyle(color: Colors.blue),
                                      ),
                                  items: [trans(LABEL_POI_TYPE_CHOOSE)].map(
                                    (val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: Text(val),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (val) {
                                    setState(
                                      () {},
                                    );
                                  },
                                ),
                              ),
                            )),
                      )
                    ]),
              ),
            ],
          );
        }
        //return Center(child: MenuSkeletonWidget());
      },
    );
  }

  @override
  onClick(String id) {
  }
}
