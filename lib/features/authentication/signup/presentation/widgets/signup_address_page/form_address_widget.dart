import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/validate/empty_validate.dart';
import 'package:citizen_app/features/address_picker/data/datasources/address_remote_data_source.dart';
import 'package:citizen_app/features/address_picker/data/models/district_model.dart';
import 'package:citizen_app/features/address_picker/data/models/province_model.dart';
import 'package:citizen_app/features/address_picker/data/models/ward_model.dart';
import 'package:citizen_app/features/address_picker/domain/entities/address_entity.dart';
import 'package:citizen_app/features/address_picker/domain/usecases/address_command_exp.dart';
import 'package:citizen_app/features/address_picker/presentation/address_picker_page.dart';
import 'package:citizen_app/features/authentication/signup/data/models/signup_model.dart';
import 'package:citizen_app/features/authentication/signup/presentation/bloc/signup_bloc.dart';
import 'package:citizen_app/features/authentication/signup/presentation/bloc/signup_event.dart';
import 'package:citizen_app/features/authentication/signup/presentation/bloc/signup_state.dart';
import 'package:citizen_app/features/authentication/signup/presentation/widgets/group_signup_button_widget.dart';
import 'package:citizen_app/features/authentication/signup/presentation/widgets/signup_address_page/captcha_widget.dart';
import 'package:citizen_app/features/common/widgets/inputs/input_multiple_line_widget.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'input_address_widget.dart';

const PERMENANT_WARD_ID = 'pwid';
const PERMENANT_DISTRICT_ID = 'pdid';
const PERMENANT_PROVINCE_ID = 'ppid';
const CURRENT_WARD_ID = 'cwid';
const CURRENT_DISTRICT_ID = 'cdid';
const CURRENT_PROVINCE_ID = 'cpid';

abstract class OnFormSubmitListener {
  validate();
  invalidate();
}

class AddressKeys {
  static final permanentAddressDetailKey = GlobalKey();
  static final currentAddressDetailKey = GlobalKey();
  static final personalIdeaContentKey = GlobalKey();
  static final permanentProvinceKey = GlobalKey();
  static final permanentDistrictKey = GlobalKey();
  static final permanentWardKey = GlobalKey();
  static final currentProvinceKey = GlobalKey();
  static final currentDistrictKey = GlobalKey();
  static final currentWardKey = GlobalKey();
}

class CaptchaIdObserve {
  String id;
}

class FormAddressWidget extends StatefulWidget {
  final ScrollController scrollController;
  final GlobalKey<FormState> formKey;
  final Function onSubmit;
  FormAddressWidget({this.scrollController, this.formKey, this.onSubmit});
  @override
  _FormAddressWidgetState createState() => _FormAddressWidgetState();
}

// OnInputAddressListener using to listen its events
// It contains onClick(String id)
//  - id: [param] identify multiple InputAddressWidget in the same parrent
// [TextEdittingController] using set value in InputAddressWidget
// [FocusNode] using controll focus into textfield, using in scroll invalid
// form.
//
// [AddressCommand] using to retrive data from API

