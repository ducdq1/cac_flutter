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
      this.BUSINESS_HOUR});
}

class PahtDetailArgument {
  final PahtModel poiDetail;
  final String id;
  final String title;

  PahtDetailArgument({this.id, this.title, this.poiDetail});
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
    //loadmore = widget.loadmore;
    return Padding(
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
                    return loadmore && index >= widget.pahts.length - 1
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
                                          id: widget.pahts[index].id
                                              .toString()),
                                    );
                                    Navigator.pop(context);
                                  },
                                  bloc:
                                      BlocProvider.of<PublicPahtBloc>(context));
                            },
                            onEdit: () {
                              List<MediaFromServer> listMedia = [];
                              if (widget.pahts[index].placeImages != null &&
                                  widget.pahts[index].placeImages.isNotEmpty) {
                                for (var item
                                    in widget.pahts[index].placeImages) {
                                  MediaFromServer photo = MediaFromServer(
                                      id: item.id,
                                      type: 'photo',
                                      url: item.imageUrl,
                                      relUrl: item.imageThumbUrl);
                                  listMedia.add(photo);
                                }
                              }
                              Navigator.pushNamed(context, ROUTER_CREATE_PAHT,
                                      arguments: UpdatePahtArgument(
                                          content: widget.pahts[index].name,
                                          address: widget.pahts[index].address,
                                          latitude: widget.pahts[index].lat
                                              .toString(),
                                          longitude: widget.pahts[index].lng
                                              .toString(),
                                          listMedia: listMedia,
                                          poiType:
                                              widget.pahts[index].fromPoiType,
                                          pahtId:
                                              widget.pahts[index].id.toString(),
                                          phone: widget.pahts[index].phone,
                                          hyperlink:
                                              widget.pahts[index].hyperlink,
                                          BUSINESS_HOUR:
                                              widget.pahts[index].businessHour))
                                  .then((value) {
                                if (value != null) {
                                  BlocProvider.of<PublicPahtBloc>(context).add(
                                    ReloadListEvent(), //ListPublicPahtFetchingEvent(isReload: true),
                                  );
                                }
                              });
                            },
                            isPersonal: widget.isPersonal,
                            commentCount: 0,
                            updatedTime: widget.pahts[index].updatedDate != null
                                ? widget.pahts[index].updatedDate
                                : widget.pahts[index].createdDate,
                            image: widget.pahts[index].placeImages == null ||
                                    widget.pahts[index].placeImages.length == 0
                                ? null
                                : widget
                                    .pahts[index].placeImages[0].imageThumbUrl,
                            address: widget.pahts[index].address,
                            name: widget.pahts[index].name,
                            status: widget.pahts[index].approveStatus,
                            fromCategory:
                                widget.pahts[index].fromCategory != null
                                    ? widget.pahts[index].fromCategory.name
                                    : '',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                ROUTER_DETAILED_PAHT,
                                arguments: PahtDetailArgument(
                                    poiDetail: widget.pahts[index],
                                    id: widget.pahts[index].id.toString(),
                                    title: widget.pahts[index].name),
                              );
                            },
                          );
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
    );
  }
}
