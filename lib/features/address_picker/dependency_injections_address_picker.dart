import 'package:citizen_app/features/address_picker/data/datasources/address_remote_data_source.dart';
import 'package:get_it/get_it.dart';

Future<void> dependencyInjectionsAddressPicker(GetIt singleton) async {
  // Repository
  singleton.registerLazySingleton(
      () => AddressRemoteDataSource(client: singleton()));
}
