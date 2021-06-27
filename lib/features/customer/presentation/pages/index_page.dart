import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/features/common/blocs/blocs.dart';
import 'package:citizen_app/features/common/widgets/widgets.dart';
import 'package:citizen_app/features/customer/presentation/bloc/productCategory/product_category_bloc.dart';
import 'package:citizen_app/features/customer/presentation/bloc/promotion/promotion_bloc.dart';
import 'package:citizen_app/features/customer/presentation/pages/promotions_page.dart';
import 'package:citizen_app/features/customer/presentation/pages/product_category_page.dart';
import 'package:citizen_app/features/home/presentation/pages/home_page.dart';
import 'package:citizen_app/features/home/presentation/pages/widgets/appbar_home_widget.dart';
import 'package:citizen_app/features/home/presentation/pages/widgets/banner_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/skeleton_paht_list_widget.dart';
import 'package:citizen_app/features/profile/presentation/pages/view_info_page.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

const SIZE_ICON_BOTTOM_BAR = 28.0;
const SIZE_ICON_FLOATING_BUTTON = 24.0;
const SIZE_ICON_ACTIONS = 20.0;

class Indexpage extends StatefulWidget {
  @override
  _IndexpageState createState() => _IndexpageState();
}

class _IndexpageState extends State<Indexpage> {
  bool isFilter = false;
  int indexTab = 0;
  final ScrollController _scrollController = ScrollController();
  final StopScrollController _stopScrollController = StopScrollController();

  @override
  void initState() {
    // BlocProvider.of<PromotionBloc>(context)
    //     .add(ListPromotionFetching());
    super.initState();
  }

  void handleRefresh(context, {int indexTab}) {}

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BottomNavigationBloc>(
            create: (context) => BottomNavigationBloc()..add(TabStarted())),
        BlocProvider<PromotionBloc>(
            create: (context) =>
                singleton<PromotionBloc>()..add(ListPromotionFetching())),
        BlocProvider<ProductCategoryBloc>(
          create: (context) => singleton<ProductCategoryBloc>()
            ..add(
              ListProductCategoriesFetching(),
            ),
        ),
      ],
      child: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
        builder: (BuildContext context, BottomNavigationState state) {
          return Scaffold(
            backgroundColor: PRIMARY_COLOR,
            appBar: AppBarHomeWidget(),
            bottomNavigationBar:
                BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
              builder: (BuildContext context, BottomNavigationState state) {
                return FABBottomAppBarWidget(
                  color: Color(0xff606060),
                 // backgroundColor: Colors.white,
                  //selectedColor: COLOR_BACKGROUND,
                  // notchedShape: CircularNotchedRectangle(),
                  onTabSelected: (index) {
                    BlocProvider.of<BottomNavigationBloc>(context)
                        .add(TabTapped(index: index));
                    if(indexTab == index){
                      return;
                    }
                    setState(() {
                      indexTab = index;
                    });
                    if(indexTab ==0) {
                      BlocProvider.of<PromotionBloc>(context)
                          .add(ListPromotionFetching());
                    }else if(indexTab == 1){
                      BlocProvider.of<ProductCategoryBloc>(context)
                          .add(ListProductCategoriesFetching());
                    }
                  },
                  items: [
                    FABBottomAppBarItem(
                      icon: Image.asset(
                        ICONS_ASSETS + 'ic_km.png',
                        width: SIZE_ICON_BOTTOM_BAR,
                        height: SIZE_ICON_BOTTOM_BAR,
                      ),
                      iconActive: Image.asset(
                        ICONS_ASSETS + 'ic_km_active.png',
                        width: SIZE_ICON_BOTTOM_BAR,
                        height: SIZE_ICON_BOTTOM_BAR,
                      ),
                      text: 'Khuyến mãi',
                    ),
                    FABBottomAppBarItem(
                        icon: Image.asset(
                          ICONS_ASSETS + 'ic_product.png',
                          width: SIZE_ICON_BOTTOM_BAR,
                          height: SIZE_ICON_BOTTOM_BAR,
                        ),
                        iconActive: Image.asset(
                          ICONS_ASSETS + 'ic_product_active.png',
                          width: SIZE_ICON_BOTTOM_BAR,
                          height: SIZE_ICON_BOTTOM_BAR,
                        ),
                        text: 'Sản phẩm'),
                    FABBottomAppBarItem(
                      icon: Image.asset(
                        ICONS_ASSETS + 'ic_message.png',
                        width: SIZE_ICON_BOTTOM_BAR,
                        height: SIZE_ICON_BOTTOM_BAR,
                      ),
                      iconActive: Image.asset(
                        ICONS_ASSETS + 'ic_message_active.png',
                        width: SIZE_ICON_BOTTOM_BAR,
                        height: SIZE_ICON_BOTTOM_BAR,
                      ),
                      text: 'Nhắn tin',
                    ),
                    FABBottomAppBarItem(
                        icon: Image.asset(
                          ICONS_ASSETS + 'ic_lienhe.png',
                          width: SIZE_ICON_BOTTOM_BAR,
                          height: SIZE_ICON_BOTTOM_BAR,
                        ),
                        iconActive: Image.asset(
                          ICONS_ASSETS + 'ic_lienhe_active.png',
                          width: SIZE_ICON_BOTTOM_BAR,
                          height: SIZE_ICON_BOTTOM_BAR,
                        ),
                        text: 'Liên hệ'),
                  ],
                );
              },
            ),
            body: Stack(children: [
              SingleChildScrollView(
                controller: _scrollController,
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 100),
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height - 150),
                      decoration: BoxDecoration(
                        color: Colors.white,// Color(0xffF8F2E3),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            //color: Color(0xffFFF1CE),//,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top:  0),
                              child: BlocBuilder<BottomNavigationBloc,
                                  BottomNavigationState>(
                                builder: (BuildContext context,
                                    BottomNavigationState state) {
                                  _scrollController.jumpTo(0);
                                  if (state is BottomNavigationInitial || state is FirstTabLoaded) {
                                    print('PromotionPage');
                                    BlocProvider.of<PromotionBloc>(context)
                                        .add(ListPromotionFetching());
                                    return PromotionPage();
                                  }
                                  if (state is SecondTabLoaded) {
                                    print('ProductCategoryPage');
                                    return ProductCategoryPage();
                                  }

                                  if (state is Tab3Loaded) {

                                  }

                                  if (state is Tab4Loaded) {
                                    return ViewInfoPage();
                                  }

                                  return SkeletonPahtWidget();
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                        child: BannerWidget(
                      scrollController: _scrollController,
                      stopScrollController: _stopScrollController,
                    )),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Visibility(
                  visible: indexTab == 3,
                  child: IconButton(
                    icon: Image.asset(
                      ICONS_ASSETS + 'ic_call_now.png',
                      //  width: 100, height: 100
                    ),
                    iconSize: 70,
                    onPressed: () {
                      UrlLauncher.launch("tel://02363812805");
                    },
                  ),
                ),
              )
            ]),
          );
        },
      ),
    );
  }
}
