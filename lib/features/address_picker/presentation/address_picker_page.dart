import 'dart:async';

import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/address_picker/domain/entities/address_entity.dart';
import 'package:citizen_app/features/address_picker/domain/usecases/interface_address_command.dart';
import 'package:citizen_app/features/address_picker/presentation/widgets/address_list_item.dart';
import 'package:citizen_app/features/common/widgets/inputs/input_search_widget.dart';
import 'package:citizen_app/features/common/widgets/layouts/base_layout_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class AddressPickerModel {
  AddressEntity addressEntity;
  bool isChecked;

  AddressPickerModel({this.addressEntity, this.isChecked = false});
}

class AddressPickerPage extends StatefulWidget {
  final String title;

  /// [parentId] is id of parrent's address
  /// Ex: [Province] has many [District]
  final int parentId;

  /// [addressCommand] using for fetch data from server
  /// [InterfaceAddressCommand] using like base for both types
  /// of address [Province, District, Ward]
  final InterfaceAddressCommand addressCommand;
  AddressPickerPage({this.title, this.addressCommand, this.parentId});

  @override
  _AddressPickerPageState createState() => _AddressPickerPageState();
}

class _AddressPickerPageState extends State<AddressPickerPage>
    implements OnInputSearchSubmitListener, OnSelecteAddressListItemListener {
  /// [_addresses] contains whole values fetched from server
  List<AddressPickerModel> _addresses = [];

  /// [_addrRender] contains values which using for render
  /// Search task needs to filter some data and render theme back
  List<AddressPickerModel> _addrRender = [];

  /// Delay time type keyboard, and search
  Timer _debounce;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        /// Filter a value which choiced and return to previous page
        /// [result] should be [null] or [String]
        var result;
        try {
          result = _addrRender
              .firstWhere((element) => element.isChecked)
              ?.addressEntity;
        } catch (e) {
          print(e);
        } finally {
          Navigator.pop(context, result);
        }
        return true;
      },
      child: BaseLayoutWidget(
        title: widget.title,
        centerTitle: true,
        onPop: () {
          var result;
          try {
            result = _addrRender
                .firstWhere((element) => element.isChecked)
                ?.addressEntity;
          } finally {
            Navigator.pop(context, result);
          }
        },
        body: Container(
          child: Column(
            children: [
              SizedBox(height: 16),
              InputSearchWidget(ctx: this),
              SizedBox(height: 20),
              FutureBuilder<List<AddressEntity>>(
                future: widget.addressCommand.execute(widget.parentId),
                builder: (_, snap) {
                  if (snap.hasData) {
                    if (_addresses.isEmpty) {
                      _addresses = snap.data
                          .map((e) => AddressPickerModel(addressEntity: e))
                          .toList();
                      _addrRender = _addresses;
                    }
                    if (_addrRender.isEmpty) {
                      return Expanded(
                        child: Column(
                          children: [
                            Image.asset(
                              IMAGE_ASSETS_PATH + 'icon_none.png',
                            ),
                            Text(
                              trans(NO_DATA),
                              style: GoogleFonts.inter(
                                fontSize: FONT_LARGE,
                                color: SECONDARY_TEXT_COLOR,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      return Expanded(
                        child: ListView.builder(
                          itemBuilder: (_, index) {
                            return AddressListItem(
                              address: _addrRender[index],
                              ctx: this,
                            );
                          },
                          itemCount: _addrRender.length,
                        ),
                      );
                    }
                  } else if (snap.hasError) {
                    return Center(
                      child: Text('Something went wrong'),
                    );
                  } else {
                    return Expanded(
                      child: Center(
                        child: SleekCircularSlider(
                          appearance: CircularSliderAppearance(
                            spinnerMode: true,
                            size: 30,
                            customColors: CustomSliderColors(
                              dotColor: PRIMARY_COLOR,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  onChange(String keyword) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () {
        if (keyword.isEmpty == false) {
          print(keyword);
          final pattern = r'' + keyword;
          _addrRender = _addresses
              .where((element) => element.addressEntity.name.contains(
                  RegExp(pattern, caseSensitive: false, unicode: true)))
              .toList();
          setState(() {});
        } else {
          _addrRender = _addresses;
          setState(() {});
        }
      },
    );
  }

  @override
  onSubmit(String keyword) {}

  @override
  onSelect(AddressEntity address) {
    _addresses.forEach((element) {
      if (element.addressEntity != address) element.isChecked = false;
    });
    final selectedAddr =
        _addrRender.firstWhere((element) => element.addressEntity == address);
    selectedAddr.isChecked = !selectedAddr.isChecked;
    setState(() {});
  }
}
