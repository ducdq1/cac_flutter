import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/features/common/widgets/widgets.dart';

import 'package:citizen_app/features/paht/data/models/models.dart';
import 'package:citizen_app/features/paht/presentation/bloc/personal_paht_bloc/personal_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/public_paht_bloc/public_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/skeleton_paht_list_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/widgets.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizen_app/features/common/widgets/buttons/outline_custom_button.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';

class PahtSearch extends StatefulWidget {
  final int searchPahtType;
  PahtSearch({@required this.searchPahtType});
  @override
  _PahtSearchState createState() => _PahtSearchState();
}

class _PahtSearchState extends State<PahtSearch>
    implements OnButtonClickListener {
  bool isShowClearSearch = false;
  final searchController = TextEditingController();
  final FocusNode searchFocus = FocusNode();
  var items = List<PahtModel>();
  bool isSearch = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: widget.searchPahtType == 0
            ? BlocProvider<PublicPahtBloc>(
                create: (context) => singleton<PublicPahtBloc>()
                  ..add(ListPublicPahtFetchingEvent(offset: 1, limit: 10)),
                child: BlocBuilder<PublicPahtBloc, PublicPahtState>(
                    builder: (context, state) {
                  return BaseLayoutWidget(
                      title: trans(TITLE_PAHT),
                      isTitleHeaderWidget: true,
                      titleHeaderWidget: SearchFormFieldWidget(
                        onChanged: (value) {
                          if (value.trim().isEmpty) {
                            setState(() {
                              isShowClearSearch = false;
                            });
                            BlocProvider.of<PublicPahtBloc>(context).add(
                                SearchPublicButtonPressedEvent(
                                    search: searchController.text.trim()));
                          }
                          if (value.isNotEmpty) {
                            setState(() {
                              isShowClearSearch = true;
                            });
                          }
                        },
                        onEditingComplete: () {
                          BlocProvider.of<PublicPahtBloc>(context).add(
                              SearchPublicButtonPressedEvent(
                                  search: searchController.text.trim()));
                        },
                        isSearch: isSearch,
                        isShowClearSearch: isShowClearSearch,
                        searchController: searchController,
                        searchFocus: searchFocus,
                      ),
                      body: state is PublicPahtSuccess
                          ? ListViewPahtsWidget(
                              hasReachedMax: state.hasReachedMax,
                              pahts: state.paht,
                              isPersonal: false,
                              loadmore: state.hasReachedMax ? false : true,
                        paddingBottom: 00,
                             // isSearchPage: true,
                            )
                          : state is PublicPahtFailure
                              ? Padding(
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
                                              label: trans(RETRY),
                                              ctx: this,
                                              id: 'primary_btn'),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : SkeletonPahtWidget());
                }))
            : BlocProvider<PersonalPahtBloc>(
                create: (context) => singleton<PersonalPahtBloc>()
                  ..add(ListPersonalPahtFetchingEvent(offset: 1, limit: 10 )),
                child: BlocBuilder<PersonalPahtBloc, PersonalPahtState>(
                    builder: (context, state) {
                  return BaseLayoutWidget(
                      title: trans(TITLE_PAHT),
                      centerTitle: true,
                      isTitleHeaderWidget: true,
                      titleHeaderWidget: SearchFormFieldWidget(
                        onChanged: (value) {
                          if (value.trim().isEmpty) {
                            setState(() {
                              isShowClearSearch = false;
                            });
                            BlocProvider.of<PersonalPahtBloc>(context).add(
                                SearchPersonalButtonPressedEvent(
                                    search: searchController.text.trim()));
                          }
                          if (value.isNotEmpty) {
                            setState(() {
                              isShowClearSearch = true;
                            });
                          }
                        },
                        onEditingComplete: () {
                          BlocProvider.of<PersonalPahtBloc>(context).add(
                              SearchPersonalButtonPressedEvent(
                                  search: searchController.text.trim()));
                        },
                        isSearch: isSearch,
                        isShowClearSearch: isShowClearSearch,
                        searchController: searchController,
                        searchFocus: searchFocus,
                      ),
                      body: state is PersonalPahtLoadmore
                      ? ListViewPahtsWidget(
                          hasReachedMax: state.hasReachedMax,
                          pahts: state.paht,
                          isPersonal: true,
                          loadmore: true,
                        paddingBottom: 00,
                        ):
                      state is PersonalPahtSuccess
                          ? ListViewPahtsWidget(
                              hasReachedMax: state.hasReachedMax,
                              pahts: state.paht,
                              isPersonal: true,
                              loadmore: state.hasReachedMax ? false : true,
                              paddingBottom: 00,
                            )
                          : state is PersonalPahtFailure
                              ? Padding(
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
                                              label: trans(RETRY),
                                              ctx: this,
                                              id: 'primary_btn'),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : SkeletonPahtWidget());
                })));
  }

  @override
  onClick(String id) {
    if (id == 'primary_btn') {
      if (widget.searchPahtType == 1) {
        BlocProvider.of<PersonalPahtBloc>(context).add(
            SearchPersonalButtonPressedEvent(
                search: searchController.text.trim()));
      } else if (widget.searchPahtType == 0) {
        BlocProvider.of<PublicPahtBloc>(context).add(
            SearchPublicButtonPressedEvent(
                search: searchController.text.trim()));
      }
    }
  }
}
