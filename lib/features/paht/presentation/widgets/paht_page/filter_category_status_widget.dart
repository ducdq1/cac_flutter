import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/utils.dart';
import 'package:citizen_app/features/paht/presentation/bloc/category_paht_bloc/category_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/personal_paht_bloc/personal_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/public_paht_bloc/public_paht_bloc.dart';

import 'package:citizen_app/features/paht/presentation/bloc/status_paht_bloc/status_paht_bloc.dart';

import 'package:citizen_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeleton_text/skeleton_text.dart';

const BUTTON_CATEGORY_COLOR = Color(0xffEBEEF0);
const TEXT_CATEGORY_COLOR = Color(0xff4B4B4B);
const TEXT_CHOSEN_CATEGORY_COLOR = Colors.white;

class FilterCategoryContainer extends StatefulWidget {
  final int indexTab;
  final bool isRefresh;
  FilterCategoryContainer({@required this.indexTab, this.isRefresh});

  @override
  State<FilterCategoryContainer> createState() =>
      _FilterCategoryContainerState();
}


class _FilterCategoryContainerState extends State<FilterCategoryContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: widget.indexTab == 1 ? 225 : 130,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
        child: Column(
          children: [
            BlocProvider<CategoryPahtBloc>(
                create: (context) => singleton<CategoryPahtBloc>()
                  ..add(ListCategoriesFetched()),
                child: BlocBuilder<CategoryPahtBloc, CategoryPahtState>(
                    builder: (context, state) {
                      if (state is CategoryPahtSuccess) {
                        return FilterField(
                          filterType: 0,
                          titleFilter: trans(TITLE_FIELD_1),
                          list: state.listCategories,
                          indexTab: widget.indexTab,
                          isRefresh: widget.isRefresh,
                        );
                      }
                      return FilterField(
                        filterType: 0,
                        titleFilter: trans(TITLE_FIELD_1),
                        list: null,
                        categoryLoading: true,
                        indexTab: widget.indexTab,
                        isRefresh: widget.isRefresh,
                      );
                    }))
            ,
            widget.indexTab == 1
                ?  BlocBuilder<StatusPahtBloc, StatusPahtState>(
                builder: (context, state) {
                  if (state is StatusPahtSuccess) {
                    return FilterField(
                      filterType: 1,
                      titleFilter: trans(TITLE_FIELD_2),
                      list: state.listStatus,
                      indexTab: widget.indexTab,
                      isRefresh: widget.isRefresh,
                    );
                  }
                  return FilterField(
                    filterType: 1,
                    titleFilter: trans(TITLE_FIELD_2),
                    list: null,
                    categoryLoading: true,
                    indexTab: widget.indexTab,
                    isRefresh: widget.isRefresh,
                  );
                })
                : SizedBox(),
          ],
        ),
      ),
      decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xffD8D8D8), width: 5),
          )),
    );
  }
}

class FilterField extends StatefulWidget {
  final String titleFilter;
  final List<dynamic> list;
  final bool categoryLoading;
  final int indexTab;
  final int filterType;
  final bool isRefresh;
  FilterField(
      {@required this.filterType,
        @required this.titleFilter,
        @required this.list,
        this.categoryLoading: false,
        @required this.indexTab,
        this.isRefresh});

  @override
  State<FilterField> createState() => _FilterFieldState();
}

