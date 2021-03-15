import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/address_picker/data/models/district_model.dart';
import 'package:citizen_app/features/address_picker/data/models/province_model.dart';
import 'package:citizen_app/features/address_picker/data/models/ward_model.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_bloc.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_state.dart';
import 'package:citizen_app/features/common/dialogs/loading_dialog.dart';
import 'package:citizen_app/features/profile/data/models/update_profile_model.dart';
import 'package:citizen_app/features/profile/presentation/bloc/update_profile_bloc.dart';
import 'package:citizen_app/features/profile/presentation/bloc/update_profile_event.dart';
import 'package:citizen_app/features/profile/presentation/bloc/update_profile_state.dart';
import 'package:citizen_app/features/profile/presentation/widgets/update_profile/form_address_widget.dart';
import 'package:citizen_app/features/profile/presentation/widgets/update_profile/form_personal_widget.dart';
import 'package:citizen_app/features/profile/presentation/widgets/update_profile/submit_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  GlobalKey _formKey;
  ScrollController _scrollController;
  TextEditingController _usernameController;
  TextEditingController _identityNoController;
  TextEditingController _emailController;
  TextEditingController _phoneController;
  TextEditingController _genderController;
  TextEditingController _dobController;

  // address form
  TextEditingController _permanentWardController;
  TextEditingController _permanentDistrictController;
  TextEditingController _permanentProvinceController;
  TextEditingController _permanentDetailController;
  TextEditingController _currentWardController;
  TextEditingController _currentDistrictController;
  TextEditingController _currentProvinceController;
  TextEditingController _currentDetailController;

  FocusNode _permanentWardFocusNode;
  FocusNode _permanentDistrictFocusNode;
  FocusNode _permanentProvinceFocusNode;
  FocusNode _permanentDetailFocusNode;
  FocusNode _currentWardFocusNode;
  FocusNode _currentDistrictFocusNode;
  FocusNode _currentProvinceFocusNode;
  FocusNode _currentDetailFocusNode;
  State _formAddressState;
  FocusNode _focusNodeError;

  UpdateProfileModel profile;

  WardModel _permanentWardObserver;
  DistrictModel _permanentDistrictObserver;
  ProvinceModel _permanentProvinceObserver;
  WardModel _currentWardObserver;
  DistrictModel _currentDistrictObserver;
  ProvinceModel _currentProvinceObserver;

  /// Get first error field in form
  /// [focusNode] should be attach to the field
  void _focusError(FocusNode focusNode) {
    if (_focusNodeError == null) _focusNodeError = focusNode;
  }

  /// Connect function using for get context of child
  /// It helps parrent can call some method from child
  /// [Child] should be a statefull widget and [state]
  void _onConnect(State state) {
    if (_formAddressState == null) {
      _formAddressState = state;
    }
  }

  @override
  void initState() {
    final userId = 0;
    BlocProvider.of<UpdateProfileBloc>(context)
        .add(FetchingProfileEvent(userId: userId));
    _formKey = GlobalKey<FormState>();
    _scrollController = ScrollController();
    _usernameController = TextEditingController();
    _identityNoController = TextEditingController();
    _emailController = TextEditingController();
    _genderController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _dobController = TextEditingController();

    // address form
    _permanentWardController = TextEditingController();
    _permanentDistrictController = TextEditingController();
    _permanentProvinceController = TextEditingController();
    _permanentDetailController = TextEditingController();
    _currentWardController = TextEditingController();
    _currentDistrictController = TextEditingController();
    _currentProvinceController = TextEditingController();
    _currentDetailController = TextEditingController();

    _permanentWardFocusNode = FocusNode();
    _permanentDistrictFocusNode = FocusNode();
    _permanentProvinceFocusNode = FocusNode();
    _permanentDetailFocusNode = FocusNode();
    _currentWardFocusNode = FocusNode();
    _currentDistrictFocusNode = FocusNode();
    _currentProvinceFocusNode = FocusNode();
    _currentDetailFocusNode = FocusNode();

    _permanentWardObserver = WardModel();
    _permanentDistrictObserver = DistrictModel();
    _permanentProvinceObserver = ProvinceModel();

    _currentWardObserver = WardModel();
    _currentDistrictObserver = DistrictModel();
    _currentProvinceObserver = ProvinceModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scrollPadding = MediaQuery.of(context).size.height / 2;
    return Form(
      key: _formKey,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: PRIMARY_COLOR,
          appBar: AppBar(
            backgroundColor: PRIMARY_COLOR,
            leading: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: IconButton(
                icon: Center(
                  child:
                      SvgPicture.asset(SVG_ASSETS_PATH + 'icon_arrow_back.svg'),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            centerTitle: true,
            elevation: 0,
            title: Text(
              trans(UPDATE_ACCOUNT),
              style: GoogleFonts.openSans(
                color: Colors.white,
                fontSize: FONT_EX_LARGE,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: BlocConsumer<UpdateProfileBloc, UpdateProfileState>(
            listener: (_, state) {
              if (state is UpdateProfileSucceedState) {
                Navigator.pop(context);
                Navigator.pop(context);
                Fluttertoast.showToast(
                  msg: trans(UPDATE_SUCCESS),
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black87,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              } else if (state is UpdateProfileFaildState) {
                Navigator.pop(context);
                Fluttertoast.showToast(
                  msg: state.message,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black87,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              } else if (state is UpdateProfileProcessingState) {
                showLoadingDialog(context, trans(UPDATING_ACCOUNT));
              }
            },
            builder: (_, state) {
              if (state is FetchProfileProcessingState) {
                return Center(
                  child: SleekCircularSlider(
                    appearance: CircularSliderAppearance(
                      spinnerMode: true,
                      size: 40,
                      customColors: CustomSliderColors(
                        dotColor: PRIMARY_COLOR,
                      ),
                    ),
                  ),
                );
              } else if (state is FetchProfileFaildState) {
                return Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.cloud_off,
                        color: Colors.grey[200],
                        size: 40,
                      ),
                      Text(
                        state.message,
                        style: GoogleFonts.inter(
                          fontSize: FONT_SMALL,
                          color: Colors.grey[200],
                        ),
                      )
                    ],
                  ),
                );
              } else {
                if (profile == null && state is FetchProfileSucceedState) {
                  profile = state.profile;
                  _usernameController.text = profile.customerName;
                  _dobController.text = profile.dob;
                  _genderController.text = profile.gender?.toString() ?? '1';
                  _identityNoController.text = profile.identityNo;
                  _phoneController.text = profile.phone;
                  _emailController.text = profile.email;
                  _permanentDetailController.text = profile.permanentAddress;
                  _currentDetailController.text = profile.currentAddress;
                }
                return profile != null
                    ? Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 70),
                            padding: EdgeInsets.only(top: 80),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            child: NotificationListener<
                                OverscrollIndicatorNotification>(
                              onNotification:
                                  (OverscrollIndicatorNotification overscroll) {
                                overscroll.disallowGlow();
                                return false;
                              },
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                child: Column(
                                  children: [
                                    Text(
                                      trans(TITLE_ACCOUNT_INFORMATION_SCREEN),
                                      style: GoogleFonts.inter(
                                        fontSize: FONT_EX_LARGE,
                                        fontWeight: FontWeight.w600,
                                        height: 1.4,
                                        color: PRIMARY_TEXT_COLOR,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    FormPersonalWidget(
                                      scrollPadding: 100,
                                      dobController: _dobController,
                                      usernameController: _usernameController,
                                      emailController: _emailController,
                                      genderController: _genderController,
                                      identityNoController:
                                          _identityNoController,
                                      phoneController: _phoneController,
                                      focusNodeError: _focusError,
                                    ),
                                    SizedBox(height: 40),
                                    Text(
                                      trans(PERMANENT_ADDRESS),
                                      style: GoogleFonts.inter(
                                        fontSize: FONT_EX_LARGE,
                                        fontWeight: FontWeight.w600,
                                        height: 1.4,
                                        color: PRIMARY_TEXT_COLOR,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    FormAddressWidget(
                                      scrollPadding: scrollPadding,
                                      onConnect: _onConnect,
                                      scrollController: _scrollController,
                                      focusNodeError: _focusError,
                                      currentDetailController:
                                          _currentDetailController,
                                      currentProvinceController:
                                          _currentProvinceController,
                                      currentDistrictController:
                                          _currentDistrictController,
                                      currentWardController:
                                          _currentWardController,
                                      permanentDetailController:
                                          _permanentDetailController,
                                      permanentProvinceController:
                                          _permanentProvinceController,
                                      permanentDistrictController:
                                          _permanentDistrictController,
                                      permanentWardController:
                                          _permanentWardController,
                                      currentDetailFocusNode:
                                          _currentDetailFocusNode,
                                      currentProvinceFocusNode:
                                          _currentProvinceFocusNode,
                                      currentDistrictFocusNode:
                                          _currentDistrictFocusNode,
                                      currentWardFocusNode:
                                          _currentWardFocusNode,
                                      permanentDetailFocusNode:
                                          _permanentDetailFocusNode,
                                      permanentProvinceFocusNode:
                                          _permanentProvinceFocusNode,
                                      permanentDistrictFocusNode:
                                          _permanentDistrictFocusNode,
                                      permanentWardFocusNode:
                                          _permanentWardFocusNode,
                                      permanentProvinceValueDefault:
                                          profile?.permanentProvince,
                                      permanentDistrictValueDefault:
                                          profile?.permanentDistrict,
                                      permanentWardValueDefault:
                                          profile?.permanentWard,
                                      currentProvinceValueDefault:
                                          profile?.currentProvince,
                                      currentDistrictValueDefault:
                                          profile?.currentDistrict,
                                      currentWardValueDefault:
                                          profile?.currentWard,
                                      permanentProvinceObserver:
                                          _permanentProvinceObserver,
                                      permanentDistrictObserver:
                                          _permanentDistrictObserver,
                                      permanentWardObserver:
                                          _permanentWardObserver,
                                      currentProvinceObserver:
                                          _currentProvinceObserver,
                                      currentDistrictObserver:
                                          _currentDistrictObserver,
                                      currentWardObserver: _currentWardObserver,
                                    ),
                                    SizedBox(height: 20),
                                    SubmitButtonWidget(
                                      formKey: _formKey,
                                      invalidate: () {
                                        print('invalide');
                                        FocusScope.of(context)
                                            .requestFocus(_focusNodeError);
                                        if (_focusNodeError == _permanentProvinceFocusNode ||
                                            _focusNodeError ==
                                                _permanentDistrictFocusNode ||
                                            _focusNodeError ==
                                                _permanentWardFocusNode ||
                                            _focusNodeError ==
                                                _currentProvinceFocusNode ||
                                            _focusNodeError ==
                                                _currentDistrictFocusNode ||
                                            _focusNodeError ==
                                                _currentWardFocusNode) {
                                          (_formAddressState
                                                  as OnFormAddressSubmitListener)
                                              .scroll();
                                        }
                                        (_formAddressState
                                                as OnFormAddressSubmitListener)
                                            .invalidate();
                                        _focusNodeError = null;
                                      },
                                      validate: () {
                                        /// Pick value address from form
                                        (_formAddressState
                                                as OnFormAddressSubmitListener)
                                            .validate();
                                        final updateProfile =
                                            (state as FetchProfileSucceedState)
                                                .profile;
                                        updateProfile.customerName =
                                            _usernameController.text.trim();
                                        updateProfile.dob =
                                            _dobController.text.trim();
                                        updateProfile.gender =
                                            int.parse(_genderController.text);
                                        updateProfile.identityNo =
                                            _identityNoController.text.trim();
                                        updateProfile.phone =
                                            _phoneController.text.trim();
                                        updateProfile.email =
                                            _emailController.text.trim();

                                        /// Address Fields
                                        /// Permanent Fields
                                        updateProfile.permanentAddress =
                                            _permanentDetailController.text
                                                .trim();
                                        updateProfile.permanentProvince =
                                            _permanentProvinceObserver.value;
                                        updateProfile.permanentDistrict =
                                            _permanentDistrictObserver.value;
                                        updateProfile.permanentWard =
                                            _permanentWardObserver.value;

                                        /// Current Fields

                                        updateProfile.currentAddress =
                                            _currentDetailController.text
                                                .trim();
                                        updateProfile.currentProvince =
                                            _currentProvinceObserver.value;
                                        updateProfile.currentDistrict =
                                            _currentDistrictObserver.value;
                                        updateProfile.currentWard =
                                            _currentWardObserver.value;

                                        /// Check update-profile fields with data set
                                        /// If something went wrong with update profile
                                        /// should come back here and check
                                        print(updateProfile.toString());
                                        BlocProvider.of<UpdateProfileBloc>(
                                                context)
                                            .add(UpdatingProfileEvent(
                                                profile: updateProfile));
                                      },
                                    ),
                                    SizedBox(height: 40)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 5,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 60,
                                  child: Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: Image.asset(
                                      IMAGE_ASSETS_PATH + 'avatar_example.png',
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      onTap: () {},
                                      child: Container(
                                        padding: EdgeInsets.all(7.0),
                                        child: SvgPicture.asset(
                                            SVG_ASSETS_PATH +
                                                'update_avatar_icon.svg'),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    : Center(
                        child: SleekCircularSlider(
                          appearance: CircularSliderAppearance(
                            spinnerMode: true,
                            size: 40,
                            customColors: CustomSliderColors(
                              dotColor: PRIMARY_COLOR,
                            ),
                          ),
                        ),
                      );
              }
            },
          ),
        ),
      ),
    );
  }
}
