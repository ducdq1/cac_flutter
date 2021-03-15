import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/validate/empty_validate.dart';
import 'package:citizen_app/features/address_picker/data/datasources/address_remote_data_source.dart';
import 'package:citizen_app/features/address_picker/domain/entities/address_entity.dart';
import 'package:citizen_app/features/address_picker/domain/usecases/address_command_exp.dart';
import 'package:citizen_app/features/address_picker/presentation/address_picker_page.dart';
import 'package:citizen_app/features/authentication/signup/presentation/widgets/signup_address_page/input_address_widget.dart';
import 'package:citizen_app/features/common/widgets/inputs/input_multiple_line_widget.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const PERMENANT_WARD_ID = 'pwid';
const PERMENANT_DISTRICT_ID = 'pdid';
const PERMENANT_PROVINCE_ID = 'ppid';
const CURRENT_WARD_ID = 'cwid';
const CURRENT_DISTRICT_ID = 'cdid';
const CURRENT_PROVINCE_ID = 'cpid';

abstract class OnFormAddressSubmitListener {
  validate();
  invalidate();
  scroll();
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

class FormAddressWidget extends StatefulWidget {
  final double scrollPadding;
  final ScrollController scrollController;
  final Function(State) onConnect;
  final Function(FocusNode) focusNodeError;
  final TextEditingController permanentWardController;
  final TextEditingController permanentDistrictController;
  final TextEditingController permanentProvinceController;
  final TextEditingController permanentDetailController;
  final TextEditingController currentWardController;
  final TextEditingController currentDistrictController;
  final TextEditingController currentProvinceController;
  final TextEditingController currentDetailController;

  final FocusNode permanentWardFocusNode;
  final FocusNode permanentDistrictFocusNode;
  final FocusNode permanentProvinceFocusNode;
  final FocusNode permanentDetailFocusNode;
  final FocusNode currentWardFocusNode;
  final FocusNode currentDistrictFocusNode;
  final FocusNode currentProvinceFocusNode;
  final FocusNode currentDetailFocusNode;

  final String permanentProvinceValueDefault;
  final String permanentDistrictValueDefault;
  final String permanentWardValueDefault;
  final String currentProvinceValueDefault;
  final String currentDistrictValueDefault;
  final String currentWardValueDefault;

  final AddressEntity permanentWardObserver;
  final AddressEntity permanentDistrictObserver;
  final AddressEntity permanentProvinceObserver;
  final AddressEntity currentWardObserver;
  final AddressEntity currentDistrictObserver;
  final AddressEntity currentProvinceObserver;

