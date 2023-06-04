import 'package:flutter/cupertino.dart';
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

  BitmapDescriptor customMarkerIcon(double statusPercentage) {
    if (statusPercentage <= 50) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    } else {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    setState(() {
      _markers.addAll([
        pointInfoMarker('Marker1'),
        Marker(
          markerId: MarkerId('marker2'),
          draggable: false,
          position: LatLng(38.395264, 27.0215591),
          icon: customMarkerIcon(100),
          onTap: () {
            showModalBottomSheet<void>(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text('Modal BottomSheet'),
                          ElevatedButton(
                            child: const Text('Close BottomSheet'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        // Marker(
        //   markerId: MarkerId('marker3'),
        //   draggable: false,
        //   position: LatLng(38.395264, 27.0215591),
        //   infoWindow: InfoWindow(
        //     title: 'Loc 1',
        //     snippet: 'demo loc 1',
        //   ),
        //   onTap: () {},
        // ),
      ]);
    });
  }

  Marker pointInfoMarker(String markerId) {
    return Marker(
      markerId: MarkerId(markerId),
      draggable: false,
      position: _center,
      icon: customMarkerIcon(40),
      onTap: () {
        showModalBottomSheet<void>(
          isScrollControlled: true,
          // constraints: BoxConstraints(
          //   maxWidth: MediaQuery.of(context).size.width - 40,
          // ),
          barrierColor: Colors.white.withOpacity(0),
          backgroundColor: Colors.white,
          context: context,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(25),
              child: SizedBox(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Icon(
                                  CupertinoIcons.battery_25_percent,
                                  size: 23,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Capacity',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(width: 15),
                                Text(
                                  '25%',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Icon(
                                  CupertinoIcons.location,
                                  size: 23,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Distance',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(width: 15),
                                Text(
                                  '160m',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Center(
                          child: Text('data'),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: FloatingActionButton(
                            onPressed: () {},
                            child: Text('Go to Location'),
                          ),
                        ),
                        SizedBox(width: 15),
                        FloatingActionButton(
                          onPressed: () {},
                          child: Icon(
                            CupertinoIcons.lock_open,
                          ),
                        ),
                        SizedBox(width: 15),
                        FloatingActionButton(
                          onPressed: () {},
                          child: Icon(
                            CupertinoIcons.info_circle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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
