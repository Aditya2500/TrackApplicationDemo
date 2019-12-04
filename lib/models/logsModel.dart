import 'package:trackapp/models/deviceModel.dart';

class DeviceLogs {
  List<ItemLogs> items;

  DeviceLogs({
    this.items,
  });

  factory DeviceLogs.fromJson(Map<String, dynamic> json) => DeviceLogs(
        items: List<ItemLogs>.from(json["logs"].map((x) => ItemLogs.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class ItemLogs {
  String id;
  LastLog log;
  String deviceId;
  DateTime timestamp;

  ItemLogs({
    this.id,
    this.log,
    this.deviceId,
    this.timestamp
  });

  factory ItemLogs.fromJson(Map<String, dynamic> json) => ItemLogs(
        id: json["_id"],
        log: LastLog.fromJson(json["log"]),        
        deviceId: json["deviceId"],
        timestamp: DateTime.parse(json["timestamp"])
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "log": log.toJson(),
        "deviceId": deviceId,
        "timestamp": timestamp
      };
}




