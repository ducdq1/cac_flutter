import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_bloc.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_state.dart';
import 'package:citizen_app/features/common/blocs/blocs.dart';
import 'package:citizen_app/features/common/dialogs/confirm_dialog.dart';
import 'package:citizen_app/features/common/widgets/failure_widget/failure_widget.dart';
import 'package:citizen_app/features/common/widgets/widgets.dart';
import 'package:citizen_app/features/home/presentation/pages/home_page.dart';
import 'package:citizen_app/features/home/presentation/pages/widgets/appbar_home_widget.dart';
import 'package:citizen_app/features/home/presentation/pages/widgets/banner_widget.dart';
import 'package:citizen_app/features/paht/presentation/bloc/category_paht_bloc/category_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/personal_paht_bloc/personal_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/public_paht_bloc/public_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/status_paht_bloc/status_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/pages/pages.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/filter_category_status_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/skeleton_paht_list_widget.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:citizen_app/features/profile/presentation/pages/view_info_page.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:citizen_app/features/customer/presentation/pages/promotions_page.dart';

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
    super.initState();
  }

  void handleRefresh(context, {int indexTab}) {}

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BottomNavigationBloc>(
            create: (context) => BottomNavigationBloc()..add(TabStarted())),
        BlocProvider<StatusPahtBloc>(
            create: (context) => singleton<StatusPahtBloc>()
              ..add(indexTab == 0
                  ? ListStatusPublicFetched()
                  : ListStatusPersonalFetched())),
        BlocProvider<CategoryPahtBloc>(
            create: (context) =>
                singleton<CategoryPahtBloc>()..add(ListCategoriesFetched())),
        BlocProvider<PublicPahtBloc>(
            create: (context) => singleton<PublicPahtBloc>()
              ..add(ListPublicPahtFetchingEvent(offset: 0, limit: 10))),
        BlocProvider<PersonalPahtBloc>(
          create: (context) => singleton<PersonalPahtBloc>()
            ..add(
              ListPersonalPahtFetchingEvent(offset: 0, limit: 10),
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
                  backgroundColor: Colors.white,
                  selectedColor: COLOR_BACKGROUND,
                  // notchedShape: CircularNotchedRectangle(),
                  onTabSelected: (index) {
                    BlocProvider.of<BottomNavigationBloc>(context)
                        .add(TabTapped(index: index));
                    setState(() {
                      indexTab = index;
                      isFilter = false;
                    });
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
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: isFilter
                                    ? indexTab == 0
                                        ? 130
                                        : 225
                                    : 0),
                            child: BlocBuilder<BottomNavigationBloc,
                                BottomNavigationState>(
                              builder: (BuildContext context,
                                  BottomNavigationState state) {
                                if (state is FirstTabLoaded) {}
                                  return PromotionPage();
                                if (state is SecondTabLoaded) {}

                                if (state is Tab3Loaded) {}

                                if (state is Tab4Loaded) {
                                  return ViewInfoPage();
                                }

                                return SkeletonPahtWidget();
                              },
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
