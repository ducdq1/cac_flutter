import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OutlineCustomButton extends StatelessWidget {
  final String id;
  final State ctx;
  final String label;
  final bool disable;

  OutlineCustomButton({@required this.label, this.id, this.ctx, this.disable = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: OutlineButton(
        disabledBorderColor: DISABLE_COLOR,
        disabledTextColor: DISABLE_TEXT_COLOR,
        onPressed: () {
          try {
            (ctx as OnButtonClickListener).onClick(id);
          } catch (e) {
            throw e;
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(36),
        ),
        borderSide: BorderSide(color: PRIMARY_COLOR, width: 0.8),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: FONT_EX_SMALL,
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
