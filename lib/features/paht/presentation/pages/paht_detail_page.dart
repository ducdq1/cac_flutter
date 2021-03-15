import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/paht/presentation/bloc/detailed_paht_bloc/detailed_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/paht_list_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/path_detail_page/appbar_heading_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/path_detail_page/paht_comment_tabview_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/path_detail_page/paht_info_tabview_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/path_detail_page/paht_media_tabview_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/path_detail_page/tabbar_custom_widget.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

const PADDING_CONTENT_HORIZONTAL = 16.0;
const SIZE_ARROW_BACK_ICON = 24.0;

class PahtDetailPage extends StatefulWidget {
  @override
  _PahtDetailPageState createState() => _PahtDetailPageState();
}

class _PahtDetailPageState extends State<PahtDetailPage>
    with TickerProviderStateMixin {
  TabController _controller;
  final tabs = [
    trans(TITLE_INFORMATION_SCREEN),
    trans(LABEL_MEDIA_PAHT)
  ];
  int _index;

  @override
  void initState() {
    _controller = TabController(vsync: this, length: 2);
    _index = _controller.index;
    _controller.addListener(() {
      setState(() {
        _index = _controller.index;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context).settings.arguments as PahtDetailArgument;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: PRIMARY_COLOR,
        body: SafeArea(
          child: Column(
            children: [
              AppBarHeadingWidget(
                title: arg.poiDetail.name,
              ),
              SizedBox(height: 0),
              // TabBarCustomWidget(controller: _controller),
              TabBar(
                indicatorColor: Colors.white,
                controller: _controller,
                isScrollable: true,
                onTap: (int index) {
                  setState(() {
                    _index = index;
                  });
                },
                tabs: tabs
                    .asMap()
                    .map(
                      (i, element) => MapEntry(
                        i,
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 3),
                                child: AnimatedSize(
                                  vsync: this,
                                  curve: Curves.easeIn,
                                  duration: Duration(
                                    milliseconds: 200,
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.circle,
                                    color: Colors.white,
                                    size: i == _index ? 6 : 0,
                                  ),
                                ),
                              ),
                              Text(
                                tabs[i].toUpperCase(),
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: FONT_SMALL,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .values
                    .toList(),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 0),
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Container(
                      color: Colors.white,
                      child: TabBarView(
                        controller: _controller,
                        children: [
                          PahtInfoTabViewWidget(poiDetail: arg.poiDetail),
                          PahtMediaTabViewWidget(poiDetail: arg.poiDetail)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
