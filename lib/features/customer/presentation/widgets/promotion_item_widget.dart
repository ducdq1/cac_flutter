import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/utils.dart';
import 'package:citizen_app/core/functions/handle_time.dart';
import 'package:citizen_app/features/customer/data/models/promotion_model.dart';
import 'package:citizen_app/features/paht/data/models/paht_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

const DESCRIPTION_COLOR = Color(0xff353739);

class PromotionItemWidget extends StatelessWidget {
  final PromotionModel model;
  final Function onTap;

  PromotionItemWidget(
      {@required this.model,
      @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return  _itemWidget(context);
  }

  Widget _itemWidget(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color:  Colors.green.shade200,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(3, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, top: 10),
                          child: Row(children: [
                            Image.asset(
                              ICONS_ASSETS + 'icon_user2.png',
                              width: 16,
                              height: 16,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                                model.name == null
                                    ? ''
                                    : model.name,
                                style: GoogleFonts.inter(
                                  fontSize: FONT_MIDDLE,
                                  color: PRIMARY_TEXT_COLOR,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  model.description == null
                                      ? ''
                                      :model.description,
                                  style: GoogleFonts.inter(
                                      color: DESCRIPTION_COLOR,
                                      fontSize: FONT_MIDDLE,
                                      height: 1.5),
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                         SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }
}
