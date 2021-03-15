
import 'package:citizen_app/features/address_picker/domain/entities/address_entity.dart';

abstract class InterfaceAddressCommand {
  Future<List<AddressEntity>> execute(int parentId);
}
