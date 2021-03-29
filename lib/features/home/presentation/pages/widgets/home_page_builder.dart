import 'dart:ui';

import 'package:citizen_app/core/resources/resources.dart';
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

class HomePageBuilder extends StatefulWidget {
  final ScrollController scrollController;
  final StopScrollController stopScrollController;

  HomePageBuilder({Key key, this.scrollController, this.stopScrollController})
      : super(key: key);

  @override
  _HomePageBuilderState createState() => _HomePageBuilderState();
}

class _HomePageBuilderState extends State<HomePageBuilder>
    implements OnButtonClickListener {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
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
            child: BlocBuilder<HomePageBloc, HomePageState>(
              builder: (context, state) {
                return Padding(
                  padding:
                      const EdgeInsets.only(top: 100.0, left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CitizensMenuItemWidget(
                        label: 'Quét mã',
                        icon: '/icons/icon_scan_qr.png',
                        needRedirect: '',
                        onPress: () async {
                          // Navigator.pushNamed(
                          //     context, '/${widget.menu[i].serviceType}');

                          final PermissionHandler _permissionHandler =
                              PermissionHandler();
                          var permissionStatus = await _permissionHandler
                              .checkPermissionStatus(PermissionGroup.camera);

                          switch (permissionStatus)  {
                            case PermissionStatus.granted:
                              var value = await Navigator.of(context).pushNamed( ROUTER_QRCODE_SCANER);
                              if (value != null){
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
                                      .requestPermissions([PermissionGroup.camera]);
                                  var permissionStatus = await _permissionHandler
                                      .checkPermissionStatus(
                                          PermissionGroup.camera);

                                  switch (permissionStatus) {
                                    case PermissionStatus.granted:
                                      var value = await Navigator.of(context).pushNamed( ROUTER_QRCODE_SCANER);
                                      if (value != null){
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
                      CitizensMenuItemWidget(
                        label: 'Báo giá',
                        icon: '/icons/icon_bao_gia.png',
                        needRedirect: '',
                        onPress: () {
                          Navigator.pushNamed(context, ROUTER_PAHT);
                        },
                      )
                    ],
                  ),
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
