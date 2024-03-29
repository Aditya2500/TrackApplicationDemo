import 'package:trackapp/models/userModel.dart';

class ApiConfig {
  static int responseSuccess = 200;
  static const ALL = "ALL";
  static const serverURl = "http://13.235.186.224/";
  static const serverBaseUrl = serverURl + "";
  static const devices = serverBaseUrl + "devices";
  static const deviceLogByDeviceId = serverBaseUrl + "devices/deviceId/";

  static getHeader() async {
    User user = User();
    user.email = 'aadiaditya903@gmail.com';
    user.uid = '1153240720723219';
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer firebase:${user.email}:${user.uid}'
    };
  }
}