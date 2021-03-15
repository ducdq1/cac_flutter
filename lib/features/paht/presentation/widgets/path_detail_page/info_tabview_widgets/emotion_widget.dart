import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'emotion_item_widget.dart';

class EmotionWidget extends StatefulWidget {
  final int emotion;

  EmotionWidget({this.emotion});

  @override
  _EmotionWidgetState createState() => _EmotionWidgetState();
}

class _EmotionWidgetState extends State<EmotionWidget>
    implements OnButtonClickListener {
  final _emotions = [
    {'icon': 'icon_emot_sad', 'label': LABEL_UNSATISFIED},
    {'icon': 'icon_emot_normal', 'label': LABEL_NORMAL},
    {'icon': 'icon_emot_happy', 'label': LABEL_SATISFIED},
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 24, top: 26, right: 24, bottom: 21),
      decoration: BoxDecoration(
          color: Color.fromARGB(153, 250, 245, 232),
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            trans(EVALUATION),
            style: GoogleFonts.inter(
              color: PRIMARY_TEXT_COLOR,
              fontSize: FONT_MIDDLE,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 14),
          Row(
            children: [
              SvgPicture.asset(
                SVG_ASSETS_PATH + 'icon_clock.svg',
              ),
              SizedBox(width: 9),
              Text(
                '12:00, 14/11/2021'.toUpperCase(),
                style: GoogleFonts.inter(
                  color: PRIMARY_TEXT_COLOR,
                  fontSize: FONT_MIDDLE,
                  fontWeight: FontWeight.normal,
                ),
              )
            ],
          ),
          SizedBox(height: 12),
          Text(
            trans(HAVE_EVALUATED),
            style: GoogleFonts.inter(
              color: PRIMARY_TEXT_COLOR,
              fontSize: FONT_MIDDLE,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _emotions
                .map((e) => EmotionItemWidget(
                      active: true,
                      svgIcon: e['icon'],
                      label: e['label'],
                    ))
                .toList(),
          ),
          SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 142,
              child: PrimaryButton(
                label: trans(ACT_SUBMIT_EVALUATION),
                ctx: this,
                id: 'location_btn',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  onClick(String id) {
    // TODO: implement onClick
    throw UnimplementedError();
  }
}
