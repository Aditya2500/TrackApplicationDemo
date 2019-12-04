import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trackapp/models/deviceModel.dart';
import 'package:trackapp/models/logsModel.dart';
import 'package:trackapp/services/getDeviceLogs.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:trackapp/services/session.dart';


class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _date = new TextEditingController();
  final TextEditingController _fromTime = new TextEditingController();
  final TextEditingController _toTime = new TextEditingController();
  final Set<Polyline> _polyline = {};
  static const LatLng _center = const LatLng(33.738045, 73.084488);
  final Set<Marker> _markers = {};
  final format = DateFormat("yyyy-MM-dd");
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(28.6139, 77.2090),
    zoom: 2.0,
  );
  LatLng _lastMapPosition = _center;
  List<LatLng> latlng;
 Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;

    /**HERE "controller" Animate the CAMERA POSITION
    * to that particular lattitude & longitude value
    */
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 16,
      tilt: 50.0,
      bearing: 45.0,
    )));
  }

  getHistory() async{
     var date = _date.text?.split('-');
     var from = _fromTime.text?.split(':');
     var to = _toTime.text?.split(':');
   var fromDate =   DateTime.utc(int.parse(date[0] ==''?'':date[0]),int.parse(date[0] ==''?'':date[1]),int.parse(date[0] ==''?'':date[2]),
     int.parse(from[0] ==''?'':from[0]),int.parse(from[0] ==''?'':from[1]));
     var toDate =   DateTime.utc(int.parse(date[0] ==''?'':date[0]),int.parse(date[0] ==''?'':date[1]),int.parse(date[0] ==''?'':date[2]),
     int.parse(to[0] ==''?'':to[0]),int.parse(to[0] ==''?'':to[1]));

    await Session.setString('deviceId','027022310239');
    await Session.setString('fromTime', fromDate.toString());
    await Session.setString('toTime', toDate.toString());
    await getDeviceLogs();
  }


  @override
  Widget build(BuildContext context) {  
    latlng = List<LatLng>();
    return Scaffold(       
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          actions: <Widget>[
            Expanded(
              flex: 1,
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: DateTimeField(
                    controller: _date,
                    onChanged: (value){
                     getHistory();
                    },
                    format: format,
                   readOnly: true,
                   autocorrect: true,
                   enableInteractiveSelection: true,
                   showCursor: true,
                    decoration: InputDecoration(
                    
                      hintText: 'Date',
                    ),
                    onShowPicker: (context, currentValue) async {
                      final DateTime dateTime = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                      return dateTime;
                    },
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: DateTimeField(
                    controller: _fromTime,
                     onChanged: (value){
                      getHistory();
                    },
                    format: DateFormat("HH:mm"),
                     readOnly: true,
                   autocorrect: true,
                   enableInteractiveSelection: true,
                   showCursor: true,
                    decoration: InputDecoration(
                      hintText: 'From',
                    ),
                    onShowPicker: (context, currentValue) async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now()),
                      );
                      return DateTimeField.convert(time);
                    },
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: DateTimeField(
                    controller: _toTime,
                     onChanged: (value){
                      getHistory();
                    },
                    format: DateFormat("HH:mm"),
                     readOnly: true,
                   autocorrect: true,
                   enableInteractiveSelection: true,
                   showCursor: true,
                    decoration: InputDecoration(
                      hintText: 'To',
                    ),
                    onShowPicker: (context, currentValue) async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now()),
                      );
                      return DateTimeField.convert(time);
                    },
                  ),
                ),
              ),
            ],
          ),
            )
          ],
        ),
        body: Container(
         child: StreamBuilder<double>(
          //initialData: mapHeight,
          //stream: containerBloc.op,
          builder: (context, snapshot) {
        return Stack(
          children: <Widget>[            
            Container(
              height: snapshot.data,
              child: StreamBuilder<DeviceLogs>(
                  stream: getDeviceLogs().asStream(),
                  builder: (context, snapshot) {
                    List<ItemLogs> list = List();
                    Set<Marker> deviceMarkers = Set<Marker>();
                    if (snapshot.hasData) {
                      list.addAll(snapshot.data.items);
                      list.forEach((item) {
                        ItemLogs i = item ?? null;
                        LastLog ll = i == null ? null : i.log;
                        GpsData gd = ll == null ? null : ll.gpsData;
                        double lat = gd == null ? null : gd.lat;
                        double lng = gd == null ? null : gd.lon;
                        if (lat != null && lng != null) {
                          latlng.add(LatLng(lat, lng));
                        }
                      });
                      _polyline.add(Polyline(
                          polylineId: PolylineId(_lastMapPosition.toString()),
                          visible: true,
                          points: latlng,
                          color: Colors.red[300],
                          jointType: JointType.mitered,
                          endCap: Cap.roundCap,
                          geodesic: true));
                    }
                    if(list.length >0){
                     _gotoLocation(list[0].log.gpsData.lat,list[0].log.gpsData.lon);
                    }
                    return GoogleMap(
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      polylines: _polyline,
                      myLocationButtonEnabled: true,
                      
                      initialCameraPosition: CameraPosition(
                        target: LatLng(22.5726, 88.3639),
                        zoom: 9,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    );
                    
                  }),
            ),
          ],
        );
      })
        ),
      );
        
  }
}
