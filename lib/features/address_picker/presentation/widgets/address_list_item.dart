import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:citizen_app/features/address_picker/domain/entities/address_entity.dart';
import 'package:citizen_app/features/address_picker/presentation/address_picker_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class OnSelecteAddressListItemListener {
  onSelect(AddressEntity address);
}

class AddressListItem extends StatelessWidget {
  final AddressPickerModel address;
  final State ctx;

  AddressListItem({this.address, this.ctx});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: address.isChecked ? Color(0xffF1FBEF) : Colors.transparent,
      child: InkWell(
        splashColor: Color(0xffF1FBEE),
        highlightColor: Color(0xffF1FBEF),
        onTap: () {
          (ctx as OnSelecteAddressListItemListener)
              .onSelect(address.addressEntity);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: BORDER_COLOR.withOpacity(0.2), width: 0.8)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    address.addressEntity.name,
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: FONT_MIDDLE,
                    ),
                  ),
                  address.isChecked
                      ? Icon(
                          Icons.check,
                          color: PRIMARY_COLOR,
                        )
                      : SizedBox()
                ],
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
