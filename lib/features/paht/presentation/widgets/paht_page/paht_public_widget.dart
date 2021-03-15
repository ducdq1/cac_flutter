import 'package:citizen_app/features/common/widgets/failure_widget/no_network_failure_widget.dart';
import 'package:citizen_app/features/paht/presentation/bloc/public_paht_bloc/public_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/skeleton_paht_list_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

class PahtPublic extends StatefulWidget {
  @override
  _PahtPublicState createState() => _PahtPublicState();
}

class _PahtPublicState extends State<PahtPublic> {
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
    BlocProvider.of<PublicPahtBloc>(context).add(
      ListPublicPahtFetchingEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: RefreshIndicator(
            onRefresh: () async => handleRefresh(context),
            child: BlocConsumer<PublicPahtBloc, PublicPahtState>(
                listener: (context, state) {
              _refreshCompleter?.complete();
              _refreshCompleter = Completer();
            }, builder: (context, state) {
              if (state is PublicPahtFailure) {
                return NoNetworkFailureWidget(
                    message: state.error.toString(),
                    onPressed: () {
                      BlocProvider.of<PublicPahtBloc>(context).add(
                        ListPublicPahtFetchingEvent(),
                      );
                    });
              }
              if (state is PublicPahtSuccess) {
                return ListViewPahtsWidget(
                  hasReachedMax: state.hasReachedMax,
                  pahts: state.paht,
                  isPersonal: false,
                  scrollController: scrollController,
                  loadmore: state.hasReachedMax ? false : true,
                );
              }
              return SkeletonPahtWidget();
            })));
  }
}
