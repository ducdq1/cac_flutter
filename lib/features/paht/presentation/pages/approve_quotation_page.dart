import 'dart:io' show Platform;
import 'dart:ui';

import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/validate/empty_validate.dart';
import 'package:citizen_app/features/authentication/signup/presentation/widgets/signup_personal_page/input_datetime_widget.dart';
import 'package:citizen_app/features/common/widgets/buttons/outline_custom_button.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:citizen_app/features/common/widgets/widgets.dart';
import 'package:citizen_app/features/home/presentation/pages/web_view_page.dart';
import 'package:citizen_app/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:citizen_app/features/paht/data/models/models.dart';
import 'package:citizen_app/features/paht/data/models/quotation_detail_model.dart';
import 'package:citizen_app/features/paht/domain/entities/business_hour_entity.dart';
import 'package:citizen_app/features/paht/domain/usecases/create_issue_paht.dart';
import 'package:citizen_app/features/paht/presentation/bloc/create_issue_bloc/create_issue_bloc.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/approve_confirm_dialog.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/paht_list_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/quotation_detail_item_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
//import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../../../injection_container.dart';

const SIZE_ICON = 20.0;
const SIZE_PICKER_LOCATION_ICON = 36.0;
const SIZE_CAMERA_ICON = 36.0;
const Color ADDRESS_FIELD_COLOR = Color(0xffB9B9B9);
const Color BACKGROUND_ADD_MEDIA_COLOR = Color(0xffEBEEF0);

class ApproveQuotationPage extends StatefulWidget {
  @override
  _ApproveQuotationPageState createState() => _ApproveQuotationPageState();
}

