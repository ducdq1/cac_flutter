import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/dialogs/delete_confirm_dialog.dart';
import 'package:citizen_app/features/common/widgets/failure_widget/failure_widget.dart';
import 'package:citizen_app/features/paht/data/models/models.dart';
import 'package:citizen_app/features/paht/data/models/product_model.dart';
import 'package:citizen_app/features/paht/data/models/quotation_detail_model.dart';
import 'package:citizen_app/features/paht/domain/entities/business_hour_entity.dart';
import 'package:citizen_app/features/paht/presentation/bloc/personal_paht_bloc/personal_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/public_paht_bloc/public_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/bottom_loader_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/product_item_widget.dart';
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
  final bool isUpdateAble;
  final bool isApproveAble;
  final bool isSaled;

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
      this.pahtModel,
      this.isUpdateAble = true,
      this.isApproveAble = false,
      this.isSaled = false});
}

class PahtDetailArgument {
  final QuotationDetailModel quotationDetailModel;
  final PahtModel poiDetail;
  final String id;
  final String title;
  String productCode;
  final bool isUpdateAble;
  final bool isApproveAble;

  PahtDetailArgument(
      {this.id,
      this.title,
      this.poiDetail,
      this.productCode,
      this.quotationDetailModel,
      this.isUpdateAble = false,
      this.isApproveAble = false});
}

class ListViewProductsWidget extends StatefulWidget {
  final List<ProductModel> pahts;
  final bool isPersonal;
  final bool hasReachedMax;
  final ScrollController scrollController;
  final bool loadmore;
  final double paddingBottom;
  final bool isApproveAble;
  final Function onTap;
  final String textSearch;

  ListViewProductsWidget(
      {@required this.pahts,
      @required this.isPersonal,
      @required this.hasReachedMax,
      this.scrollController,
      this.loadmore = false,
      this.paddingBottom = 100,
      this.isApproveAble = false,
      this.onTap,
      this.textSearch});

  @override
  _ListViewProductsWidgetState createState() => _ListViewProductsWidgetState();
}

class _ListViewProductsWidgetState extends State<ListViewProductsWidget> {
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
    setState(() {
      isLoadingVertical = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loadmore = widget.loadmore;
    return AnimationLimiter(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: widget.pahts.length != 0
            ? LazyLoadScrollView(
                isLoading: isLoadingVertical,
                onEndOfPage: () => _loadMoreVertical(),
                child: RefreshIndicator(
                  onRefresh: () async => {},
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
                                  : ProductITemWidget(
                                      pahtModel: widget.pahts[index],
                                      onTap: () {
                                        widget.onTap(
                                            widget.pahts[index].productId);
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
            : NoDataFailureWidget(),
      ),
    );
  }
}
