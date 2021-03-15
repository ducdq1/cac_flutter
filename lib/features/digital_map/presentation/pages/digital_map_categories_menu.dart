import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/widgets/buttons/outline_custom_button.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:citizen_app/features/common/widgets/layouts/base_layout_widget.dart';
import 'package:citizen_app/features/digital_map/presentation/blocs/type_category/type_category_bloc.dart';
import 'package:citizen_app/features/digital_map/presentation/widgets/filter_card_widget.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DigitalMapCategoriesMenu extends StatefulWidget {
  final Function handleSubmitButton;
  DigitalMapCategoriesMenu({Key key, this.handleSubmitButton})
      : super(key: key);

  @override
  _DigitalMapCategoriesMenuState createState() =>
      _DigitalMapCategoriesMenuState();
}

class _DigitalMapCategoriesMenuState extends State<DigitalMapCategoriesMenu>
    implements OnButtonClickListener {
  @override
  Widget build(BuildContext context) {
    return BaseLayoutWidget(
      title: trans(TITILE_FILTER_MENU),
      centerTitle: true,
      body: BlocProvider<TypeCategoryBloc>(
        create: (context) => TypeCategoryBloc()..add(ListTypeCategoryFetched()),
        child: BlocBuilder<TypeCategoryBloc, TypeCategoryState>(
            builder: (BuildContext context, TypeCategoryState state) {
          if (state is TypeCategoryFailure) {
            Fluttertoast.showToast(msg: state.error.message.toString());
            return Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Center(
                child: Column(
                  children: [
                    Image.asset(
                      IMAGE_ASSETS_PATH + "icon_none.png",
                      height: 128,
                      width: 160,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: 142,
                      child: OutlineCustomButton(
                          label: trans(RETRY), ctx: this, id: 'primary_btn'),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            );
          } else if (state is TypeCategorySuccess) {
            return Padding(
                padding: EdgeInsets.only(top: 25, left: 16, right: 16),
                child: ListView.builder(
                  itemCount: state.listTypeCategory.length,
                  itemBuilder: (context, index) => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        state.listTypeCategory[index].name,
                        style: TextStyle(
                            fontSize: FONT_EX_LARGE,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 25),
                      Wrap(
                        direction: Axis.horizontal,
                        spacing: 0.0,
                        runSpacing: 4.0,
                        children: state.listTypeCategory[index].categories
                            .asMap()
                            .map((i, category) => MapEntry(
                                  i,
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      widget.handleSubmitButton(category.name);
                                    },
                                    child: FilterCardWidget(
                                      icon: category.iconName,
                                      text: category.name,
                                      network: true,
                                    ),
                                  ),
                                ))
                            .values
                            .toList(),
                      ),
                      SizedBox(height: 30),
                      Divider(
                        color: Colors.black.withOpacity(0.3),
                        thickness: 0.3,
                        height: 0,
                        indent: 0,
                        endIndent: 0,
                      )
                    ],
                  ),
                ));
          } else
            return Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(PRIMARY_COLOR),
              ),
            );
        }),
      ),
    );
  }

  @override
  onClick(String id) {
    BlocProvider.of<TypeCategoryBloc>(context).add(ListTypeCategoryFetched());
  }
}
