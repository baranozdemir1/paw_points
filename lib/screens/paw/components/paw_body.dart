import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PawBody extends StatefulWidget {
  const PawBody({super.key});

  @override
  State<PawBody> createState() => _PawBodyState();
}

class _PawBodyState extends State<PawBody> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(38.3877972, 27.0240068);

  final List<Marker> _markers = [];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    setState(() {
      _markers.addAll([
        Marker(
          markerId: MarkerId('marker1'),
          draggable: false,
          position: _center,
          onTap: () {},
        ),
        Marker(
          markerId: MarkerId('marker3'),
          draggable: false,
          position: LatLng(38.395264, 27.0215591),
          infoWindow: InfoWindow(
            title: 'Loc 1',
            snippet: 'demo loc 1',
          ),
          onTap: () {},
        ),
      ]);
    });
  }

  void _changeCameraPosition() {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          tilt: 10,
          zoom: 12,
          target: LatLng(10, 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      onMapCreated: _onMapCreated,
      markers: Set.from(_markers),
      mapToolbarEnabled: true,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 13,
      ),
    );
  }
}
