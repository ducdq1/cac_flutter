import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/utils.dart';
import 'package:citizen_app/core/functions/handle_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

const DESCRIPTION_COLOR = Color(0xff353739);

class PAHTITemWidget extends StatelessWidget {
  final String image;
  final String title;
  final String name;
  final String updatedTime;
  final int status;
  final Function onTap;
  final String address;
  final int commentCount;
  final bool isPersonal;
  final Function onEdit;
  final Function onDelete;
  final String fromCategory;
  PAHTITemWidget(
      {@required this.image,
      this.title,
      @required this.name,
      @required this.updatedTime,
      @required this.status,
      @required this.onTap,
      this.address,
      this.commentCount,
      @required this.isPersonal,
      this.onDelete,
      this.onEdit,
      this.fromCategory});

  @override
  Widget build(BuildContext context) {
    return !isPersonal
        ? Slidable.builder(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
      secondaryActionDelegate: SlideActionBuilderDelegate(
          actionCount: 2,
          builder: (context, index, animation, renderingMode) {
            if (index == 0) {
              return IconSlideAction(
                color:  Color.fromRGBO(97, 120, 130, 0.2),
                iconWidget: SvgPicture.asset(
                          SVG_ASSETS_PATH + 'icon_edit.svg',
                          color: Color.fromRGBO(53, 55, 57, 0.8),
                          height: 24,
                          width: 24,
                        ),
                onTap: onEdit,
              );
            } else {
              return IconSlideAction(
                caption: 'Delete',
                color: Color.fromRGBO(221, 48, 48, 0.9),
                onTap: onDelete,
                iconWidget:  SvgPicture.asset(
                      SVG_ASSETS_PATH + 'icon_recycle_bin.svg',
                      height: 28,
                      width: 23,
                    ),
              );
            }
          }),

            child: _itemWidget(context),
          )
        : _itemWidget(context);
  }

  Widget _itemWidget(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Color(0xffB9B9B9), width: 0.3))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                        height: 100,
                        width: 100,
                        color: Colors.grey[300],
                        child: image == null
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color.fromRGBO(97, 120, 130, 0.2),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(SVG_ASSETS_PATH +
                                      'icon_image_default.svg'),
                                ),
                              )
                            : Image.network(
                                image,
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace stackTrace) {
                                  return Container(
                                    color: Color.fromRGBO(97, 120, 130, 0.2),
                                  );
                                },
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    color: Colors.grey[300],
                                    child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: SizedBox(
                                              width: 15,
                                              height: 15,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    new AlwaysStoppedAnimation<
                                                        Color>(PRIMARY_COLOR),
                                                strokeWidth: 1.5,
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes
                                                    : null,
                                              )),
                                        )),
                                  );
                                },
                              )),
                  ),
                  SizedBox(height: 10),

                ],
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child:   Text(name == null || name == ''
                                    ? ''
                                    : name.length < 60
                                    ? name.toUpperCase()
                                    : name.substring(0, 60).toUpperCase() +
                                    '...',
                                style: GoogleFonts.inter(
                                  fontSize: FONT_SMALL,
                                  color: PRIMARY_TEXT_COLOR,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap: true,
                           ),

                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 50,
                      child: Text( address == null ? '' :
                          address.length < 60
                              ? address
                              : address.substring(0, 60) + '...',
                          style: GoogleFonts.inter(
                              color: DESCRIPTION_COLOR,
                              fontSize: FONT_MIDDLE,
                              height: 1.5),
                          softWrap: true),
                    ),
                    SizedBox(height: 7),
                    Row(
                      children: [
                        SvgPicture.asset(
                          SVG_ASSETS_PATH + 'icon_poi_name.svg',
                          width: 18,
                          height: 18,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          fromCategory,
                            style: GoogleFonts.inter(
                                color: DESCRIPTION_COLOR,
                                fontSize: FONT_MIDDLE,
                                )
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                        SvgPicture.asset(
                          SVG_ASSETS_PATH + 'icon_time.svg',
                          width: 16,
                          height: 16,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          handleTime(updatedTime),
                           style: GoogleFonts.inter(
                              color: DESCRIPTION_COLOR,
                              fontSize: FONT_MIDDLE, )
                        )
                      ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            isPersonal
                                ? Row(
                              children: [
                                SvgPicture.asset(getIcon(status)),
                                SizedBox(width: 5),
                                Text(
                                  getStatus(status),
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                      fontSize: FONT_SMALL,
                                      color: getColor(status)),
                                ),
                              ],
                            )
                                : SizedBox(),

                          ],
                        )
                    ],
                    ),
                    SizedBox(
                      height: 14,
                    ),


                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
