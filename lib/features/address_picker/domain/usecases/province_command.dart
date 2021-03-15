
import 'package:citizen_app/features/address_picker/data/datasources/address_remote_data_source.dart';
import 'package:citizen_app/features/address_picker/domain/entities/address_entity.dart';

import 'interface_address_command.dart';

class ProvinceCommand extends InterfaceAddressCommand {
  AddressRemoteDataSource provider;

  ProvinceCommand({this.provider});

  @override
  Future<List<AddressEntity>> execute(int parentId) async {
    return await provider.fetchProvices(parentId);
  }
}
