
import 'package:citizen_app/core/error/exceptions.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/network/network_request.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/features/home/data/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

abstract class AppModuleRemoteDataSource {
  Future<AppModuleModel> getAppModules({int provinceId, int userId});
}

class AppModuleRemoteDataSourceImpl implements AppModuleRemoteDataSource {
  final http.Client client;
  final NetworkRequest networkRequest;
  AppModuleRemoteDataSourceImpl(
      {@required this.client, @required this.networkRequest});

  @override
  Future<AppModuleModel> getAppModules({int provinceId, int userId}) async {
    try {

        List<AppHeaderModel> headers = List<AppHeaderModel>(1) ;
        headers[0] = AppHeaderModel(id: 10,image: 'https://files.viettelmaps.vn/images/pois_collection_app/banner.png',name: 'xin chào, \nMít tờ lép 11 ',link: '',isActive: '1');
        List<AppServiceModel> services  = List<AppServiceModel>(2) ;
        services[0] = AppServiceModel(id: 1,name: 'Quét mã',isActive: '1',icon: '/icons/icon_menu_bds.png',serviceType: 'PAHT');
        services[1] = AppServiceModel(id: 1,name: 'Báo giá',isActive: '1',icon: '/icons/icon_menu_bds.png',serviceType: 'PAHT');
        List<AppFooterModel> footers = List<AppFooterModel>(0) ;

        AppModuleModel result = AppModuleModel(headers: headers,services: services,footers: footers);

        return result;

    } catch (error) {
      print(error);
      return handleException(error);
    }
  }
}
