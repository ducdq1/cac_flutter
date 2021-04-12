import 'dart:async';

import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/resources/routers.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_bloc.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_state.dart';
import 'package:citizen_app/features/common/blocs/bottom_navigation/bottom_navigation_bloc.dart';
import 'package:citizen_app/features/common/dialogs/confirm_dialog.dart';
import 'package:citizen_app/features/common/widgets/failure_widget/no_network_failure_widget.dart';
import 'package:citizen_app/features/common/widgets/layouts/base_layout_widget.dart';
import 'package:citizen_app/features/paht/presentation/bloc/personal_paht_bloc/personal_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/public_paht_bloc/public_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/pages/pages.dart';
import 'package:citizen_app/features/paht/presentation/pages/paht_page.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/paht_list_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/skeleton_paht_list_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../injection_container.dart';

class SaledQuotation extends StatefulWidget {
  @override
  _SaledQuotationState createState() => _SaledQuotationState();
}

class _SaledQuotationState extends State<SaledQuotation> {
  Completer<void> _refreshCompleter;
  bool isRefresh = false;
  final scrollController = ScrollController();
  final scrollThreshold = 200.0;

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
    BlocProvider.of<PersonalPahtBloc>(context).add(
      ListPersonalPahtFetchingEvent(offset: 0, limit: 10, isSaled: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PersonalPahtBloc>(
            create: (context) => singleton<PersonalPahtBloc>()
              ..add(ListPersonalPahtFetchingEvent(offset: 0, limit: 10, isSaled: true))),
      ],
      child: BlocBuilder<PersonalPahtBloc, PersonalPahtState>(
        builder: (BuildContext context, PersonalPahtState state) {
          return BaseLayoutWidget(
              title: 'Danh sách đã bán',
              actions: [
                InkWell(
                  child: SvgPicture.asset(
                    SVG_ASSETS_PATH + 'icon_search.svg',
                    color: Colors.white,
                    width: SIZE_ICON_ACTIONS,
                    height: SIZE_ICON_ACTIONS,
                  ),
                  onTap: () {
                      Navigator.pushNamed(context, ROUTER_SEARCH_PERSONAL_PAHT, arguments: SearchArgument(isSaled: true));
                  },
                ),
                SizedBox(
                  width: 10,
                ),
              ],
              body: Container(
                  child: RefreshIndicator(
                      onRefresh: () async => handleRefresh(context),
                      child: BlocConsumer<PersonalPahtBloc, PersonalPahtState>(
                          listener: (context, state) {
                        if (state is PersonalPahtFailure &&
                            state.error.toString() == "UNAUTHORIZED") {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              ROUTER_SIGNIN, (Route<dynamic> route) => false);
                        }
                        _refreshCompleter?.complete();
                        _refreshCompleter = Completer();
                      }, builder: (context, state) {
                        if (state is PersonalPahtFailure) {
                          return NoNetworkFailureWidget(
                              message: state.error.toString() == "UNAUTHORIZED"
                                  ? trans(MESSAGE_SESSION_EXPIRED)
                                  : state.error.toString(),
                              onPressed: () {
                                BlocProvider.of<PersonalPahtBloc>(context).add(
                                  ListPersonalPahtFetchingEvent(offset: 0, limit: 10,isSaled: true),
                                );
                              });
                        }
                        if (state is PersonalPahtSuccess) {
                          return ListViewPahtsWidget(
                            hasReachedMax: state.hasReachedMax,
                            pahts: state.paht,
                            isPersonal: true,
                            scrollController: scrollController,
                            loadmore: state.hasReachedMax ? false : true,
                             isApproveAble: false,
                            isSaled: true,
                          );
                        }
                        return SkeletonPahtWidget();
                      }))));
        },
      ),
    );
  }
}
