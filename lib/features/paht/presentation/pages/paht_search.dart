import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:citizen_app/features/common/widgets/failure_widget/failure_widget.dart';
import 'package:citizen_app/features/common/widgets/widgets.dart';
import 'package:citizen_app/features/paht/data/models/models.dart';
import 'package:citizen_app/features/paht/presentation/bloc/personal_paht_bloc/personal_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/public_paht_bloc/public_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/skeleton_paht_list_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/widgets.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchArgument {
  final bool isSaled;
  final bool isApproveAble;
  SearchArgument({this.isSaled = false,this.isApproveAble});
}

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
  bool isSaled = false;
  bool isApproveAble = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SearchArgument args =
        ModalRoute.of(context).settings.arguments as SearchArgument;
    if (args != null) {
      isSaled = args.isSaled;
      isApproveAble = args.isApproveAble;
    }
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: widget.searchPahtType == 0
            ? BlocProvider<PublicPahtBloc>(
                create: (context) => singleton<PublicPahtBloc>()
                  ..add(ListPublicPahtFetchingEvent(offset: 0, limit: 10,isApproveAble: isApproveAble)),
                child: BlocConsumer<PublicPahtBloc, PublicPahtState>(
                    listener: (context, state) {
                  if (state is PublicPahtFailure) {
                    // Fluttertoast.showToast(
                    //     msg: state.error.toString()  );
                  }
                }, builder: (context, state) {
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
                                    search: searchController.text.trim(), isApproveAble: isApproveAble));
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
                                  search: searchController.text.trim(), isApproveAble: isApproveAble,));
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
                              isApproveAble: isApproveAble,
                              // isSearchPage: true,
                            )
                          : state is PublicPahtFailure
                              ? NoNetworkFailureWidget(
                                  message:
                                      state.error.toString() == "UNAUTHORIZED"
                                          ? trans(MESSAGE_SESSION_EXPIRED)
                                          : state.error.toString(),
                                  onPressed: () {
                                    BlocProvider.of<PublicPahtBloc>(context)
                                        .add(
                                      ListPublicPahtFetchingEvent( isApproveAble: isApproveAble,),
                                    );
                                  })
                              : SkeletonPahtWidget());
                }))
            : BlocProvider<PersonalPahtBloc>(
                create: (context) => singleton<PersonalPahtBloc>()
                  ..add(ListPersonalPahtFetchingEvent(
                      offset: 0, limit: 10, isSaled: isSaled)),
                child: BlocConsumer<PersonalPahtBloc, PersonalPahtState>(
                    listener: (context, state) {
                  if (state is PersonalPahtFailure) {
                    Fluttertoast.showToast(msg: state.error.toString());
                  }
                }, builder: (context, state) {
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
                                    search: searchController.text.trim(),
                                    isSaled: isSaled));
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
                                  search: searchController.text.trim(),
                                  isSaled: isSaled));
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
                              isSaled: isSaled,
                        isApproveAble: isApproveAble,
                            )
                          : state is PersonalPahtSuccess
                              ? ListViewPahtsWidget(
                                  hasReachedMax: state.hasReachedMax,
                                  pahts: state.paht,
                                  isPersonal: true,
                                  loadmore: state.hasReachedMax ? false : true,
                                  paddingBottom: 00,
                                  isSaled: isSaled,

                                )
                              : state is PersonalPahtFailure
                                  ? NoNetworkFailureWidget(
                                      message: state.error.toString() ==
                                              "UNAUTHORIZED"
                                          ? trans(MESSAGE_SESSION_EXPIRED)
                                          : state.error.toString(),
                                      onPressed: () {
                                        BlocProvider.of<PersonalPahtBloc>(
                                                context)
                                            .add(
                                          ListPersonalPahtFetchingEvent(
                                              isSaled: isSaled),
                                        );
                                      })
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
