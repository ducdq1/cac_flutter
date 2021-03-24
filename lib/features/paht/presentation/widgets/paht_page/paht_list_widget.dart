import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/dialogs/delete_confirm_dialog.dart';
import 'package:citizen_app/features/common/widgets/failure_widget/failure_widget.dart';
import 'package:citizen_app/features/paht/data/models/models.dart';
import 'package:citizen_app/features/paht/domain/entities/business_hour_entity.dart';
import 'package:citizen_app/features/paht/presentation/bloc/personal_paht_bloc/personal_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/public_paht_bloc/public_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/bottom_loader_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class UpdatePahtArgument {
  final String content;
  final String address;
  final String latitude;
  final String longitude;
  final int poiType;
  final List<dynamic> listMedia;
  final String pahtId;
  final String hyperlink;
  final String phone;
  final List<BusinessHourEntity> BUSINESS_HOUR;
  final PahtModel pahtModel;

  UpdatePahtArgument(
      {this.content,
      this.address,
      this.listMedia,
      this.latitude,
      this.longitude,
      this.pahtId,
      this.poiType,
      this.hyperlink,
      this.phone,
      this.BUSINESS_HOUR,
      this.pahtModel});
}

class PahtDetailArgument {
  final PahtModel poiDetail;
  final String id;
  final String title;
  String productCode;
  PahtDetailArgument({this.id, this.title, this.poiDetail,this.productCode});
}

class ListViewPahtsWidget extends StatefulWidget {
  final List<PahtModel> pahts;
  final bool isPersonal;
  final bool hasReachedMax;
  final ScrollController scrollController;
  final bool loadmore;
  final double paddingBottom;
  ListViewPahtsWidget(
      {@required this.pahts,
      @required this.isPersonal,
      @required this.hasReachedMax,
      this.scrollController,
      this.loadmore = false,
      this.paddingBottom = 100});

  @override
  _ListViewPahtsWidgetState createState() => _ListViewPahtsWidgetState();
}

class _ListViewPahtsWidgetState extends State<ListViewPahtsWidget> {
  bool isLoadingVertical = false;
  bool loadmore = false;

  Future _loadMoreVertical() async {
    if (widget.hasReachedMax) {
      return;
    }
    setState(() {
      isLoadingVertical = true;
    });

    setState(() {
      loadmore = true;
    });
    // Add in an artificial delay
    await new Future.delayed(const Duration(seconds: 1));
    print("Loadmore...");
    if (widget.isPersonal) {
      BlocProvider.of<PersonalPahtBloc>(context).add(
        ListPersonalPahtFetchingEvent(),
      );
    } else {
      BlocProvider.of<PublicPahtBloc>(context).add(
        ListPublicPahtFetchingEvent(),
      );
    }

    setState(() {
      isLoadingVertical = false;
    });
  }

  handleRefresh(context) {
    if (widget.isPersonal) {
      BlocProvider.of<PersonalPahtBloc>(context).add(
        PersonalPahtRefreshRequestedEvent(),
      );
    } else {
      BlocProvider.of<PublicPahtBloc>(context).add(
        PublicPahtRefreshRequestedEvent(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    loadmore = widget.loadmore;
    return AnimationLimiter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: widget.pahts.length != 0
            ? LazyLoadScrollView(
                isLoading: isLoadingVertical,
                onEndOfPage: () => _loadMoreVertical(),
                child: RefreshIndicator(
                  onRefresh: () async => {handleRefresh(context)},
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: widget.paddingBottom),
                    itemBuilder: (BuildContext context, int index) {
                      return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                      child:  loadmore && index >= widget.pahts.length - 1
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: BottomLoaderWidget(),
                            )
                          : PAHTITemWidget(
                              onDelete: () {
                                showDeleteConfirmDialog(
                                    context: context,
                                    onSubmit: () {
                                      BlocProvider.of<PublicPahtBloc>(context)
                                          .add(
                                        DeleteButtonEvent(
                                            id: widget.pahts[index].quotationID
                                                .toString()),
                                      );
                                      Navigator.pop(context);
                                    },
                                    bloc:
                                        BlocProvider.of<PublicPahtBloc>(context));
                              },
                              onEdit: () {

                                Navigator.pushNamed(context, ROUTER_CREATE_PAHT,
                                        arguments: UpdatePahtArgument(
                                            content: widget.pahts[index].cusName,
                                            address: widget.pahts[index].cusAddress
                                        ))
                                    .then((value) {
                                  if (value != null) {
                                    BlocProvider.of<PublicPahtBloc>(context).add(
                                      ReloadListEvent(), //ListPublicPahtFetchingEvent(isReload: true),
                                    );
                                  }
                                });
                              },
                              isPersonal: widget.isPersonal,
                              pahtModel: widget.pahts[index] ,
                              onTap: () {
                                // Navigator.pushNamed(
                                //   context,
                                //   ROUTER_DETAILED_PAHT,
                                //   arguments: PahtDetailArgument(
                                //       poiDetail: widget.pahts[index],
                                //       id: widget.pahts[index].id.toString(),
                                //       title: widget.pahts[index].name),
                               // );
                              },
                            )),),);
                    },
                    // itemCount: widget.hasReachedMax
                    //     ? widget.pahts.length
                    //     : widget.pahts.length + 1,
                    itemCount: widget.pahts.length,
                    controller: widget.scrollController,
                  ),
                ),
              )
            : NoDataFailureWidget(),
      ),
    );
  }
}
