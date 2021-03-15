import 'dart:ui';

import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/widgets/buttons/outline_custom_button.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:citizen_app/features/common/widgets/skeletons/menu_skeleton_widget.dart';
import 'package:citizen_app/features/home/presentation/bloc/bloc/home_page_bloc.dart';
import 'package:citizen_app/features/home/presentation/pages/home_page.dart';
import 'package:citizen_app/features/home/presentation/pages/widgets/banner_widget.dart';
import 'package:citizen_app/features/home/presentation/pages/widgets/citizens_menu_footer_widget.dart';
import 'package:citizen_app/features/home/presentation/pages/widgets/citizens_menu_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
                if (state is HomePageFailure) {
                  Fluttertoast.showToast(
                      msg: state.error.message.message.toString());
                  return Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Center(
                      child: Column(
                        children: [
                          Container(
                            width: 142,
                            child: OutlineCustomButton(
                                label: trans(RETRY),
                                ctx: this,
                                id: 'primary_btn'),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (state is HomePageSuccess) {
                  final menuServices = state.appModules.services
                      .where((element) => element.serviceType != 'SOS')
                      .where((element) => element.isActive == '1')
                      .toList();
                  final menuFooters = state.appModules.footers
                      .where((element) => element.isActive == '1')
                      .toList();
                  return ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      CitizensMenuWidget(menu: menuServices),
                      //SizedBox(height: 10),
                      Divider(
                        color: Colors.black.withOpacity(0.0),
                        thickness: 0.3,
                        height: 0,
                        indent: 16,
                        endIndent: 16,
                      ),
                      CitizensMenuFooterWidget(menu: menuFooters),
                    ],
                  );
                }
                return Center(child: MenuSkeletonWidget());
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
