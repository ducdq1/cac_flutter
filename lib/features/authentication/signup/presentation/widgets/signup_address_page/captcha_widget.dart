import 'dart:math';

import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/api.dart';
import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/validate/empty_validate.dart';
import 'package:citizen_app/features/common/widgets/inputs/input_validate_custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:platform_device_id/platform_device_id.dart';

import 'form_address_widget.dart';

class CaptchaWidget extends StatefulWidget {
  // final TextEditingController captchaIdController;
  final CaptchaIdObserve captchaIdObserve;
  final TextEditingController captchaController;
  final FocusNode captchaFocusNode;

  CaptchaWidget(
      {this.captchaController, this.captchaIdObserve, this.captchaFocusNode});
  @override
  _CaptchaWidgetState createState() => _CaptchaWidgetState();
}

class _CaptchaWidgetState extends State<CaptchaWidget> {
  String _id;
  int _reRender = 0;

  Future<void> _getIdDevice() async {
    _id = await PlatformDeviceId.getDeviceId;
    widget.captchaIdObserve.id = _id;
    setState(() {});
  }

  @override
  void initState() {
    _getIdDevice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _id != null
                  ? Image.network(
                      '$baseUrl/uaa/v1/users/get-captcha?id=$_id&render=$_reRender',
                      fit: BoxFit.contain,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 200,
                          height: 40,
                          child: Center(
                            child: Container(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                backgroundColor: Colors.white,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : SizedBox(),
              Material(
                borderRadius: BorderRadius.circular(30),
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: PRIMARY_COLOR,
                        width: 0.6,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      Icons.loop,
                      color: PRIMARY_COLOR,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _reRender = Random().nextInt(100000);
                    });
                  },
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          InputValidateCustomWidget(
            focusNode: widget.captchaFocusNode,
            controller: widget.captchaController,
            label: trans(ENTER_CAPTCHA),
            isRequired: true,
            textInputAction: TextInputAction.done,
            scrollPadding: MediaQuery.of(context).size.height / 2,
            validates: [
              EmptyValidate(),
            ],
            focusError: (FocusNode focusNode) {},
          ),
        ],
      ),
    );
  }
}
