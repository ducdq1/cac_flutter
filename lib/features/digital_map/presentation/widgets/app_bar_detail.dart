import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/digital_map/presentation/widgets/default_banner_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarDetailMarkerWidget extends StatefulWidget {
  final String title;
  final String banner;
  final ScrollController scrollController;

  AppBarDetailMarkerWidget(
      {Key key, this.scrollController, this.title, this.banner})
      : super(key: key);

  @override
  _AppBarDetailMarkerWidgetState createState() =>
      _AppBarDetailMarkerWidgetState();
}

class _AppBarDetailMarkerWidgetState extends State<AppBarDetailMarkerWidget> {
  // var auth = BlocProvider.of<AuthBloc>(context).state;
  double opacity = 1.0;

  @override
  void initState() {
    widget.scrollController.addListener(_onScroll);
    super.initState();
  }

  // @override
  // void dispose() {
  //   widget.scrollController.dispose();
  //   super.dispose();
  // }

  void _onScroll() {
    double percent = 1 - (widget.scrollController.offset / 190);
    setState(() {
      opacity = percent;
    });
    if (opacity >= 1 || widget.scrollController.offset == 0)
      setState(() {
        opacity = 1;
      });
    if (opacity <= 0)
      setState(() {
        opacity = 0;
      });
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      // Provide a standard title.
      title: Text(
        opacity == 0 ? widget.title : "",
        style: TextStyle(color: Colors.black),
      ),
      bottom: PreferredSize(
        child: Container(),
        preferredSize: Size(0, 50),
      ),
      // Allows the user to reveal the app bar if they begin scrolling
      // back up the list of items.
      floating: true,
      pinned: true,
      snap: false,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: SvgPicture.asset(
          SVG_ASSETS_PATH +
              (opacity == 0
                  ? 'icon_arrow_back_black.svg'
                  : 'icon_arrow_back.svg'),
          width: 20,
          height: 20,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      // Display a placeholder widget to visualize the shrinking size.
      flexibleSpace: Opacity(
        opacity: opacity,
        child: Stack(
          children: [
            Positioned(
                child: DefaultBannerWidget(banner: widget.banner),
                top: 0,
                left: 0,
                right: 0,
                bottom: 0),
            Positioned(
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
              ),
              bottom: 0,
              left: 0,
              right: 0,
            ),
          ],
        ),
      ),
      // Make the initial height of the SliverAppBar larger than normal.
      expandedHeight: MediaQuery.of(context).size.height * 0.3,
    );
  }
}
