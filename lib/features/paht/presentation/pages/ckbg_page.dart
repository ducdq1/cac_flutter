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

class CKBGPage extends StatefulWidget {
  @override
  _CKBGPageState createState() => _CKBGPageState();
}

class _CKBGPageState extends State<CKBGPage> {
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
              ..add(ListCKBGFetchingEvent(
                  offset: 0, limit: 100,))),
      ],
      child: BlocBuilder<PublicPahtBloc, PublicPahtState>(
        builder: (BuildContext context, PublicPahtState state) {
          return BaseLayoutWidget(
              title: 'Danh sách cam kết',
              body:  Stack(
                  children: [
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
