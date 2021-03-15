import 'package:citizen_app/features/common/widgets/failure_widget/no_network_failure_widget.dart';
import 'package:citizen_app/features/paht/presentation/bloc/personal_paht_bloc/personal_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/skeleton_paht_list_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

class PahtPersonal extends StatefulWidget {
  @override
  _PahtPersonalState createState() => _PahtPersonalState();
}

class _PahtPersonalState extends State<PahtPersonal> {
  Completer<void> _refreshCompleter;
  bool isRefresh = false;
  final scrollController = ScrollController();
  final scrollThreshold = 200.0;
  @override
  void initState() {
    _refreshCompleter = Completer<void>();
   // scrollController.addListener(onScroll);
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
      PersonalPahtRefreshRequestedEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: RefreshIndicator(
            onRefresh: () async => handleRefresh(context),
            child: BlocConsumer<PersonalPahtBloc, PersonalPahtState>(
                listener: (context, state) {
              _refreshCompleter?.complete();
              _refreshCompleter = Completer();
            }, builder: (context, state) {
              if (state is PersonalPahtFailure) {
                return NoNetworkFailureWidget(
                    message: state.error.toString(),
                    onPressed: () {
                      BlocProvider.of<PersonalPahtBloc>(context).add(
                        ListPersonalPahtFetchingEvent(offset: 1),
                      );
                    });
              }

              if (state is PersonalPahtSuccess  ) {
                  return ListViewPahtsWidget(
                    hasReachedMax: state.hasReachedMax,
                    pahts: state.paht,
                    isPersonal: true,
                    scrollController: scrollController,
                    loadmore: state.hasReachedMax ? false: true,
                  );
              }

              if (state is PersonalPahtLoadmore) {
                return ListViewPahtsWidget(
                    hasReachedMax: state.hasReachedMax,
                    pahts: state.paht,
                    isPersonal: true,
                    scrollController: scrollController,
                    loadmore: state.hasReachedMax ? false: true,
                );
              }

              return SkeletonPahtWidget();
            })));
  }
}
