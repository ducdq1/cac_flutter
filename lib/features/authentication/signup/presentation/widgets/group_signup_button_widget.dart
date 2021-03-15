import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/widgets/buttons/outline_custom_button.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:route_transitions/route_transitions.dart';

class GroupSignUpButtonWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Widget router;
  final EdgeInsets margin;
  final Function onInValidate;
  final Function onValidate;

  GroupSignUpButtonWidget({
    this.formKey,
    this.router,
    this.margin = const EdgeInsets.symmetric(horizontal: 38),
    this.onInValidate,
    this.onValidate,
  });

  @override
  _GroupSignUpButtonWidgetState createState() =>
      _GroupSignUpButtonWidgetState();
}

class _GroupSignUpButtonWidgetState extends State<GroupSignUpButtonWidget>
    implements OnButtonClickListener {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: widget.margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: (MediaQuery.of(context).size.width - 38 * 2) / 2 - 8,
            child: OutlineCustomButton(
                label: trans(BACK), ctx: this, id: 'back_btn'),
          ),
          Container(
            width: (MediaQuery.of(context).size.width - 38 * 2) / 2 - 8,
            child: PrimaryButton(label: trans(NEXT), ctx: this, id: 'next_btn'),
          )
        ],
      ),
    );
  }

  @override
  onClick(String id) async {
    if (id == 'back_btn') {
      Navigator.pop(context);
      return;
    }

    if (widget.formKey.currentState.validate()) {
      widget.onValidate();
      FocusScope.of(context).unfocus();
      if (widget.router != null) {
        await Future.delayed(Duration(milliseconds: 200));
        Navigator.of(context).push(
          PageRouteTransition(
            animationType: AnimationType.slide_right,
            builder: (context) => widget.router,
          ),
        );
      }
    } else {
      widget.onInValidate();
    }
  }
}