class _FormAddressWidgetState extends State<FormAddressWidget>
    implements OnInputAddressClickListener {
  TextEditingController _permanentWardController;
  TextEditingController _permanentDistrictController;
  TextEditingController _permanentProvinceController;
  TextEditingController _permanentDetailController;
  TextEditingController _currentWardController;
  TextEditingController _currentDistrictController;
  TextEditingController _currentProvinceController;
  TextEditingController _currentDetailController;
  // TextEditingController _captchaIdController;
  CaptchaIdObserve _captchaIdObserve;
  TextEditingController _captchaController;

  FocusNode _permanentWardFocusNode;
  FocusNode _permanentDistrictFocusNode;
  FocusNode _permanentProvinceFocusNode;
  FocusNode _permanentDetailFocusNode;
  FocusNode _currentWardFocusNode;
  FocusNode _currentDistrictFocusNode;
  FocusNode _currentProvinceFocusNode;
  FocusNode _currentDetailFocusNode;
  FocusNode _captchaFocusNode;

  AddressControll _addressControll;
  WardCommand _wardCommand;
  DistrictCommand _districtCommand;
  ProvinceCommand _provinceCommand;

  AddressEntity _permanentWard;
  AddressEntity _permanentDistrict;
  AddressEntity _permanentProvince;
  AddressEntity _currentWard;
  AddressEntity _currentDistrict;
  AddressEntity _currentProvince;

  FocusNode _focusNodeError;
  bool _isChecked = true;
  GlobalKey<FormState> _formKey;
  GlobalKey _keyError;

  void _scroll() {
    if (_keyError != null && context != null) {
      RenderBox box = _keyError.currentContext.findRenderObject();
      Offset position = box.localToGlobal(Offset.zero);
      final _currentPosition = position.dy;
      final height = MediaQuery.of(context).size.height;
      final keyboardPosition = MediaQuery.of(context).viewInsets.bottom;
      final centerPosition = (height - keyboardPosition) / 2.0 - 100;
      final scrollPosition = widget.scrollController.position.pixels +
          (_currentPosition - centerPosition);
      widget.scrollController.animateTo(
        scrollPosition,
        duration: Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
      _keyError = null;
    }
  }

  void _assignPermanentToCurrentAddress(bool isAssign) {
    if (isAssign == false) {
      _currentWard = _permanentWard;
      _currentWardController.text = _currentWard.name;
      _currentDistrict = _permanentDistrict;
      _currentDistrictController.text = _currentDistrict.name;
      _currentProvince = _permanentProvince;
      _currentProvinceController.text = _currentProvince.name;
      _currentDetailController.text = _permanentDetailController.text;
    } else {
      _currentWard = null;
      _currentDistrict = null;
      _currentProvince = null;
      _currentDetailController.text = '';
      _currentWardController.text = '--Chọn--';
      _currentDistrictController.text = '--Chọn--';
      _currentProvinceController.text = '--Chọn--';
    }
  }

  @override
  void initState() {
    _permanentWardController = TextEditingController();
    _permanentDistrictController = TextEditingController();
    _permanentProvinceController = TextEditingController();
    _permanentDetailController = TextEditingController();
    _currentWardController = TextEditingController();
    _currentDistrictController = TextEditingController();
    _currentProvinceController = TextEditingController();
    _currentDetailController = TextEditingController();
    _captchaController = TextEditingController();
    _captchaIdObserve = CaptchaIdObserve();

    final state = BlocProvider.of<SignUpBloc>(context).state;
    if (state is SignUpUpdatedFieldsState) {
      if (state.entity.permanentAddress != null) {
        _permanentDetailController.text = state.entity.permanentAddress;
      }
      if (state.entity.permanentProvince != null) {
        _permanentProvinceController.text = state.entity.permanentProvinceName;
        _permanentProvince = ProvinceModel(
          value: state.entity.permanentProvince,
          name: state.entity.permanentProvinceName,
        );
      }
      if (state.entity.permanentDistrict != null) {
        _permanentDistrictController.text = state.entity.permanentDistrictName;
        _permanentDistrict = DistrictModel(
          value: state.entity.permanentDistrict,
          name: state.entity.permanentDistrictName,
        );
      }
      if (state.entity.permanentWard != null) {
        _permanentWardController.text = state.entity.permanentWardName;
        _permanentWard = WardModel(
          value: state.entity.permanentWard,
          name: state.entity.permanentWardName,
        );
      }
      if (state.entity.currentAddress != null) {
        _currentDetailController.text = state.entity.currentAddress;
      }
      if (state.entity.currentProvince != null) {
        _currentProvinceController.text = state.entity.currentProvinceName;
        _currentProvince = ProvinceModel(
          value: state.entity.currentProvince,
          name: state.entity.currentProvinceName,
        );
      }
      if (state.entity.currentDistrict != null) {
        _currentDistrictController.text = state.entity.currentDistrictName;
        _currentDistrict = DistrictModel(
          value: state.entity.currentDistrict,
          name: state.entity.currentDistrictName,
        );
      }
      if (state.entity.currentWard != null) {
        _currentWardController.text = state.entity.currentWardName;
        _currentWard = WardModel(
          value: state.entity.currentWard,
          name: state.entity.currentWardName,
        );
      }
    }

    _permanentWardFocusNode = FocusNode();
    _permanentDistrictFocusNode = FocusNode();
    _permanentProvinceFocusNode = FocusNode();
    _permanentDetailFocusNode = FocusNode();
    _currentWardFocusNode = FocusNode();
    _currentDistrictFocusNode = FocusNode();
    _currentProvinceFocusNode = FocusNode();
    _currentDetailFocusNode = FocusNode();
    _captchaFocusNode = FocusNode();

    // FormKey using for check validate form field
    _formKey = widget.formKey ?? GlobalKey<FormState>();

    // Address Controll Pattern
    _addressControll = AddressControll();
    _wardCommand = WardCommand(provider: singleton<AddressRemoteDataSource>());
    _districtCommand =
        DistrictCommand(provider: singleton<AddressRemoteDataSource>());
    _provinceCommand =
        ProvinceCommand(provider: singleton<AddressRemoteDataSource>());
    _addressControll.addressCommands
        .putIfAbsent(AddressType.ward, () => _wardCommand);
    _addressControll.addressCommands
        .putIfAbsent(AddressType.district, () => _districtCommand);
    _addressControll.addressCommands
        .putIfAbsent(AddressType.province, () => _provinceCommand);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 38),
        child: Column(
          children: [
            SizedBox(height: 30),
            InputAddressWidget(
              controller: _permanentProvinceController,
              focusNode: _permanentProvinceFocusNode,
              label: trans(PROVINCE_CITY),
              id: PERMENANT_PROVINCE_ID,
              validates: [
                EmptyValidate(),
              ],
              ctx: this,
              key: AddressKeys.permanentProvinceKey,
              focusError: (FocusNode focusNode) {
                if (_focusNodeError == null) {
                  _focusNodeError = focusNode;
                }
                if (_keyError == null) {
                  _keyError = AddressKeys.permanentProvinceKey;
                }
              },
            ),
            SizedBox(height: 5),
            InputAddressWidget(
              controller: _permanentDistrictController,
              focusNode: _permanentDistrictFocusNode,
              label: trans(DISTRICT),
              ctx: this,
              key: AddressKeys.permanentDistrictKey,
              id: PERMENANT_DISTRICT_ID,
              validates: [
                EmptyValidate(),
              ],
              focusError: (FocusNode focusNode) {
                if (_focusNodeError == null) {
                  _focusNodeError = focusNode;
                }
                if (_keyError == null) {
                  _keyError = AddressKeys.permanentDistrictKey;
                }
              },
            ),
            SizedBox(height: 5),
            InputAddressWidget(
              controller: _permanentWardController,
              focusNode: _permanentWardFocusNode,
              label: trans(WARDS),
              key: AddressKeys.permanentWardKey,
              isRequired: false,
              ctx: this,
              id: PERMENANT_WARD_ID,
              validates: [
                EmptyValidate(),
              ],
              focusError: (FocusNode focusNode) {
                if (_focusNodeError == null) {
                  _focusNodeError = focusNode;
                }
                if (_keyError == null) {
                  _keyError = AddressKeys.permanentWardKey;
                }
              },
            ),
            InputMultipleLineWidget(
              focusNode: _permanentDetailFocusNode,
              controller: _permanentDetailController,
              hintText: trans(DETAILED_ADDRESS),
              validates: [
                EmptyValidate(),
              ],
              focusError: (FocusNode focusNode) {
                if (_focusNodeError == null) {
                  _focusNodeError = focusNode;
                }
              },
            ),
            Theme(
              data: ThemeData(
                unselectedWidgetColor: BORDER_COLOR,
              ),
              child: CheckboxListTile(
                value: _isChecked,
                onChanged: (bool value) {
                  setState(() {
                    _isChecked = value;
                  });
                  _assignPermanentToCurrentAddress(_isChecked);
                },
                title: Text(
                  trans(PERMANENT_ADDRESS_NOT_CURRENT_ADDRESS),
                  style: GoogleFonts.inter(
                    fontSize: FONT_MIDDLE,
                    color: Color(0xff565252),
                    fontWeight: FontWeight.normal,
                    height: 1.8,
                  ),
                ),
                activeColor: PRIMARY_COLOR,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.only(right: 15),
              ),
            ),
            SizedBox(height: 30),
            InputAddressWidget(
              controller: _currentProvinceController,
              focusNode: _currentProvinceFocusNode,
              label: trans(PROVINCE_CITY),
              ctx: this,
              key: AddressKeys.currentProvinceKey,
              id: CURRENT_PROVINCE_ID,
              // validates: _isChecked
              //     ? [
              //         EmptyValidate(),
              //       ]
              //     : [],
              focusError: (FocusNode focusNode) {
                if (_focusNodeError == null) {
                  _focusNodeError = focusNode;
                }
                if (_keyError == null) {
                  _keyError = AddressKeys.currentProvinceKey;
                }
              },
            ),
            SizedBox(height: 5),
            InputAddressWidget(
              controller: _currentDistrictController,
              focusNode: _currentDistrictFocusNode,
              label: trans(DISTRICT),
              ctx: this,
              key: AddressKeys.currentDistrictKey,
              id: CURRENT_DISTRICT_ID,
              // validates: _isChecked
              //     ? [
              //         EmptyValidate(),
              //       ]
              //     : [],
              focusError: (FocusNode focusNode) {
                if (_focusNodeError == null) {
                  _focusNodeError = focusNode;
                }
                if (_keyError == null) {
                  _keyError = AddressKeys.currentDistrictKey;
                }
              },
            ),
            SizedBox(height: 5),
            InputAddressWidget(
              controller: _currentWardController,
              focusNode: _currentWardFocusNode,
              label: WARDS,
              isRequired: false,
              key: AddressKeys.currentWardKey,
              ctx: this,
              id: CURRENT_WARD_ID,
              // validates: _isChecked
              //     ? [
              //         EmptyValidate(),
              //       ]
              //     : [],
              focusError: (FocusNode focusNode) {
                if (_focusNodeError == null) {
                  _focusNodeError = focusNode;
                }
                if (_keyError == null) {
                  _keyError = AddressKeys.currentWardKey;
                }
              },
            ),
            SizedBox(height: 5),
            InputMultipleLineWidget(
              focusNode: _currentDetailFocusNode,
              controller: _currentDetailController,
              hintText: trans(DETAILED_ADDRESS),
              validates: _isChecked
                  ? [
                      EmptyValidate(),
                    ]
                  : [],
              focusError: (FocusNode focusNode) {
                if (_focusNodeError == null) {
                  _focusNodeError = focusNode;
                }
              },
            ),
            // SizedBox(height: 20),
            // GroupSignUpButtonWidget(
            //   formKey: _formKey,
            //   margin: EdgeInsets.zero,
            //   onInValidate: () {
            //     FocusScope.of(context).requestFocus(_focusNodeError);
            //     _focusNodeError = null;
            //     _scroll();
            //   },
            // ),
            CaptchaWidget(
                captchaController: _captchaController,
                captchaFocusNode: _captchaFocusNode,
                // captchaIdController: _captchaIdController,
                captchaIdObserve: _captchaIdObserve),
            SizedBox(height: 20),
            widget.onSubmit == null
                ? GroupSignUpButtonWidget(
                    formKey: _formKey,
                    margin: EdgeInsets.zero,
                    onInValidate: () {
                      FocusScope.of(context).requestFocus(_focusNodeError);
                      _focusNodeError = null;
                      _scroll();
                    },
                    onValidate: () {
                      final tmp = SignUpModel();
                      tmp.permanentAddress =
                          _permanentDetailController.text.trim();
                      tmp.permanentProvince = _permanentProvince.value;
                      tmp.permanentDistrict = _permanentDistrict.value;
                      tmp.permanentWard = _permanentWard.value;
                      tmp.permanentProvinceName = _permanentProvince.name;
                      tmp.permanentDistrictName = _permanentDistrict.name;
                      tmp.permanentWardName = _permanentWard.name;
                      tmp.permanentProvince = _permanentProvince.value;
                      tmp.permanentDistrict = _permanentDistrict.value;
                      tmp.permanentWard = _permanentWard.value;
                      tmp.currentAddress = _currentDetailController.text.trim();
                      tmp.currentProvince = _currentProvince.value;
                      tmp.currentDistrict = _currentDistrict.value;
                      tmp.currentWard = _currentWard.value;
                      tmp.currentProvinceName = _currentProvince.name;
                      tmp.currentDistrictName = _currentDistrict.name;
                      tmp.currentWardName = _currentWard.name;
                      tmp.captcha = _captchaController.text.trim();
                      tmp.captchaId = _captchaIdObserve.id;
                      print(_captchaController.text);
                      BlocProvider.of<SignUpBloc>(context)
                          .add(SignUpUpdateFieldsEvent(entity: tmp));
                      BlocProvider.of<SignUpBloc>(context)
                          .add(RegisterAccountEvent(entity: null));
                    },
                    // router: ActiveAccountOtpPage(),
                  )
                : SizedBox(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  @override
  onClick(String id) async {
    switch (id) {
      case PERMENANT_WARD_ID:
        if (_permanentDistrict != null) {
          _permanentWard = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddressPickerPage(
                title: trans(WARDS),
                addressCommand: _wardCommand,
                parentId: _permanentDistrict.id,
              ),
            ),
          );

          if (_permanentWard != null) {
            _permanentWardController.text = _permanentWard.name;
          }
        }
        break;
      case PERMENANT_DISTRICT_ID:
        if (_permanentProvince != null) {
          _permanentDistrict = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddressPickerPage(
                title: trans(DISTRICT),
                addressCommand: _districtCommand,
                parentId: _permanentProvince.id,
              ),
            ),
          );

          if (_permanentDistrict != null) {
            _permanentDistrictController.text = _permanentDistrict.name;
            _permanentWardController.clear();
            _permanentWard = null;
          }
        }
        break;
      case PERMENANT_PROVINCE_ID:
        _permanentProvince = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddressPickerPage(
              title: trans(CITY_PROVINCE),
              addressCommand: _provinceCommand,
            ),
          ),
        );
        if (_permanentProvince != null) {
          _permanentProvinceController.text = _permanentProvince.name;
          // Clear District, Ward when Province deselected
          // Clear value in InputAddressForm
          // Reset value address entity of them
          _permanentWardController.clear();
          _permanentDistrictController.clear();
          _permanentDistrict = null;
          _permanentWard = null;
        }
        break;
      case CURRENT_WARD_ID:
        if (_currentDistrict != null) {
          _currentWard = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddressPickerPage(
                title: trans(WARDS),
                addressCommand: _wardCommand,
                parentId: _currentDistrict.id,
              ),
            ),
          );

          if (_currentWard != null) {
            _currentWardController.text = _currentWard.name;
          }
        }
        break;
      case CURRENT_DISTRICT_ID:
        if (_currentProvince != null) {
          _currentDistrict = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddressPickerPage(
                title: trans(DISTRICT),
                parentId: _currentProvince.id,
                addressCommand: _districtCommand,
              ),
            ),
          );

          if (_currentDistrict != null) {
            _currentDistrictController.text = _currentDistrict.name;
            _currentWard = null;
            _currentWardController.clear();
          }
        }
        break;
      case CURRENT_PROVINCE_ID:
        _currentProvince = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddressPickerPage(
              title: trans(CITY_PROVINCE),
              addressCommand: _provinceCommand,
            ),
          ),
        );
        if (_currentProvince != null) {
          _currentProvinceController.text = _currentProvince.name;
          _currentWardController.clear();
          _currentDistrictController.clear();
          _currentDistrict = null;
          _currentWard = null;
        }
        break;
      default:
    }
  }
}