class _FilterFieldState extends State<FilterField> {
   List<int> isChosenCategories = [];
   List<int> isChosenStatus = [];
  bool isChooseAll = true;
  bool _isRefresh = false;
  bool isFilter = false;
  @override
  void initState() {
    // isChosenCategories = List.generate(
    //     widget.list != null ? widget.list.length : 100, (index) => false);
    // isChosenStatus = List.generate(
    //     widget.list != null ? widget.list.length : 100, (index) => false);
    // isChosenCategories = [];
    // isChosenStatus = [];
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    if (_isRefresh != widget.isRefresh) {
      for (int i = 0; i < isChosenCategories.length; i++) {
        setState(
              () {
            //isChosenCategories[i] = false;
          },
        );
      }

      for (int i = 0; i < isChosenStatus.length; i++) {
        setState(
              () {
            //isChosenStatus[i] = false;
          },
        );
      }
      _isRefresh = widget.isRefresh;
      isChooseAll = true;
    }

    List<dynamic> listData = [];
    if (widget.list != null) {
      if (widget.filterType == 0) {
        listData = widget.list ?? [];

      } else if (widget.filterType == 1) {
        // listData.add(widget.list[1]);
        //for (int i = 0; i < widget.list.length; i++) {
        // if (widget.list[i].name != trans(PROCESSING)) {

        listData = widget.list ?? [];
        // }
        // }
      }
    }

    List listIndexChosenStatus = [];
    List listIndexChosenCategories = [];
    List<String> listChosenCategories = [];
    List<String> listChosenStatus = [];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.titleFilter,
              style: TextStyle(
                  fontSize: FONT_EX_SMALL,
                  fontWeight: FontWeight.bold,
                  color: SECONDARY_TEXT_COLOR),
            ),
            FlatButton(
              onPressed: () {
                isFilter = true;
                if (widget.filterType == 0) {
                  isChosenCategories.clear();
                } else if (widget.filterType == 1) {
                  isChosenStatus.clear();
                }

                if (widget.indexTab == 0) {
                  BlocProvider.of<PublicPahtBloc>(context).add(
                    FilterPublicButtonPressedEvent(
                        categoryIds: listChosenCategories,
                        statusIds: listChosenStatus),
                  );
                } else if (widget.indexTab == 1) {
                  BlocProvider.of<PersonalPahtBloc>(context).add(
                    FilterPersonalButtonPressedEvent(
                        categoryIds: listChosenCategories,
                        statusIds: listChosenStatus),
                  );
                }
                setState(
                      () {
                    isChooseAll = !isChooseAll;
                  },
                );
              },
              child: Text(
                isChooseAll ? '' : trans(ACT_DESELECT_ALL),
                style: TextStyle(
                  fontSize: FONT_EX_SMALL,
                  fontWeight: FontWeight.bold,
                  color: PRIMARY_COLOR,
                ),
              ),
            )
          ],
        ),
        widget.categoryLoading
            ? SkeletonAnimation(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < 5; i++)
                    Row(
                      children: [
                        RaisedButton(
                          color: Colors.grey[300],
                          onPressed: () {},
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: BorderSide(color: Colors.grey[300]),
                          ),
                        ),
                        SizedBox(width: 8)
                      ],
                    )
                ],
              ),
            ))
            : SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < listData.length; i++)
                Row(
                  children: [
                    RaisedButton(
                      color: widget.filterType == 0
                          ? (checkCategoriesSelected(listData[i].type)
                          ? PRIMARY_COLOR
                          : BUTTON_CATEGORY_COLOR)
                          : (checkStatusSelected(listData[i].id)
                          ? PRIMARY_COLOR
                          : BUTTON_CATEGORY_COLOR
                      ),
                      onPressed: () {
                        isFilter = true;

                        if (widget.filterType == 0) {
                          setState(() {
                            // isChosenCategories[i] =
                            //     !isChosenCategories[i];
                            if(isChosenCategories.contains(listData[i].type)) {
                              isChosenCategories.remove(listData[i].type);
                            }else{
                              isChosenCategories.add(listData[i].type);
                            }
                            isChooseAll = false;
                          });
                        }

                        if (widget.filterType == 1) {
                          setState(
                                () {
                              //isChosenStatus[i] = !isChosenStatus[i];
                              if(isChosenStatus.contains(listData[i].id)){
                                isChosenStatus.remove(listData[i].id);
                              }else {
                                isChosenStatus.add(listData[i].id);
                              }
                              isChooseAll = false;
                            },
                          );
                        }

                        onFilterPressed(
                          isChosenStatus: isChosenStatus,
                          listChosenStatus: listChosenStatus,
                          isChosenCategories: isChosenCategories,
                          listChosenCategories: listChosenCategories,
                        );
                        if (widget.indexTab == 0) {
                          BlocProvider.of<PublicPahtBloc>(context).add(
                            FilterPublicButtonPressedEvent(
                                categoryIds: listChosenCategories,
                                statusIds: listChosenStatus),
                          );
                        } else if (widget.indexTab == 1) {
                          BlocProvider.of<PersonalPahtBloc>(context).add(
                            FilterPersonalButtonPressedEvent(
                                categoryIds: listChosenCategories,
                                statusIds: listChosenStatus),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            widget.filterType == 0
                                ? SVG_ASSETS_PATH + 'icon_environment.svg'
                                : getIcon(listData[i].id),
                            width: 20,
                            height: 20,
                            color: widget.filterType == 0
                                ? (checkCategoriesSelected(listData[i].type)
                                ? TEXT_CHOSEN_CATEGORY_COLOR
                                : TEXT_CATEGORY_COLOR
                            )
                                : (checkStatusSelected(listData[i].id)
                                ? TEXT_CHOSEN_CATEGORY_COLOR
                                : TEXT_CATEGORY_COLOR
                            ),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            listData[i].name,
                            style: GoogleFonts.inter(
                              color: widget.filterType == 0
                                  ? (checkCategoriesSelected(listData[i].type)
                                  ? TEXT_CHOSEN_CATEGORY_COLOR
                                  : TEXT_CATEGORY_COLOR
                              )
                                  : (checkStatusSelected(listData[i].id)
                                  ? TEXT_CHOSEN_CATEGORY_COLOR
                                  : TEXT_CATEGORY_COLOR
                              ),
                              fontSize: FONT_MIDDLE,
                              fontWeight: widget.filterType == 0
                                  ? (checkCategoriesSelected(listData[i].type)
                                  ? FontWeight.bold
                                  : null
                              )
                                  : (checkStatusSelected(listData[i].id)
                                  ? FontWeight.bold
                                  : null
                              ),
                            ),
                          ),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    )
                  ],
                )
            ],
          ),
        )
      ],
    );
  }

  bool checkCategoriesSelected(int id){

    for(int i=0; i<isChosenCategories.length;i++ ){
      if(id == isChosenCategories[i]){
        return true;
      }
    }

    return false;
  }

  bool checkStatusSelected(int status){
    for(int i=0; i<isChosenStatus.length;i++ ){
      if(status == isChosenStatus[i]){
        return true;
      }
    }

    return false;
  }
}

onFilterPressed({
  @required List isChosenStatus,
  @required List listChosenStatus,
  @required List isChosenCategories,
  @required List listChosenCategories,
}) {

  for (int i = 0; i < isChosenStatus.length; i++) {
    listChosenStatus.add(isChosenStatus[i].toString());
  }

  for (int i = 0; i < isChosenCategories.length; i++) {
    listChosenCategories.add(isChosenCategories[i].toString());
  }
}
