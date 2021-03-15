import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:citizen_app/features/common/widgets/widgets.dart';
import 'package:citizen_app/features/paht/domain/entities/business_hour_entity.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/business_hour_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:citizen_app/features/paht/presentation/pages/business_hour_edit_dialog.dart';

import 'package:citizen_app/features/common/widgets/buttons/outline_custom_button.dart';

class BusinessHourArgument {
  int dayEdit;
  List<BusinessHourEntity> businessHour;

  BusinessHourArgument({this.businessHour, this.dayEdit});
}

class BusinessHourPage extends StatefulWidget {
  final ScrollController scrollController = ScrollController();

  @override
  _BusinessHourPageState createState() => _BusinessHourPageState();
}

class _BusinessHourPageState extends State<BusinessHourPage>
    implements OnButtonClickListener {
  List<BusinessHourEntity> BUSINESS_HOUR;
  BusinessHourArgument args;
  bool isCreatePage = true;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      setState(() {
        args =
            ModalRoute.of(context).settings.arguments as BusinessHourArgument;
      });
      initValue(args);
    });
    super.initState();
  }

  initValue(BusinessHourArgument args) async {
    if (args != null) {
      BUSINESS_HOUR = args.businessHour;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isCreatePage) {
      isCreatePage = false;
      args = ModalRoute.of(context).settings.arguments as BusinessHourArgument;
      initValue(args);
    }
    return BaseLayoutWidget(
      title: trans(LABEL_ADD_TIME_OPERATION),
      centerTitle: true,
      body: Column(children: [
        SizedBox(height: 30),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(10),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return index >= BUSINESS_HOUR.length
                  ? Padding(
                      padding: const EdgeInsets.only(top: 00.0),
                      //child: BottomLoaderWidget(),
                    )
                  : BusinessHourItemWidget(
                      entity: BUSINESS_HOUR[index],
                      index: index,
                      onEdit: () async {
                        showDialog(
                                context: context,
                                builder: (_) => BusinessHourEditPage(),
                                routeSettings: RouteSettings(
                                    arguments: BusinessHourArgument(
                                        businessHour: BUSINESS_HOUR,
                                        dayEdit: index)))
                            .then((value) {
                          if (value != null) {
                            setState(() {
                              BUSINESS_HOUR = value;
                            });
                          }
                        });
                      },
                    );
            },
            // itemCount: widget.hasReachedMax
            //     ? widget.DAYS.length
            //     : widget.DAYS.length + 1,
            itemCount: BUSINESS_HOUR.length,
            controller: widget.scrollController,
          ),
        ),
        createIssueAction(),
        SizedBox(height: 30),
      ]),
    );
  }

  Widget createIssueAction() {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 142,
            child: OutlineCustomButton(
              label: trans(TEXT_CANCEL_CREATE_BUTTON),
              ctx: this,
              id: 'cancel_btn',
            ),
          ),
          Container(
            width: 142,
            child: PrimaryButton(
                label: args == null
                    ? trans(TEXT_CREATE_ISSUE_BUTTON)
                    : trans(TEXT_UPDATE_ISSUE_BUTTON),
                ctx: this,
                id: 'primary_btn'),
          )
        ],
      ),
    );
  }

  @override
  onClick(String id) {
    switch (id) {
      case 'primary_btn':
        Navigator.pop(context, BUSINESS_HOUR);
        break;

      case 'cancel_btn':
        Navigator.pop(context, null);
        break;

      default:
        Navigator.pop(context, null);
        break;
    }
  }
}
