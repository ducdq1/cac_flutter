import 'package:citizen_app/features/authentication/signin/presentation/signin_page.dart';
import 'package:citizen_app/features/common/widgets/buttons/outline_custom_button.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';

class GroupButtonWidget extends StatefulWidget {
  final String primaryLabel;
  final String secondaryLabel;
  final String primaryBtnId;
  final String secondBtnId;
  final GlobalKey<FormState> formKey;
  final bool isViettelSignin;
  final Function onSubmit;

  GroupButtonWidget({
    this.primaryLabel,
    this.secondaryLabel,
    this.formKey,
    this.isViettelSignin,
    this.primaryBtnId,
    this.secondBtnId,
    this.onSubmit,
  });
  @override
  _GroupButtonWidgetState createState() => _GroupButtonWidgetState();
}

class _GroupButtonWidgetState extends State<GroupButtonWidget>
    implements OnButtonClickListener {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryButton(
            label: widget.primaryLabel,
            ctx: this,
            id: widget.primaryBtnId,
          ),
          // SizedBox(height: 18),
          // OutlineCustomButton(
          //   label: widget.secondaryLabel,
          //   ctx: this,
          //   id: widget.secondBtnId,
          // ),
        ],
      ),
    );
  }

  @override
  onClick(String id) async {
    if (id == widget.secondBtnId) {
      switch (id) {
        case 'signin_viettel_navigate_btn':
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => SignInPage(isCustomer: true)));
          break;
        case 'signin_account_navigate_btn':
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => SignInPage(isCustomer: false)));
          break;
        default:
      }
      return;
    }

    if (widget.formKey.currentState.validate()) {
      if (widget.isViettelSignin) {
        widget.onSubmit();
      } else {
        print('Dang nhap thuong');
        widget.onSubmit();
      }
    }
  }
}
