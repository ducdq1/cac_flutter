//API
import 'package:shared_preferences/shared_preferences.dart';

import '../../injection_container.dart';

const String baseUserUrl = 'https://ioc.viettelmaps.com.vn:8080/uaa/v1';
const String urlVTMap = 'https://api.viettelmaps.vn/';
// const String iocUrl = 'https://scp.viettelmaps.com.vn:8080/adapter-ioc';
const String iocUrl = 'https://ioc.viettelmaps.com.vn:8080/adapter-ioc';

//const String vtmaps_baseUrl = 'https://api.viettelmaps.vn/gateway';
//const String baseSSOUrl = 'https://sso.viettelmaps.vn/auth/realms/vts-mientrung/protocol/openid-connect/token';
const String vtmaps_baseUrl = 'https://api.viettelmaps.com.vn:8080/gateway';
const String baseSSOUrl = 'https://sso.viettelmaps.com.vn:8080/auth/realms/vts-mientrung/protocol/openid-connect/token';


final pref = singleton<SharedPreferences>();

final String baseUrl = pref.getString('IP_SERVER') == null || pref.getString('IP_SERVER').isEmpty ? 'http://117.2.164.156/' : pref.getString('IP_SERVER');
final String appName = pref.getString('APPLICATION_NAME')  == null || pref.getString('APPLICATION_NAME').isEmpty ? 'kt' : pref.getString('APPLICATION_NAME');
// const String baseUrl = 'http://192.168.1.20/';
// final String baseUrl_api = baseUrl+'ketoan/rest/product';
final String baseUrl_api = baseUrl +  appName  + '/rest/product';
final String base_cus_url_api = baseUrl +  appName  + '/rest';

bool isCustomerUser(){
 return pref.getBool('isCustomer') ?? true;
}

String getUserName() {
 return pref.getString("userName");
}
//const String baseUrl = 'http://10.60.155.31:9605';
// const String baseUrl = 'http://10.60.158.90:9002';
