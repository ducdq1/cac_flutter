import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_bloc.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_state.dart';
import 'package:citizen_app/features/common/blocs/blocs.dart';
import 'package:citizen_app/features/common/dialogs/confirm_dialog.dart';
import 'package:citizen_app/features/common/widgets/failure_widget/failure_widget.dart';
import 'package:citizen_app/features/common/widgets/widgets.dart';
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

const SIZE_ICON_BOTTOM_BAR = 20.0;
const SIZE_ICON_FLOATING_BUTTON = 24.0;
const SIZE_ICON_ACTIONS = 20.0;

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isFilter = false;
  int indexTab = 0;

  @override
  void initState() {
    super.initState();
  }

  void handleRefresh(context, {int indexTab}) {
    if (indexTab == 0) {
      BlocProvider.of<PublicPahtBloc>(context).add(
        PublicPahtRefreshRequestedEvent(),
      );
    } else if (indexTab == 1) {
      BlocProvider.of<PersonalPahtBloc>(context).add(
        PersonalPahtRefreshRequestedEvent(),
      );
    }
  }

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
          return BaseLayoutWidget(
            title: 'Danh sách Báo giá',
            centerTitle: true,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: SizedBox(
              height: 72,
              width: 72,
              child: FloatingActionButton(
                backgroundColor: PRIMARY_COLOR,
                onPressed: () {
                  final auth = BlocProvider.of<AuthBloc>(context).state;
                  if (auth is AuthenticatedState) {
                    Navigator.of(context)
                        .pushNamed(ROUTER_CREATE_PAHT)
                        .then((value) {
                      if (value) {
                        BlocProvider.of<PublicPahtBloc>(context).add(
                          ReloadListEvent(),
                        );
                      }
                    });
                  } else {
                    showConfirmDialog(
                      context: context,
                      icon: Icon(
                        Icons.login,
                        color: Colors.orangeAccent,
                      ),
                      label: trans(TITLE_LOGIN_SCREEN),
                      onSubmit: () {
                        Navigator.pushNamed(
                          context,
                          ROUTER_SIGNIN,
                        );
                      },
                      title: trans(LABEL_REQUIRE_SIGNIN_TO_CREATE_POST),
                    );
                  }
                },
                child: SvgPicture.asset(
                  SVG_ASSETS_PATH + 'icon_edit.svg',
                  width: SIZE_ICON_FLOATING_BUTTON,
                  height: SIZE_ICON_FLOATING_BUTTON,
                ),
              ),
            ),
            bottomNavigationBar:
                BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
              builder: (BuildContext context, BottomNavigationState state) {
                return FABBottomAppBarWidget(
                  color: Color(0xff606060),
                  backgroundColor: Colors.white,
                  selectedColor: COLOR_BACKGROUND,
                  notchedShape: CircularNotchedRectangle(),
                  onTabSelected: (index) {
                    BlocProvider.of<BottomNavigationBloc>(context)
                        .add(TabTapped(index: index));
                    setState(() {
                      indexTab = index;
                      isFilter = false;
                    });
                    if (indexTab == 0) {
                      BlocProvider.of<StatusPahtBloc>(context)
                          .add(ListStatusPublicFetched());
                    } else {
                      BlocProvider.of<StatusPahtBloc>(context)
                          .add(ListStatusPersonalFetched());
                    }
                  },
                  items: [
                    FABBottomAppBarItem(
                      icon: SvgPicture.asset(
                        SVG_ASSETS_PATH + 'icon_tab_processing.svg',
                        width: SIZE_ICON_BOTTOM_BAR,
                        height: SIZE_ICON_BOTTOM_BAR,
                      ),
                      iconActive: SvgPicture.asset(
                        SVG_ASSETS_PATH + 'icon_tab_processing_active.svg',
                        width: SIZE_ICON_BOTTOM_BAR,
                        height: SIZE_ICON_BOTTOM_BAR,
                      ),
                      text: trans(LABEL_PAHT_CONG_DONG),
                    ),
                    FABBottomAppBarItem(
                      icon: SvgPicture.asset(
                        SVG_ASSETS_PATH + 'icon_tab_processed.svg',
                        width: SIZE_ICON_BOTTOM_BAR,
                        height: SIZE_ICON_BOTTOM_BAR,
                      ),
                      iconActive: SvgPicture.asset(
                        SVG_ASSETS_PATH + 'icon_tab_processed_active.svg',
                        width: SIZE_ICON_BOTTOM_BAR,
                        height: SIZE_ICON_BOTTOM_BAR,
                      ),
                      text: trans(LABEL_PAHT_CA_NHAN),
                    ),
                  ],
                );
              },
            ),
            actions: [
              InkWell(
                child: SvgPicture.asset(
                  SVG_ASSETS_PATH + 'icon_search.svg',
                  color: Colors.white,
                  width: SIZE_ICON_ACTIONS,
                  height: SIZE_ICON_ACTIONS,
                ),
                onTap: () {
                  if (state is FirstTabLoaded) {
                    Navigator.pushNamed(context, ROUTER_SEARCH_PUBLIC_PAHT);
                  } else if (state is SecondTabLoaded) {
                    final auth = BlocProvider.of<AuthBloc>(context).state;
                    if (auth is AuthenticatedState) {
                      Navigator.pushNamed(context, ROUTER_SEARCH_PERSONAL_PAHT);
                    } else {
                      showConfirmDialog(
                        context: context,
                        icon: Icon(
                          Icons.login,
                          color: Colors.orangeAccent,
                        ),
                        label: trans(TITLE_LOGIN_SCREEN),
                        onSubmit: () {
                          Navigator.pushNamed(
                            context,
                            ROUTER_SIGNIN,
                          );
                        },
                        title: trans(LABEL_REQUIRE_SIGNIN_TO_SEARCH),
                      );
                    }
                  }
                },
              ),
              SizedBox(
                width: 10,
              ),
            ],
            body: Stack(
              children: [
                Visibility(
                    visible: isFilter,
                    child: FilterCategoryContainer(indexTab: indexTab)),
                Padding(
                  padding: EdgeInsets.only(
                      top: isFilter
                          ? indexTab == 0
                              ? 130
                              : 225
                          : 0),
                  child:
                      BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
                    builder:
                        (BuildContext context, BottomNavigationState state) {
                      if (state is FirstTabLoaded) {
                        return PahtPublic();
                      }
                      if (state is SecondTabLoaded) {
                        final auth = BlocProvider.of<AuthBloc>(context).state;
                        if (auth is AuthenticatedState) {
                          return PahtPersonal();
                        } else {
                          return NoSigninFailureWidget(onPressed: () {
                            Navigator.pushNamed(
                              context,
                              ROUTER_SIGNIN,
                            );
                          });
                        }
                      }

                      return SkeletonPahtWidget();
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
