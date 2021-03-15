
import 'package:citizen_app/features/address_picker/domain/entities/address_entity.dart';

import 'interface_address_command.dart';

enum AddressType { ward, district, province }

class AddressControll {
  Map<AddressType, InterfaceAddressCommand> addressCommands = {};

  void add(AddressType addressType, InterfaceAddressCommand command) {
    addressCommands.putIfAbsent(addressType, () => command);
  }

  Future<List<AddressEntity>> fetch(
      AddressType addressType, int parrentId) async {
    return await addressCommands[addressType].execute(parrentId);
  }
}
