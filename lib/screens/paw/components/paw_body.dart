import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:paw_points/components/location_report.dart';
import 'package:paw_points/components/qr_scanner.dart';
import 'package:paw_points/screens/home/home_screen.dart';

class PawBody extends StatefulWidget {
  const PawBody({super.key});

  @override
  State<PawBody> createState() => _PawBodyState();
}

class _PawBodyState extends State<PawBody> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(38.3877972, 27.0240068);
  final List<Marker> _markers = [];

  ValueNotifier<bool> isUnlocked = ValueNotifier(false);
  Barcode? barcode;

  BitmapDescriptor customMarkerIcon(double statusPercentage) {
    if (statusPercentage <= 50) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    } else {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }
  }

  void onDetect(BarcodeCapture capture) {
    Barcode barcode = capture.barcodes.first;
    isUnlocked.value = true;

    setState(() {
      barcode = barcode;
    });

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text(
                  "Unlocking...",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
      Navigator.pop(context);
    });
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
          // barrierColor: Colors.white.withOpacity(0),
          backgroundColor: Colors.white,
          context: context,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.only(
                top: 15,
                bottom: 30,
                left: 30,
                right: 30,
              ),
              child: SizedBox(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        150.0,
                        0.0,
                        150.0,
                        0.0,
                      ),
                      child: Container(
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
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
                            const SizedBox(height: 20),
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
                        const Center(
                          child: Text('data'),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: FloatingActionButton(
                            onPressed: () {},
                            child: const Text('Go to Location'),
                          ),
                        ),
                        const SizedBox(width: 15),
                        FloatingActionButton(
                          onPressed: () {
                            if (isUnlocked.value) {
                              return;
                            } else {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).padding.top,
                                    ),
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: QRScanner(onDetect: onDetect),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                          child: ValueListenableBuilder(
                            valueListenable: isUnlocked,
                            builder: (context, state, child) {
                              print(state);
                              if (state) {
                                return const Icon(CupertinoIcons.lock);
                              } else {
                                return const Icon(CupertinoIcons.lock_open);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 15),
                        FloatingActionButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const LocationReport(),
                              settings: RouteSettings(
                                arguments: ReportArguments(
                                  markerId,
                                  latitude: 35.0505,
                                  longitude: 27.0505,
                                ),
                              ),
                            ),
                          ),
                          child: const Icon(
                            Icons.report_gmailerrorred_outlined,
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