class _ApproveQuotationPageState extends State<ApproveQuotationPage>
    with SingleTickerProviderStateMixin
    implements OnButtonClickListener {
  int currentAlbumIndex;
  dynamic listMediaFromIOS;
  List<BusinessHourEntity> BUSINESS_HOUR = [];
  bool isAddedBusinessHour = false;
  TextEditingController _poiNameController;
  TextEditingController _phoneNumberController;
  TextEditingController _addressController;
  TextEditingController expireDateController;
  TextEditingController saledDateController;
  FocusNode _contentFocusNode;
  FocusNode _focusNodeError;
  GlobalKey<FormState> _formKey;
  ScrollController scrollController;
  FocusNode _poiNameFocusNode;
  FocusNode _addressFocusNode;
  FocusNode _phoneNumberFocusNode;
  FocusNode _webFocusNode;
  ScrollController parentScrollController;
  PahtModel pahtModel;
  bool isSubmited = false;

  //List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  List<QuotationDetailModel> listQuotationDetailModel = [];
  final prefs = singleton<SharedPreferences>();
  int imageIdSelected;
  bool isPreview = false;
  AnimationController _controller;
  Animation<double> _animation;

  bool _isKhachHangLe = true;
  bool _isUpdateAble = true;

  bool isSaled = false;

  Map<String, dynamic> _chosenLocation = {
    'address': '',
    'latitude': null,
    'longitude': null
  };

  UpdatePahtArgument args;

  initValue(args) async {
    if (args != null && args.pahtModel != null) {
      pahtModel = args.pahtModel;
      isSaled = args.isSaled;
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

      if(pahtModel.saledDate !=null){
        String saledDate =  DateFormat("dd/MM/yyyy").format(DateTime.parse(pahtModel.saledDate));
        saledDateController.text =  saledDate;

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
    expireDateController = TextEditingController();
    saledDateController = TextEditingController();
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
        onPop: () {
          Navigator.pop(context, isSubmited == true ? true : null);
        },
        title: args == null
            ? 'Báo giá'
            : _isUpdateAble
                ? 'Báo giá'
                : 'Chi tiết báo giá ' + (pahtModel !=null && pahtModel.quotationNumber!=null ? pahtModel.quotationNumber : ''),
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

              if (state.fileName != null &&
                  state.fileName.isNotEmpty &&
                  state.fileName.contains(".pdf")) {
                if (!isPreview) {
                  isSubmited = true;
                  setState(() {
                    pahtModel.fileName = state.fileName;
                    pahtModel.status = 1;
                  });

                  Fluttertoast.showToast(
                      msg: args == null
                          ? 'Báo giá thành công'
                          : 'Báo giá thành công');
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebViewPage(
                          title: 'Chi tiết báo giá',
                          link: '$baseUrl' + 'bao_gia/' + state.fileName,model: pahtModel,)),
                );
              }
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
                            ? 'Báo giá thất bại'
                            : 'Bbáo giá thất bại');
              }
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: parentScrollController,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              poiNameField(),
                              addressField(),
                              phoneNumberField(),
                              quotationTypField(),
                              Divider(height: 2, color: Colors.green),
                              SizedBox(
                                height: 10,
                              ),
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
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                      child: Column(children: [
                        Container(
                          height: 4,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        pahtModel != null ? (pahtModel.status == 0
                            ? createIssueAction()
                            : viewBaoGiaFileAction()
                        ) : SizedBox()
                      ]),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
    // );
  }

  Widget poiNameField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Khách hàng:',
                style: GoogleFonts.inter(
                    color: DESCRIPTION_COLOR,
                    fontSize: FONT_MIDDLE,
                    height: 1.5,
                    fontWeight: FontWeight.bold),
                softWrap: true),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                pahtModel == null ? "" : pahtModel.cusName,
                style: GoogleFonts.inter(
                  color: DESCRIPTION_COLOR,
                  fontSize: FONT_MIDDLE,
                  height: 1.5,
                ),
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ]),
    );
  }

  Widget addressField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Địa chỉ:',
                style: GoogleFonts.inter(
                    color: DESCRIPTION_COLOR,
                    fontSize: FONT_MIDDLE,
                    height: 1.5,
                    fontWeight: FontWeight.bold),
                softWrap: true),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                pahtModel == null ? "" : pahtModel.cusAddress,
                style: GoogleFonts.inter(
                  color: DESCRIPTION_COLOR,
                  fontSize: FONT_MIDDLE,
                  height: 1.5,
                ),
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ]),
    );
  }

  Widget phoneNumberField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Điện thoại:',
                style: GoogleFonts.inter(
                    color: DESCRIPTION_COLOR,
                    fontSize: FONT_MIDDLE,
                    height: 1.5,
                    fontWeight: FontWeight.bold),
                softWrap: true),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                pahtModel == null || pahtModel.cusPhone == null
                    ? ""
                    : pahtModel.cusPhone,
                style: GoogleFonts.inter(
                  color: DESCRIPTION_COLOR,
                  fontSize: FONT_MIDDLE,
                  height: 1.5,
                ),
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ]),
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
                  fontSize: FONT_MIDDLE,
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
                  Fluttertoast.showToast(
                    msg: "Bạn không có quyền xóa sản phẩm này.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black87,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                },
                onEdit: () {
                  gotoDetailProductPage(
                      listQuotationDetailModel[index].productCode,
                      listQuotationDetailModel[index]);
                },
                isPersonal: false,
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
      child: Column(children: [
        InputDatetimeWidget(
          scrollPadding: 200,
          hintText: 'Ngày hết hạn',
          controller: expireDateController,
          validates: [EmptyValidate()],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 142,
              child: OutlineCustomButton(
                label: 'Xem trước',
                ctx: this,
                id: 'preview_btn',
              ),
            ),
            Container(
              width: 142,
              child:
                  PrimaryButton(label: 'Báo giá', ctx: this, id: 'primary_btn'),
            )
          ],
        ),
      ]),
    );
  }

  Widget viewBaoGiaFileAction() {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          pahtModel.saledDate !=null && pahtModel.saledDate.isNotEmpty ? InputDatetimeWidget(
            scrollPadding: 200,
            hintText: 'Ngày bán hàng',
            controller: saledDateController,
            validates: [EmptyValidate()],

          ) : SizedBox(),
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Container(
                width: 142,
                child: PrimaryButton(
                    label: 'Xem báo giá', ctx: this, id: 'view_pdf_btn'),
              ),
            )
          ],
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
                    onPressed: () => setState(() {}),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 24.0,
                              width: 24.0,
                              child: Checkbox(
                                  activeColor: PRIMARY_COLOR,
                                  value: _isKhachHangLe,
                                  onChanged: (value) {})),
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
                    onPressed: () => setState(() {}),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 24.0,
                              width: 24.0,
                              child: Checkbox(
                                  activeColor: PRIMARY_COLOR,
                                  value: !_isKhachHangLe,
                                  onChanged: (value) {})),
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
    if (id == 'primary_btn' || id == 'preview_btn') {
      if (id == 'preview_btn') {
        isPreview = true;
      } else {
        isPreview = false;
      }

      clearFocus();
      if (listQuotationDetailModel.isEmpty) {
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

      for (int i = 0; i < listQuotationDetailModel.length; i++) {
        if (listQuotationDetailModel[i].price == null) {
          Fluttertoast.showToast(
              msg: "Bạn chưa nhập giá cho sản phẩm: " +
                  listQuotationDetailModel[i].productCode);
          return;
        }
      }

      if (expireDateController.text.isEmpty) {
        Fluttertoast.showToast(msg: "Chưa nhập ngày hết hạn");
        return;
      }

      String expiredDate = expireDateController.text;

      if (_formKey.currentState.validate()) {
        if (!isPreview) {
          showDialog(
            context: context,
            builder: (_) => ApproveConfirmDialog(
              onOK: () {
                BlocProvider.of<CreateIssueBloc>(context).add(
                    CreateIssueButtonPresseEvent(
                        quotationParams: QuotationParams(
                            expiredDate: expiredDate,
                            isApproveAble: true,
                            isPreViewApprove: isPreview,
                            quotation: pahtModel,
                            lstQuotationDetail: listQuotationDetailModel)));
                _showCupertinoDialog(context);
              },
            ),
          );
        } else {
          BlocProvider.of<CreateIssueBloc>(context).add(
              CreateIssueButtonPresseEvent(
                  quotationParams: QuotationParams(
                      expiredDate: expiredDate,
                      isApproveAble: true,
                      isPreViewApprove: isPreview,
                      quotation: pahtModel,
                      lstQuotationDetail: listQuotationDetailModel)));
          _showCupertinoDialog(context);
        }
      }
    }

    if (id == 'cancel_btn') {
      Navigator.pop(context);
    }

    if (id == 'view_pdf_btn') {
      if (pahtModel.fileName == null || pahtModel.fileName.isEmpty) {
        Fluttertoast.showToast(msg: 'Không có file báo giá để xem');
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewPage(
                title: 'Bảng báo giá',
                link: '$baseUrl' + 'bao_gia/' + pahtModel.fileName,model:  pahtModel,)),
      );
    }
  }

  void clearFocus() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void gotoDetailProductPage(
      String cameraScanResult, QuotationDetailModel quotationDetailModel) {
    Navigator.pushNamed(context, ROUTER_CHOOSE_PRODUCT,
            arguments: PahtDetailArgument(
                productCode: cameraScanResult,
                quotationDetailModel: quotationDetailModel,
                isApproveAble: true))
        .then((value) => {
              if (value != null)
                {
                  setState(() {
                    if (value is QuotationDetailModel) {
                      QuotationDetailModel exist = null;
                      int indexExist = -1;
                      for (int i = 0;
                          i < listQuotationDetailModel.length;
                          i++) {
                        if (listQuotationDetailModel[i].productId ==
                            value.productId) {
                          exist = value;
                          indexExist = i;
                          break;
                        }
                      }
                      if (exist != null) {
                        listQuotationDetailModel[indexExist] = (value);
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
