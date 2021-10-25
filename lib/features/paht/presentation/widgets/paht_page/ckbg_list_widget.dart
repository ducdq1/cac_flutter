import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/dialogs/delete_confirm_dialog.dart';
import 'package:citizen_app/features/common/widgets/failure_widget/failure_widget.dart';
import 'package:citizen_app/features/paht/data/models/ckbg_detail_model.dart';
import 'package:citizen_app/features/paht/data/models/ckbg_model.dart';
import 'package:citizen_app/features/paht/data/models/models.dart';
import 'package:citizen_app/features/paht/data/models/quotation_detail_model.dart';
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

class UpdateCKBGArgument {
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
  final bool isUpdateAble;
  final bool isApproveAble;
  final bool isSaled;

  UpdateCKBGArgument(
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
      this.pahtModel,
      this.isUpdateAble = true,
      this.isApproveAble = false,
      this.isSaled = false});
}

class CKGBDetailArgument {
  final CKBGDetailModel ckbgDetailModel;
  final CKBGModel ckbgDetail;
  final String id;
  final String title;
  String productCode;
  final bool isUpdateAble;
  final bool isApproveAble;
  final bool fromCategoryPage;
  final productId;

  CKGBDetailArgument(
      {this.productId,
      this.id,
      this.title,
      this.ckbgDetail,
      this.productCode,
      this.ckbgDetailModel,
      this.isUpdateAble = false,
      this.isApproveAble = false,
      this.fromCategoryPage = false});
}

class ListViewCKBGWidget extends StatefulWidget {
  final List<CKBGModel> pahts;
  final bool isPersonal;
  final bool hasReachedMax;
  final ScrollController scrollController;
  final bool loadmore;
  final double paddingBottom;
  final bool isApproveAble;
  final bool isSaled;

  ListViewCKBGWidget(
      {@required this.pahts,
      @required this.isPersonal,
      @required this.hasReachedMax,
      this.scrollController,
      this.loadmore = false,
      this.paddingBottom = 100,
      this.isApproveAble = false,
      this.isSaled = false});

  @override
  _ListViewPahtsWidgetState createState() => _ListViewPahtsWidgetState();
}

class _ListViewPahtsWidgetState extends State<ListViewPahtsWidget> {
  bool isLoadingVertical = false;
  bool loadmore = false;
  bool isApproveAble = false;
  bool isSaled = false;

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
    if (!widget.isApproveAble && widget.isPersonal) {
      BlocProvider.of<PersonalPahtBloc>(context).add(
        ListPersonalPahtFetchingEvent(),
      );
    } else {
      BlocProvider.of<PublicPahtBloc>(context).add(
        ListPublicPahtFetchingEvent(
            isApproveAble: widget.isApproveAble, isSaled: widget.isSaled),
      );
    }

    setState(() {
      isLoadingVertical = false;
    });
  }

  handleRefresh(context) {
    if (!widget.isApproveAble && widget.isPersonal) {
      BlocProvider.of<PersonalPahtBloc>(context).add(
        PersonalPahtRefreshRequestedEvent(),
      );
    } else {
      BlocProvider.of<PublicPahtBloc>(context).add(
        PublicPahtRefreshRequestedEvent(
            isApproveAble: widget.isApproveAble, isSaled: widget.isSaled),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    loadmore = widget.loadmore;
    isApproveAble = widget.isApproveAble;
    isSaled = widget.isSaled;
    return AnimationLimiter(
      child: Padding(
        padding: const EdgeInsets.all(10),
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
                              child: loadmore &&
                                      index >= widget.pahts.length - 1
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: BottomLoaderWidget(),
                                    )
                                  : PAHTITemWidget(
                                      onDelete: () {
                                        showDeleteConfirmDialog(
                                            context: context,
                                            onSubmit: () {
                                              BlocProvider.of<PublicPahtBloc>(
                                                      context)
                                                  .add(
                                                DeleteButtonEvent(
                                                    id: widget.pahts[index]
                                                        .quotationID
                                                        .toString()),
                                              );
                                              Navigator.pop(context);
                                            },
                                            bloc:
                                                BlocProvider.of<PublicPahtBloc>(
                                                    context));
                                      },
                                      onEdit: () {
                                        Navigator.pushNamed(
                                                context, ROUTER_CREATE_PAHT,
                                                arguments: UpdatePahtArgument(
                                                    pahtModel:
                                                        widget.pahts[index]))
                                            .then((value) {
                                          if (value != null) {
                                            BlocProvider.of<PublicPahtBloc>(
                                                    context)
                                                .add(
                                              ReloadListEvent(), //ListPublicPahtFetchingEvent(isReload: true),
                                            );
                                          }
                                        });
                                      },
                                      isPersonal: widget.isPersonal,
                                      pahtModel: widget.pahts[index],
                                      onTap: () {
                                        if (!widget.isApproveAble &&
                                            !widget.isSaled) {
                                          Navigator.pushNamed(
                                                  context, ROUTER_CREATE_PAHT,
                                                  arguments: UpdatePahtArgument(
                                                      pahtModel:
                                                          widget.pahts[index],
                                                      isUpdateAble: widget
                                                              .pahts[index]
                                                              .status ==
                                                          0 //moi tao moi duoc phep cap nhat
                                                      ))
                                              .then((value) {
                                            if (value != null) {
                                              if (widget.isPersonal) {
                                                BlocProvider.of<
                                                            PersonalPahtBloc>(
                                                        context)
                                                    .add(
                                                  PersonalPahtRefreshRequestedEvent(), //ListPublicPahtFetchingEvent(isReload: true),
                                                );
                                              } else {
                                                BlocProvider.of<PublicPahtBloc>(
                                                        context)
                                                    .add(
                                                  ReloadListEvent(), //ListPublicPahtFetchingEvent(isReload: true),
                                                );
                                              }
                                            }
                                          });
                                        } else {
                                          // qua man hinh phe duyet bao gia

                                          Navigator.pushNamed(context,
                                                  ROUTER_APPROVE_QUOTATION_PAGE,
                                                  arguments: UpdatePahtArgument(
                                                      pahtModel:
                                                          widget.pahts[index],
                                                      isUpdateAble: false,
                                                      isSaled:
                                                          isSaled //moi tao moi duoc phep cap nhat
                                                      ))
                                              .then((value) {
                                            if (value != null) {
                                              BlocProvider.of<PublicPahtBloc>(
                                                      context)
                                                  .add(
                                                ReloadListEvent(
                                                    isApproveAble:
                                                        isApproveAble,
                                                    isSaled:
                                                        isSaled), //ListPublicPahtFetchingEvent(isReload: true),
                                              );
                                            }
                                          });
                                        }
                                      },
                                    )),
                        ),
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
            : NoDataFailureWidget(
                text: 'Bạn không có báo giá nào ',
              ),
      ),
    );
  }
}
