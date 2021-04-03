import 'dart:io' show Platform;
import 'dart:ui';

import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/form_tools/form_tools.dart';
import 'package:citizen_app/core/utils/validate/empty_validate.dart';
import 'package:citizen_app/features/common/dialogs/delete_confirm_dialog.dart';
import 'package:citizen_app/features/common/widgets/buttons/outline_custom_button.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:citizen_app/features/common/widgets/inputs/input_validate_custom_widget.dart';
import 'package:citizen_app/features/common/widgets/inputs/text_field_custom.dart';
import 'package:citizen_app/features/common/widgets/widgets.dart';
import 'package:citizen_app/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:citizen_app/features/paht/data/models/media_picker_ios_model.dart';
import 'package:citizen_app/features/paht/data/models/models.dart';
import 'package:citizen_app/features/paht/data/models/quotation_detail_model.dart';
import 'package:citizen_app/features/paht/domain/entities/business_hour_entity.dart';
import 'package:citizen_app/features/paht/domain/usecases/create_issue_paht.dart';
import 'package:citizen_app/features/paht/presentation/bloc/category_paht_bloc/category_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/create_issue_bloc/create_issue_bloc.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/paht_list_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/quotation_detail_item_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../../../../injection_container.dart';
import 'package:citizen_app/features/home/presentation/pages/web_view_page.dart';

const SIZE_ICON = 20.0;
const SIZE_PICKER_LOCATION_ICON = 36.0;
const SIZE_CAMERA_ICON = 36.0;
const Color ADDRESS_FIELD_COLOR = Color(0xffB9B9B9);
const Color BACKGROUND_ADD_MEDIA_COLOR = Color(0xffEBEEF0);

class PahtCreateIssue extends StatefulWidget {
  @override
  _PahtCreateIssueState createState() => _PahtCreateIssueState();
}

