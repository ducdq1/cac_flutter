import 'dart:async';

import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/resources/routers.dart';
import 'package:citizen_app/features/common/widgets/failure_widget/no_network_failure_widget.dart';
import 'package:citizen_app/features/common/widgets/layouts/base_layout_widget.dart';
import 'package:citizen_app/features/paht/presentation/bloc/public_paht_bloc/public_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/pages/paht_page.dart';
import 'package:citizen_app/features/paht/presentation/pages/paht_search.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/ckbg_list_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/skeleton_paht_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../injection_container.dart';

class ApproveQuotation extends StatefulWidget {
  @override
  _ApproveQuotationState createState() => _ApproveQuotationState();
}

class _ApproveQuotationState extends State<ApproveQuotation> {
  Completer<void> _refreshCompleter;
  bool isRefresh = false;
  final scrollController = ScrollController();
  final scrollThreshold = 200.0;
  bool isFilter = false;
  @override
  void initState() {
    _refreshCompleter = Completer<void>();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void handleRefresh(context) {
    setState(() {
      isRefresh = !isRefresh;
    });
    BlocProvider.of<PublicPahtBloc>(context).add(
      ListCKBGFetchingEvent(offset: 0, limit: 100),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PublicPahtBloc>(
            create: (context) =>
            singleton<PublicPahtBloc>()
              ..add(ListPublicPahtFetchingEvent(
                  offset: 0, limit: 10, isApproveAble: true))),
      ],
      child: BlocBuilder<PublicPahtBloc, PublicPahtState>(
        builder: (BuildContext context, PublicPahtState state) {
          return BaseLayoutWidget(
              title: 'Danh sách Báo giá',
              actions: [
                InkWell(
                  child: SvgPicture.asset(
                    SVG_ASSETS_PATH + 'icon_search.svg',
                    color: Colors.white,
                    width: SIZE_ICON_ACTIONS,
                    height: SIZE_ICON_ACTIONS,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, ROUTER_SEARCH_PUBLIC_PAHT,
                        arguments: SearchArgument(isApproveAble: true));
                  },
                ),
                SizedBox(
                  width: 10,
                ),
              ],
              body:  Stack(
                  children: [
                  // Visibility(
                  // visible: isFilter,
                  // child: FilterCategoryContainer(indexTab: 1)),
              Padding(
                  padding: EdgeInsets.only(
                      top: isFilter ? 130 :0 ),
                  child: Container(
                  child: RefreshIndicator(
                      onRefresh: () async => handleRefresh(context),
                      child: BlocConsumer<PublicPahtBloc, PublicPahtState>(
                          listener: (context, state) {
                            if (state is PublicPahtFailure &&
                                state.error.toString() == "UNAUTHORIZED") {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  ROUTER_SIGNIN, (Route<
                                  dynamic> route) => false);
                            }
                            _refreshCompleter?.complete();
                            _refreshCompleter = Completer();
                          }, builder: (context, state) {
                        if (state is PublicPahtFailure) {
                          return NoNetworkFailureWidget(
                              message: state.error.toString() == "UNAUTHORIZED"
                                  ? trans(MESSAGE_SESSION_EXPIRED)
                                  : state.error.toString(),
                              onPressed: () {
                                BlocProvider.of<PublicPahtBloc>(context).add(
                                  ListCKBGFetchingEvent(offset: 0,
                                      limit: 100),
                                );
                              });
                        }
                        if (state is ListCKBGSuccess) {
                          return ListViewCKBGWidget(
                              hasReachedMax: state.hasReachedMax,
                              pahts: state.paht,
                              isPersonal: true,
                              scrollController: scrollController,
                              loadmore: state.hasReachedMax ? false : true
                          );
                        }

                        if (state is DeletePersonalPahtFailure) {
                          BlocProvider.of<PublicPahtBloc>(context).add(
                            ListCKBGFetchingEvent(
                                offset: 0, limit: 100),
                          );
                        }
                        return SkeletonPahtWidget();
                      })))),
          ]));
        },
      ),
    );
  }
}
