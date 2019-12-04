import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trackapp/models/apiModel/api_config.dart';
import 'package:trackapp/models/logsModel.dart';
import 'package:trackapp/services/session.dart';
//import 'package:trackapp/models/index.dart';

Future<DeviceLogs> getDeviceLogs() async {
  var deviceId =await Session.getString('deviceId');
  var fromTime =await Session.getString('fromTime');
  var toTime =await Session.getString('toTime');
  
  final response = await http.get(Uri.encodeFull(ApiConfig.deviceLogByDeviceId+'$deviceId/logs?from=$fromTime&to=$toTime'),
      headers: await  ApiConfig.getHeader());

  if (response.statusCode == 200 || response.statusCode == 201) {
    Map responseData = jsonDecode(response.body);
    print(response.body);
    print(responseData.length);
  }

  return DeviceLogs.fromJson(json.decode(response.body));
}

DeviceLogs deviceFromJson(String str) => DeviceLogs.fromJson(json.decode(str));

String deviceToJson(DeviceLogs data) => json.encode(data.toJson());