  FormAddressWidget({
    this.scrollController,
    this.scrollPadding = 200,
    this.onConnect,
    this.focusNodeError,
    this.permanentDetailController,
    this.currentDetailController,
    this.currentDetailFocusNode,
    this.currentDistrictController,
    this.currentDistrictFocusNode,
    this.currentProvinceController,
    this.currentProvinceFocusNode,
    this.currentWardController,
    this.currentWardFocusNode,
    this.permanentDetailFocusNode,
    this.permanentDistrictController,
    this.permanentDistrictFocusNode,
    this.permanentProvinceController,
    this.permanentProvinceFocusNode,
    this.permanentWardController,
    this.permanentWardFocusNode,
    this.currentProvinceValueDefault,
    this.currentDistrictValueDefault,
    this.currentWardValueDefault,
    this.permanentProvinceValueDefault,
    this.permanentDistrictValueDefault,
    this.permanentWardValueDefault,
    this.permanentProvinceObserver,
    this.permanentDistrictObserver,
    this.permanentWardObserver,
    this.currentProvinceObserver,
    this.currentDistrictObserver,
    this.currentWardObserver,
  });
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
    implements OnInputAddressClickListener, OnFormAddressSubmitListener {
  // TextEditingController _permanentWardController;
  // TextEditingController _permanentDistrictController;
  // TextEditingController _permanentProvinceController;
  // TextEditingController _permanentDetailController;
  // TextEditingController _currentWardController;
  // TextEditingController _currentDistrictController;
  // TextEditingController _currentProvinceController;
  // TextEditingController _currentDetailController;

  // FocusNode _permanentWardFocusNode;
  // FocusNode _permanentDistrictFocusNode;
  // FocusNode _permanentProvinceFocusNode;
  // FocusNode _permanentDetailFocusNode;
  // FocusNode _currentWardFocusNode;
  // FocusNode _currentDistrictFocusNode;
  // FocusNode _currentProvinceFocusNode;
  // FocusNode _currentDetailFocusNode;

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

  // FocusNode _focusNodeError;
  bool _isChecked = true;
  GlobalKey _keyError;

  @override
  void scroll() {
    if (_keyError != null && context != null) {
      RenderBox box = _keyError.currentContext.findRenderObject();
      Offset position = box.localToGlobal(Offset.zero);
      final _currentPosition = position.dy;
      final height = MediaQuery.of(context).size.height;
      // final keyboardPosition = MediaQuery.of(context).viewInsets.bottom;
      final keyboardPosition = 0.0;
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
      widget.currentWardController.text = _currentWard.name;
      _currentDistrict = _permanentDistrict;
      widget.currentDistrictController.text = _currentDistrict.name;
      _currentProvince = _permanentProvince;
      widget.currentProvinceController.text = _currentProvince.name;
      widget.currentDetailController.text =
          widget.permanentDetailController.text;
    } else {
      _currentWard = null;
      _currentDistrict = null;
      _currentProvince = null;
      widget.currentDetailController.text = '';
      widget.currentWardController.text = trans(SELECT_);
      widget.currentDistrictController.text = trans(SELECT_);
      widget.currentProvinceController.text = trans(SELECT_);
    }
  }

  /// Load init label of address
  /// Cause we just have a value of address
  /// We need more infomation about address:
  /// [id],[value],[label]
  /// Optimiz options's API should return all of infomation
  /// related address.
  /// App just need to convert and use them instead
  Future<AddressEntity> _compareAddress(
      int parentId, AddressType addressType, String address) async {
    print('$address, $parentId, $addressType');
    try {
      final addrs =
          await _addressControll.addressCommands[addressType].execute(parentId);
      print('result:');
      print(addrs);
      if (addrs != null) {
        for (var addr in addrs) {
          if (addr.id == int.tryParse(address)) {
            return addr;
          }
        }
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  /// Load name init for address input fields
  /// [permanent] and [current] address's types
  /// [province], [district], [ward]
  Future<void> _initAddress() async {
    try {
      if (widget.permanentProvinceValueDefault?.isNotEmpty ?? false) {
        _permanentProvince = await _compareAddress(
          -1,
          AddressType.province,
          widget.permanentProvinceValueDefault,
        );
        widget.permanentProvinceController.text = _permanentProvince.name;
        if (_permanentProvince != null &&
            (widget.permanentDistrictValueDefault?.isNotEmpty ?? false)) {
          _permanentDistrict = await _compareAddress(
            _permanentProvince.id,
            AddressType.district,
            widget.permanentDistrictValueDefault,
          );
          widget.permanentDistrictController.text = _permanentDistrict.name;

          if (_permanentDistrict != null &&
              (widget.permanentWardValueDefault?.isNotEmpty ?? false)) {
            _permanentWard = await _compareAddress(
              _permanentDistrict.id,
              AddressType.ward,
              widget.permanentWardValueDefault,
            );
            widget.permanentWardController.text = _permanentWard.name;
          }
        }
      }

      if (widget.currentProvinceValueDefault?.isNotEmpty ?? false) {
        _currentProvince = await _compareAddress(
          -1,
          AddressType.province,
          widget.currentProvinceValueDefault,
        );
        widget.currentProvinceController.text = _currentProvince.name;
        if (_currentProvince != null &&
            (widget.currentDistrictValueDefault?.isNotEmpty ?? false)) {
          _currentDistrict = await _compareAddress(
            _currentProvince.id,
            AddressType.district,
            widget.currentDistrictValueDefault,
          );
          widget.currentDistrictController.text = _currentDistrict.name;

          if (_currentDistrict != null &&
              (widget.currentWardValueDefault?.isNotEmpty ?? false)) {
            _currentWard = await _compareAddress(
              _currentDistrict.id,
              AddressType.ward,
              widget.currentWardValueDefault,
            );
            widget.currentWardController.text = _currentWard.name;
          }
        }
      }
      setState(() {});
    } catch (e) {
      throw e;
    }
  }

  @override
  void initState() {
    widget.onConnect(this);

    // _permanentWardController = TextEditingController();
    // _permanentDistrictController = TextEditingController();
    // _permanentProvinceController = TextEditingController();
    // _permanentDetailController = TextEditingController();
    // _currentWardController = TextEditingController();
    // _currentDistrictController = TextEditingController();
    // _currentProvinceController = TextEditingController();
    // _currentDetailController = TextEditingController();

    // _permanentWardFocusNode = FocusNode();
    // _permanentDistrictFocusNode = FocusNode();
    // _permanentProvinceFocusNode = FocusNode();
    // _permanentDetailFocusNode = FocusNode();
    // _currentWardFocusNode = FocusNode();
    // _currentDistrictFocusNode = FocusNode();
    // _currentProvinceFocusNode = FocusNode();
    // _currentDetailFocusNode = FocusNode();

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
    try {
      _initAddress();
    } catch (e) {
      print(e);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 38),
      child: Column(
        children: [
          SizedBox(height: 30),
          InputAddressWidget(
            scrollPaddingForTop: true,
            scrollPadding: widget.scrollPadding,
            controller: widget.permanentProvinceController,
            focusNode: widget.permanentProvinceFocusNode,
            label: trans(PROVINCE_CITY),
            id: PERMENANT_PROVINCE_ID,
            validates: [
              EmptyValidate(),
            ],
            ctx: this,
            key: AddressKeys.permanentProvinceKey,
            focusError: (FocusNode focusNode) {
              // if (_focusNodeError == null) {
              //   _focusNodeError = focusNode;
              // }
              widget.focusNodeError(focusNode);
              if (_keyError == null) {
                _keyError = AddressKeys.permanentProvinceKey;
              }
            },
          ),
          SizedBox(height: 5),
          InputAddressWidget(
            scrollPaddingForTop: true,
            scrollPadding: widget.scrollPadding,
            controller: widget.permanentDistrictController,
            focusNode: widget.permanentDistrictFocusNode,
            label: trans(DISTRICT),
            ctx: this,
            key: AddressKeys.permanentDistrictKey,
            id: PERMENANT_DISTRICT_ID,
            validates: [
              EmptyValidate(),
            ],
            focusError: (FocusNode focusNode) {
              // if (_focusNodeError == null) {
              //   _focusNodeError = focusNode;
              // }
              widget.focusNodeError(focusNode);

              if (_keyError == null) {
                _keyError = AddressKeys.permanentDistrictKey;
              }
            },
          ),
          SizedBox(height: 5),
          InputAddressWidget(
            scrollPaddingForTop: true,
            scrollPadding: widget.scrollPadding,
            controller: widget.permanentWardController,
            focusNode: widget.permanentWardFocusNode,
            label: trans(WARDS),
            key: AddressKeys.permanentWardKey,
            isRequired: false,
            ctx: this,
            id: PERMENANT_WARD_ID,
            validates: [
              EmptyValidate(),
            ],
            focusError: (FocusNode focusNode) {
              // if (_focusNodeError == null) {
              //   _focusNodeError = focusNode;
              // }
              widget.focusNodeError(focusNode);

              if (_keyError == null) {
                _keyError = AddressKeys.permanentWardKey;
              }
            },
          ),
          InputMultipleLineWidget(
            scrollPadding: widget.scrollPadding,
            focusNode: widget.permanentDetailFocusNode,
            controller: widget.permanentDetailController,
            hintText: trans(DETAILED_ADDRESS),
            validates: [
              EmptyValidate(),
            ],
            focusError: (FocusNode focusNode) {
              // if (_focusNodeError == null) {
              //   _focusNodeError = focusNode;
              // }
              widget.focusNodeError(focusNode);
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
            scrollPadding: widget.scrollPadding,
            scrollPaddingForTop: true,
            controller: widget.currentProvinceController,
            focusNode: widget.currentProvinceFocusNode,
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
              // if (_focusNodeError == null) {
              //   _focusNodeError = focusNode;
              // }
              widget.focusNodeError(focusNode);

              if (_keyError == null) {
                _keyError = AddressKeys.currentProvinceKey;
              }
            },
          ),
          SizedBox(height: 5),
          InputAddressWidget(
            scrollPadding: widget.scrollPadding,
            scrollPaddingForTop: true,
            controller: widget.currentDistrictController,
            focusNode: widget.currentDistrictFocusNode,
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
              // if (_focusNodeError == null) {
              //   _focusNodeError = focusNode;
              // }
              widget.focusNodeError(focusNode);

              if (_keyError == null) {
                _keyError = AddressKeys.currentDistrictKey;
              }
            },
          ),
          SizedBox(height: 5),
          InputAddressWidget(
            scrollPadding: widget.scrollPadding,
            scrollPaddingForTop: true,

            controller: widget.currentWardController,
            focusNode: widget.currentWardFocusNode,
            label: trans(WARDS),
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
              // if (_focusNodeError == null) {
              //   _focusNodeError = focusNode;
              // }
              widget.focusNodeError(focusNode);

              if (_keyError == null) {
                _keyError = AddressKeys.currentWardKey;
              }
            },
          ),
          SizedBox(height: 5),
          InputMultipleLineWidget(
            scrollPadding: widget.scrollPadding,
            focusNode: widget.currentDetailFocusNode,
            controller: widget.currentDetailController,
            hintText: trans(DETAILED_ADDRESS),
            validates: _isChecked
                ? [
                    EmptyValidate(),
                  ]
                : [],
            focusError: (FocusNode focusNode) {
              // if (_focusNodeError == null) {
              //   _focusNodeError = focusNode;
              // }
              widget.focusNodeError(focusNode);
            },
          ),
          SizedBox(height: 20),
        ],
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
            widget.permanentWardController.text = _permanentWard.name;
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
            widget.permanentDistrictController.text = _permanentDistrict.name;
            widget.permanentWardController.clear();
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
          widget.permanentProvinceController.text = _permanentProvince.name;
          // Clear District, Ward when Province deselected
          // Clear value in InputAddressForm
          // Reset value address entity of them
          widget.permanentWardController.clear();
          widget.permanentDistrictController.clear();
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
            widget.currentWardController.text = _currentWard.name;
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
            widget.currentDistrictController.text = _currentDistrict.name;
            _currentWard = null;
            widget.currentWardController.clear();
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
          widget.currentProvinceController.text = _currentProvince.name;
          widget.currentWardController.clear();
          widget.currentDistrictController.clear();
          _currentDistrict = null;
          _currentWard = null;
        }
        break;
      default:
    }
  }

  @override
  invalidate() {
    // FocusScope.of(context).requestFocus(_focusNodeError);
    // _focusNodeError = null;
    // _scroll();
  }

  @override
  validate() {
    print('validate address form');
    widget.permanentProvinceObserver.copyWith(another: _permanentProvince);
    widget.permanentDistrictObserver.copyWith(another: _permanentDistrict);
    widget.permanentWardObserver.copyWith(another: _permanentWard);

    widget.currentProvinceObserver.copyWith(another: _currentProvince);
    widget.currentDistrictObserver.copyWith(another: _currentDistrict);
    widget.currentWardObserver.copyWith(another: _currentWard);
  }
}