class _PahtCreateIssueState extends State<PahtCreateIssue>
    with SingleTickerProviderStateMixin implements OnButtonClickListener {
  static const platform = const MethodChannel('citizens.app/media_picker_ios');

  List<int> listMediaDeleted = [];
  int currentAlbumIndex;
  dynamic listMediaFromIOS;
  List<BusinessHourEntity> BUSINESS_HOUR = [];
  bool isAddedBusinessHour = false;
  TextEditingController _poiNameController;
  TextEditingController _phoneNumberController;
  TextEditingController _addressController;
  TextEditingController _webController;
  FocusNode _contentFocusNode;
  FocusNode _focusNodeError;
  GlobalKey<FormState> _formKey;
  String _poiTypeValue;
  bool _isSubmitted = false;
  ScrollController scrollController;
  FocusNode _poiNameFocusNode;
  FocusNode _addressFocusNode;
  FocusNode _phoneNumberFocusNode;
  FocusNode _webFocusNode;
  ScrollController parentScrollController;
  PahtModel pahtModel;
  //List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  List<QuotationDetailModel> listQuotationDetailModel = [];
  final prefs = singleton<SharedPreferences>();
  int imageIdSelected;

  AnimationController _controller;
  Animation<double> _animation;


  bool _isKhachHangLe = true;
  bool _isUpdateAble = true;
  Map<String, dynamic> _chosenLocation = {
    'address': '',
    'latitude': null,
    'longitude': null
  };

  UpdatePahtArgument args;

  initValue(args) async {
    if (args != null && args.pahtModel != null) {
      pahtModel = args.pahtModel;
      _isUpdateAble = args.isUpdateAble;
      if (pahtModel.cusName != null) {
        _poiNameController.text = pahtModel.cusName;
      }

      if (pahtModel.cusAddress != null) {
        _addressController.text = pahtModel.cusAddress;
      }

      if (pahtModel.cusPhone != null) {
        _phoneNumberController.text = pahtModel.cusPhone;
      }
      if (pahtModel.type != null) {
        _isKhachHangLe = pahtModel.type == 0;
      }

      BlocProvider.of<CreateIssueBloc>(context).add(
        GetListQuotationDetailEvent(id: pahtModel.quotationID),
      );
    }
  }

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    final Animation curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    _animation = Tween(begin: 0.0, end: 29.0).animate(curve);
    _controller.repeat(reverse: true);


    _formKey = GlobalKey<FormState>();
    _addressController = TextEditingController();
    _poiNameController = TextEditingController();
    parentScrollController = new ScrollController();
    _phoneNumberController = TextEditingController();
    _webController = TextEditingController();
    _addressFocusNode = FocusNode();
    _contentFocusNode = FocusNode();
    _phoneNumberFocusNode = FocusNode();
    scrollController = new ScrollController();
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context).settings.arguments as UpdatePahtArgument;
      });
      initValue(args);
    });
    _poiNameFocusNode = FocusNode();

    super.initState();
  }

  onPop() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayoutWidget(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: !_isUpdateAble ? SizedBox() : FloatingActionButton(
            // child: Image.asset(
            //   'assets/icons/icon_scan_qr_white.png',
            //   height: 29,
            //   width: 29,
            // ),
            child:  Stack(
              children: [
                Image.asset(
                'assets/icons/icon_scan_qr_white.png',
                  width: 29,
                  height: 29,
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.scaleDown,
                ),
                AnimatedBuilder(
                  animation: _animation,
                  child: Container(
                    color: Colors.amber,
                    height: 1,
                    width: 29,
                  ),
                  builder: (_, widget) {
                    return Transform.translate(
                      offset: Offset(0.0, _animation.value),
                      child: widget,
                    );
                  },
                )
              ],
            ),
            // Icon( '/icons/icon_scan_qr.png', color: Colors.white, size: 29,),
            backgroundColor: PRIMARY_COLOR,
            tooltip: 'Quét mã',
            elevation: 5,
            splashColor: Colors.grey,
            onPressed: () async {
              clearFocus();
              final PermissionHandler _permissionHandler = PermissionHandler();
              var permissionStatus = await _permissionHandler
                  .checkPermissionStatus(PermissionGroup.camera);

              switch (permissionStatus) {
                case PermissionStatus.granted:
                  Navigator.pushNamed(context,ROUTER_QRCODE_SCANER )
                      .then((value) => {
                        if(value !=null){
                          gotoDetailProductPage(value)
                        }
                  });

                  break;
                case PermissionStatus.denied:
                case PermissionStatus.restricted:
                case PermissionStatus.unknown:
                  await _permissionHandler
                      .requestPermissions([PermissionGroup.camera]);
                  var permissionStatus = await _permissionHandler
                      .checkPermissionStatus(PermissionGroup.camera);
                      switch (permissionStatus) {
                        case PermissionStatus.granted:
                          Navigator.pushNamed(context,ROUTER_QRCODE_SCANER )
                              .then((value) => {
                            if(value !=null){
                              gotoDetailProductPage(value)
                            }
                          });
                      }
                  break;
                default:
              }
            },
          ),
        ),
        title: args == null ? 'Tạo báo giá' :  _isUpdateAble?'Cập nhật báo giá' : 'Chi tiết báo giá',
        centerTitle: true,
        body: BlocConsumer<CreateIssueBloc, CreateIssueState>(
          listener: (_, state) {
            if (state is GetListQuotationDetailSuccess) {
              setState(() {
                listQuotationDetailModel = state.listQuotationDetailModel;
              });
            }

            if (state is CreateIssueSuccess) {
              //Navigator.pop(context);
              Navigator.of(context, rootNavigator: true).pop('dialog');
              Fluttertoast.showToast(
                  msg: args == null
                      ? 'Tạo báo giá thành công'
                      : 'Cập nhật báo giá thành công');

              Navigator.pop(context, true);
            }

            if (state is CreateIssueFailure) {
              if (state.error != null &&
                  state.error.message != null &&
                  state.error.message.toString() == "UNAUTHORIZED") {
                Fluttertoast.showToast(msg: trans(MESSAGE_SESSION_EXPIRED));
                Navigator.of(context).pushNamedAndRemoveUntil(
                    ROUTER_SIGNIN, (Route<dynamic> route) => false);
              } else {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                Fluttertoast.showToast(
                    msg: state.error.message.toString() != null
                        ? (state.error.message.toString() == "Connection failed"
                            ? trans(ERROR_CONNECTION_FAILED)
                            : state.error.message.toString())
                        : args == null
                        ? 'Tạo báo giá thất bại'
                        : 'Cập nhật báo giá thất bại');
              }
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: parentScrollController,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            poiNameField(),
                            addressField(),
                            phoneNumberField(),
                            quotationTypField(),
                            Divider(
                              height: 2,
                                color: Colors.green
                            ),
                            SizedBox(height: 5,),
                            listProductField(),
                            state is GetListQuotationDetailLoading
                                ? Center(child: LoadingWidget())
                                : SizedBox()
                          ],
                        ),
                      ),
                    ),
                  ),
                 Container(
                      padding: EdgeInsets.all( 10),
                      decoration: BoxDecoration(
                        color: Color(0xffFDF9ED),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        border: Border.all(
                          width: 0.2,
                          color: PRIMARY_COLOR,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 10,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: _isUpdateAble ?   createIssueAction() : viewBaoGiaFileAction() ) ,
                ],
              ),
            );
          },
        ));
    // );
  }

  Widget poiNameField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            SvgPicture.asset(
              SVG_ASSETS_PATH + 'icon_poi_name.svg',
              width: SIZE_ICON,
              height: SIZE_ICON,
            ),
            SizedBox(height: SIZE_ICON),
          ],
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: InputWithTitleWidget(
                      titleInput: 'Tên khách hàng',
                      isRequired: true,
                      paddingTop: 0,
                      fontSize: FONT_SMALL,
                      textFieldWidget: InputValidateCustomWidget(
                        limitLength: 255,
                        scrollPaddingForTop: true,
                        scrollPadding: 200,
                        isShowBorder: false,
                        focusNode: _poiNameFocusNode,
                        controller: _poiNameController,
                        hintText: 'Tên khách hàng',
                        focusAction: () => FormTools.requestFocus(
                          currentFocusNode: _poiNameFocusNode,
                          nextFocusNode: _addressFocusNode,
                          context: context,
                        ),
                        validates: [
                          EmptyValidate(),
                        ],
                        focusError: (FocusNode focusNode) {
                          if (_focusNodeError == null) {
                            _focusNodeError = focusNode;
                          }
                        },
                      )),
                )
              ]),
        ),
      ],
    );
  }

  Widget addressField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            SvgPicture.asset(
              SVG_ASSETS_PATH + 'icon_pin.svg',
              width: SIZE_ICON,
              height: SIZE_ICON,
            ),
            SizedBox(height: SIZE_ICON),
          ],
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: InputWithTitleWidget(
                      titleInput: 'Địa chỉ',
                      isRequired: true,
                      paddingTop: 0,
                      fontSize: FONT_SMALL,
                      textFieldWidget: InputValidateCustomWidget(
                        textInputType: TextInputType.text,
                        limitLength: 500,
                        scrollPaddingForTop: true,
                        scrollPadding: 200,
                        isShowBorder: false,
                        readOnly: false,
                        focusNode: _addressFocusNode,
                        controller: _addressController,
                        hintText: 'Địa chỉ',
                        focusAction: () => FormTools.requestFocus(
                          currentFocusNode: _addressFocusNode,
                          nextFocusNode: _phoneNumberFocusNode,
                          context: context,
                        ),
                        validates: [
                          EmptyValidate(),
                        ],
                        focusError: (FocusNode focusNode) {
                          //widget.focusNodeError(focusNode);
                        },
                      )),
                )
              ]),
        ),
      ],
    );
  }

  Widget phoneNumberField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            SvgPicture.asset(
              SVG_ASSETS_PATH + 'icon_phone_number.svg',
              width: SIZE_ICON,
              height: SIZE_ICON,
            ),
            SizedBox(height: SIZE_ICON),
          ],
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: InputWithTitleWidget(
                      titleInput: 'Điện thoại',
                      // trans(LABEL_CONTENT_PAHT),
                      isRequired: false,
                      paddingTop: 0,
                      fontSize: FONT_SMALL,
                      textFieldWidget: InputValidateCustomWidget(
                        textInputType: TextInputType.number,
                        limitLength: 15,
                        scrollPaddingForTop: true,
                        scrollPadding: 200,
                        isShowBorder: false,
                        readOnly: false,
                        focusNode: _phoneNumberFocusNode,
                        controller: _phoneNumberController,
                        hintText: 'Điện thoại',
                        focusAction: () => FormTools.requestFocus(
                          currentFocusNode: _phoneNumberFocusNode,
                          //nextFocusNode: _webFocusNode,
                          context: context,
                        ),
                        validates: [],
                        focusError: (FocusNode focusNode) {
                          //widget.focusNodeError(focusNode);
                        },
                      )),
                )
              ]),
        ),
      ],
    );
  }

  void _showCupertinoDialog(BuildContext context) {
    showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return createIssueStatusContainer();
      },
    );
  }

  createIssueStatusContainer() {
    return AlertDialog(
      content: new Row(
        children: [
          SleekCircularSlider(
            appearance: CircularSliderAppearance(
              spinnerMode: true,
              size: 40,
              customColors: CustomSliderColors(
                dotColor: PRIMARY_COLOR,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 7),
              child: Text(
                trans(TEXT_WAITING_ALERT),
                style: GoogleFonts.inter(
                  color: SECONDARY_TEXT_COLOR,
                  fontSize: FONT_SMALL,
                ),
                softWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget listProductField() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sản phẩm (' + listQuotationDetailModel.length.toString() + ')',
            style: GoogleFonts.inter(
                color: Colors.green,
                fontSize: FONT_EX_LARGE,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: 10),
            itemBuilder: (BuildContext context, int index) {
              return QuotationDetailItemWidget(
                onDelete: () {
                  showDeleteConfirmDialog(
                    context: context,
                    onSubmit: () {
                      setState(() {
                        listQuotationDetailModel.removeAt(index);
                      });
                      Navigator.pop(context);
                    },
                  );
                },
                onEdit: () {
                  Navigator.pushNamed(context, ROUTER_CHOOSE_PRODUCT,
                          arguments: PahtDetailArgument(
                              productCode:
                                  listQuotationDetailModel[index].productCode,
                              quotationDetailModel:
                                  listQuotationDetailModel[index]))
                      .then((value) {
                    if (value != null) {
                      setState(() {
                        listQuotationDetailModel[index] = value;
                      });
                    }
                  });
                },
                isPersonal: _isUpdateAble ? false : true,
                quotationDetailModel: listQuotationDetailModel[index],
                onTap: () {},
              );
            },
            // itemCount: widget.hasReachedMax
            //     ? widget.pahts.length
            //     : widget.pahts.length + 1,
            itemCount: listQuotationDetailModel.length,
            controller: scrollController,
          )
        ]);
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

  Widget viewBaoGiaFileAction() {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Container(
              width: 142,
              child: PrimaryButton(
                  label: 'Xem báo giá',
                  ctx: this,
                  id: 'view_pdf_btn'),
            ),
          )
        ],
      ),
    );
  }

  Widget quotationTypField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 10),
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                child: FlatButton(
                    // here toggle the bool value so that when you click
                    // on the whole item, it will reflect changes in Checkbox
                    onPressed: () => setState(() {
                          _isKhachHangLe = !_isKhachHangLe;
                        }),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 24.0,
                              width: 24.0,
                              child: Checkbox(
                                  activeColor: PRIMARY_COLOR,
                                  value: _isKhachHangLe,
                                  onChanged: (value) {
                                    setState(() {
                                      _isKhachHangLe = value;
                                    });
                                  })),
                          // You can play with the width to adjust your
                          // desired spacing
                          SizedBox(width: 10.0),
                          Expanded(child: Text('Khách hàng lẽ'))
                        ])),
              ),
            ),
            Expanded(
              child: Container(
                child: FlatButton(
                    // here toggle the bool value so that when you click
                    // on the whole item, it will reflect changes in Checkbox
                    onPressed: () => setState(() {
                          _isKhachHangLe = !_isKhachHangLe;
                        }),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 24.0,
                              width: 24.0,
                              child: Checkbox(
                                  activeColor: PRIMARY_COLOR,
                                  value: !_isKhachHangLe,
                                  onChanged: (value) {
                                    setState(() {
                                      _isKhachHangLe = !value;
                                    });
                                  })),
                          // You can play with the width to adjust your
                          // desired spacing
                          SizedBox(width: 10.0),
                    Expanded(child: Text('Công trình'))
                        ])),
              ),
            ),
          ],
        )),
      ],
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  onClick(String id) async {
    if (id == 'primary_btn') {

      clearFocus();
      if(listQuotationDetailModel.isEmpty){
        Fluttertoast.showToast(
          msg: "Phải chọn ít nhất 1 sản phẩm.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }

      if (_formKey.currentState.validate()) {
        final userName = prefs.get('userName').toString();
        final userFullName = prefs.get('fullName').toString();

        BlocProvider.of<CreateIssueBloc>(context).add(
            CreateIssueButtonPresseEvent(
                quotationParams: QuotationParams(
                    quotation: PahtModel(
                        quotationID:
                            pahtModel == null ? null : pahtModel.quotationID,
                        type: _isKhachHangLe ? 0 : 1,
                        cusName: _poiNameController.text.trim(),
                        cusAddress: _addressController.text.trim(),
                        cusPhone: _phoneNumberController.text.trim(),
                        createUserCode: userName,
                        createUserFullName: userFullName),
                    lstQuotationDetail: listQuotationDetailModel)));

        _showCupertinoDialog(context);
      }
    }

    if (id == 'cancel_btn') {
      Navigator.pop(context);
    }
    if(id == 'view_pdf_btn'){
      if(pahtModel.fileName == null || pahtModel.fileName.isEmpty){
        Fluttertoast.showToast(
            msg:  'Không có file báo giá để xem');
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewPage(
                title: 'Chi tiết báo giá', link: '$baseUrl' + 'bao_gia/'+pahtModel.fileName)),
      );
    }
  }

  void clearFocus() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void gotoDetailProductPage(String cameraScanResult){
    Navigator.pushNamed(context, ROUTER_CHOOSE_PRODUCT,
        arguments: PahtDetailArgument(
            productCode: cameraScanResult))
        .then((value) => {
      if (value != null)
        {
          setState(() {
            if (value is QuotationDetailModel) {
              QuotationDetailModel exist;
              int indexExist= -1;
              for (int i = 0;
              i < listQuotationDetailModel.length;
              i++) {
                if (listQuotationDetailModel[i]
                    .productId ==
                    value.productId) {
                  exist = value;
                  indexExist =i;
                }
              }

              if (exist == null) {
                listQuotationDetailModel.add(value);
              } else {
                listQuotationDetailModel[indexExist]= (value);
              }
            }
          })
        }
    });
  }
}

Future<bool> _checkPermission() async {
  final permissionStorageGroup =
      Platform.isIOS ? PermissionGroup.photos : PermissionGroup.storage;
  Map<PermissionGroup, PermissionStatus> res =
      await PermissionHandler().requestPermissions([
    permissionStorageGroup,
  ]);
  return res[permissionStorageGroup] == PermissionStatus.granted;
}
