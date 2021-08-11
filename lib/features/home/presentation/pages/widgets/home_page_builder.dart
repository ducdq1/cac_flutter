import 'dart:ui';

import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/dialogs/input_dialog.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:citizen_app/features/home/presentation/bloc/bloc/home_page_bloc.dart';
import 'package:citizen_app/features/home/presentation/pages/home_page.dart';
import 'package:citizen_app/features/home/presentation/pages/widgets/banner_widget.dart';
import 'package:citizen_app/features/home/presentation/pages/widgets/citizens_menu_item_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/paht_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../injection_container.dart';

class HomePageBuilder extends StatefulWidget {
  final ScrollController scrollController;
  final StopScrollController stopScrollController;

  HomePageBuilder({Key key, this.scrollController, this.stopScrollController})
      : super(key: key);

  @override
  _HomePageBuilderState createState() => _HomePageBuilderState();
}

class _HomePageBuilderState extends State<HomePageBuilder>
    with SingleTickerProviderStateMixin
    implements OnButtonClickListener {
  AnimationController _controller;
  Animation<double> _animation;
  int userType;
  final pref = singleton<SharedPreferences>();

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    final Animation curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    _animation = Tween(begin: 33.0, end: 75.0).animate(curve);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userType = pref.getInt('userType');
    return SingleChildScrollView(
      controller: widget.scrollController,
      child: Stack(
        children: [
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            margin: EdgeInsets.only(top: 100),
            constraints: BoxConstraints(
                minHeight: MediaQuery
                    .of(context)
                    .size
                    .height - 150),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: BlocBuilder<HomePageBloc, HomePageState>(
              builder: (context, state) {
                return Padding(
                  padding:
                  const EdgeInsets.only(top: 50.0, left: 20, right: 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                CitizensMenuItemWidget(
                                  label: 'Quét mã',
                                  icon: '/icons/icon_scan_qr.png',
                                  needRedirect: '',
                                  onPress: () async {
                                    final PermissionHandler _permissionHandler =
                                    PermissionHandler();
                                    var permissionStatus =
                                    await _permissionHandler
                                        .checkPermissionStatus(
                                        PermissionGroup.camera);

                                    switch (permissionStatus) {
                                      case PermissionStatus.granted:
                                        var value = await Navigator.of(context)
                                            .pushNamed(ROUTER_QRCODE_SCANER);
                                        if (value != null) {
                                          Navigator.pushNamed(
                                              context, ROUTER_DETAILED_PAHT,
                                              arguments: PahtDetailArgument(
                                                  productCode: value));
                                        }

                                        break;
                                      case PermissionStatus.denied:
                                      case PermissionStatus.restricted:
                                      case PermissionStatus.unknown:
                                        await _permissionHandler
                                            .requestPermissions(
                                            [PermissionGroup.camera]);
                                        var permissionStatus =
                                        await _permissionHandler
                                            .checkPermissionStatus(
                                            PermissionGroup.camera);

                                        switch (permissionStatus) {
                                          case PermissionStatus.granted:
                                            var value =
                                            await Navigator.of(context)
                                                .pushNamed(
                                                ROUTER_QRCODE_SCANER);
                                            if (value != null) {
                                              Navigator.pushNamed(
                                                  context, ROUTER_DETAILED_PAHT,
                                                  arguments: PahtDetailArgument(
                                                      productCode: value));
                                            }
                                        }
                                        break;

                                      default:
                                    }
                                  },
                                ),
                                AnimatedBuilder(
                                  animation: _animation,
                                  child: Container(
                                    width: 140,
                                    child: Center(
                                      child: Container(
                                          color: Colors.amber,
                                          height: 1,
                                          width: 60),
                                    ),
                                  ),
                                  builder: (_, widget) {
                                    return Transform.translate(
                                      offset: Offset(0.0, _animation.value),
                                      child: widget,
                                    );
                                  },
                                )
                              ],
                            ),
                            CitizensMenuItemWidget(
                              label: 'Tìm kiếm',
                              icon: '/icons/icon_search.png',
                              needRedirect: '',
                              onPress: () {
                                Navigator.pushNamed(
                                    context, ROUTER_SEARCH_PRODUCT)
                                    .then((value) =>
                                {
                                  if (value != null)
                                    {
                                      Navigator.pushNamed(
                                          context, ROUTER_DETAILED_PAHT,
                                          arguments: PahtDetailArgument(
                                              productId: value))
                                    }
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CitizensMenuItemWidget(
                                label: 'Báo giá',
                                icon: '/icons/icon_bao_gia.png',
                                needRedirect: '',
                                onPress: () {
                                  Navigator.pushNamed(context, ROUTER_PAHT);
                                },
                              ),
                              CitizensMenuItemWidget(
                                label: 'Đã bán',
                                icon: '/icons/icon_saled.png',
                                needRedirect: '',
                                onPress: () {
                                  Navigator.pushNamed(
                                      context, ROUTER_SALED_QUOTATION);
                                },
                              ),
                            ]),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              userType != null &&
                                  userType ==
                                      3 //quan ly ban hang  co them module duyet bao gia
                                  ? CitizensMenuItemWidget(
                                label: 'Duyệt báo giá',
                                icon: '/icons/icon_ds_bao_gia.png',
                                needRedirect: '',
                                onPress: () {
                                  Navigator.pushNamed(
                                      context, ROUTER_APROVE_PAHT);
                                },
                              )
                                  : SizedBox(
                                height: 140,
                                width: 140,
                              ),
                              CitizensMenuItemWidget(
                                label: 'Nhắn tin',
                                icon: '/icons/icon_message.png',
                                needRedirect: '',
                                onPress: () {
                                  Navigator.pushNamed(
                                      context, ROUTER_CUS_CHAT_PAGE);
                                },
                              )
                            ]),
                      ]),
                );
              },
            ),
          ),
          Positioned(
              child: BannerWidget(
                scrollController: widget.scrollController,
                stopScrollController: widget.stopScrollController,
              )),
        ],
      ),
    );
  }

  @override
  onClick(String id) {
    BlocProvider.of<HomePageBloc>(context)
        .add(AppModulesFetched(provinceId: 11449));
  }
}
