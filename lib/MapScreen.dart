import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}
class _MapScreenState extends State<MapScreen> {
  GoogleMapController iniController;
  Location _location= Location();

  BitmapDescriptor customIcon;
  Set<Marker> markers;
  double _lat, _lon ;

  @override
  void initState() {
    super.initState();
    markers = Set.from([]);
    setCustomMapPin();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: LatLng(52.5350521, 13.3880011), zoom: 10),
        mapType: MapType.normal,
        onMapCreated: _onMapCreated,
        markers: markers,
        mapToolbarEnabled: false,
      ),
    );
  }
  void _onMapCreated (GoogleMapController googleMapController) async{
    iniController = googleMapController;
    if (await Permission.location.request().isGranted) {
      _location.onLocationChanged.listen((event) {
        _lat = event.latitude;
        _lon = event.longitude;
        iniController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(event.latitude, event.longitude), zoom: 16),
          ),
        );
        markMyLocation();
      });
    } else if (await Permission.location.isPermanentlyDenied) {
      openAppSettings();
    }
  }
  void markMyLocation () => setState(() => markers.add(Marker(markerId: MarkerId('0'), icon: customIcon, position: LatLng(_lat, _lon), onTap: openDialog, infoWindow: InfoWindow(title: "Coordinates: [$_lat, $_lon]",),)));
  void setCustomMapPin() async => customIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5), 'assets/pin.png');
  void openDialog() => createAlertDialog(context).then((value) => print("Name: $value, Current Coordinates : $_lat, $_lon"));

  Future<String> createAlertDialog(BuildContext context) {
    TextEditingController customController = TextEditingController();
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("Current Coordinates : \n\n[$_lat, $_lon] \n\nWrite your name:"),
        content: TextField(
          controller: customController,
          decoration: InputDecoration(hintText: "your name"),
        ),
        actions: [
          MaterialButton(elevation: 5, onPressed: () => Navigator.of(context).pop(customController.text.toString()),
            child: Text("Send"),
          )
        ],
      );
    });
  }
}
