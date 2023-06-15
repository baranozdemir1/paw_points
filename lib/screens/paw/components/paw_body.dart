import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:paw_points/components/paw_points_loader.dart';
import 'package:paw_points/components/location_report.dart';
import 'package:paw_points/components/qr_scanner.dart';
import 'package:paw_points/helpers/paw_points_helper.dart';

import '../../../size_config.dart';

class PawBody extends StatefulWidget {
  const PawBody({super.key});

  @override
  State<PawBody> createState() => _PawBodyState();
}

class _PawBodyState extends State<PawBody> {
  late GoogleMapController mapController;
  final List<Marker> _markers = [];

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  String getDistanceToTarget({
    required Position currentPosition,
    required LatLng targetPosition,
  }) {
    double distance = calculateDistance(
      currentPosition.latitude,
      currentPosition.longitude,
      targetPosition.latitude,
      targetPosition.longitude,
    );

    if (distance >= 1) {
      return '${distance.toStringAsFixed(2)} KM';
    } else {
      return '${(distance * 1000).toStringAsFixed(0)} M';
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const int earthRadius = 6371; // Dünya yarıçapı (km)
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  BitmapDescriptor customMarkerIcon(double statusPercentage) {
    if (statusPercentage >= 50) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    } else {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }
  }

  Marker pointInfoMarker({
    required String markerId,
    required LatLng position,
    required Position currentPosition,
    required String distance,
    required String capacity,
  }) {
    double capacityInt = double.parse(capacity.split('%')[0]);
    String pointKey = PawPointsHelper.generatePointKey();
    return Marker(
      markerId: MarkerId(markerId),
      draggable: false,
      position: position,
      icon: customMarkerIcon(capacityInt),
      onTap: () {
        showModalBottomSheet<void>(
          isScrollControlled: true,
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
                              children: [
                                Icon(
                                  CupertinoIcons.battery_25_percent,
                                  size: getProportionateScreenWidth(23),
                                ),
                                SizedBox(
                                    width: getProportionateScreenWidth(10)),
                                Text(
                                  'Capacity',
                                  style: TextStyle(
                                      fontSize:
                                          getProportionateScreenWidth(16)),
                                ),
                                SizedBox(
                                    width: getProportionateScreenWidth(15)),
                                Text(
                                  capacity,
                                  style: TextStyle(
                                      fontSize:
                                          getProportionateScreenWidth(16)),
                                ),
                              ],
                            ),
                            SizedBox(height: getProportionateScreenHeight(20)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  CupertinoIcons.location,
                                  size: getProportionateScreenWidth(23),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Distance',
                                  style: TextStyle(
                                      fontSize:
                                          getProportionateScreenWidth(16)),
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  distance,
                                  style: TextStyle(
                                      fontSize:
                                          getProportionateScreenWidth(16)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/catdog.svg',
                              height: getProportionateScreenWidth(40),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              pointKey,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                fontSize: getProportionateScreenWidth(16),
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: FloatingActionButton(
                            heroTag: '${markerId}goToLocation',
                            onPressed: () {
                              PawPointsHelper.launchMapApp(
                                position.latitude,
                                position.longitude,
                                markerId,
                              );
                              Navigator.pop(context);
                            },
                            child: const Text('Go to Location'),
                          ),
                        ),
                        const SizedBox(width: 15),
                        FloatingActionButton(
                          heroTag: '${markerId}openQRScanner',
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
                                      child: QRScanner(
                                        onDetect: (p0) => onDetect(
                                          p0,
                                          pointKey,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                          child: ValueListenableBuilder(
                            valueListenable: isUnlocked,
                            builder: (context, state, child) {
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
                          heroTag: '${markerId}openReportPage',
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const LocationReport(),
                              settings: RouteSettings(
                                arguments: ReportArguments(
                                  markerId,
                                  latitude: position.latitude,
                                  longitude: position.longitude,
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

  // QR -- BEGIN
  ValueNotifier<bool> isUnlocked = ValueNotifier(false);

  void onDetect(BarcodeCapture capture, String key) {
    Barcode barcode = capture.barcodes.first;
    isUnlocked.value = true;
    print('QR: ${barcode.displayValue}');
    print('KEY: $key');

    if (barcode.displayValue == key) {
      HapticFeedback.vibrate();
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(
                    "Unlocking...",
                    style: TextStyle(fontSize: getProportionateScreenWidth(16)),
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
    } else {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: EdgeInsets.all(getProportionateScreenWidth(30)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CupertinoIcons.xmark_circle_fill,
                    color: Colors.red,
                    size: getProportionateScreenWidth(50),
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Text(
                    "Wrong QR Code!",
                    style: TextStyle(fontSize: getProportionateScreenWidth(16)),
                  ),
                ],
              ),
            ),
          );
        },
      );
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pop(context);
      });
    }
  }
  // QR -- END

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
      future: _determinePosition(),
      builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
        print(snapshot.data);
        if (snapshot.hasData) {
          final Position position = snapshot.data!;
          final CameraPosition initialPosition = CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 13,
          );

          return Stack(
            children: [
              GoogleMap(
                compassEnabled: false,
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                mapType: MapType.normal,
                onMapCreated: (controller) {
                  mapController = controller;

                  setState(() {
                    _markers.addAll([
                      pointInfoMarker(
                        markerId: 'Marker1',
                        position: const LatLng(38.3877972, 27.0240068),
                        currentPosition: position,
                        distance: getDistanceToTarget(
                          currentPosition: position,
                          targetPosition: const LatLng(38.3877972, 27.0240068),
                        ),
                        capacity: '25%',
                      ),
                      pointInfoMarker(
                        markerId: 'marker2',
                        position: const LatLng(38.395264, 27.0215591),
                        currentPosition: position,
                        distance: getDistanceToTarget(
                          currentPosition: position,
                          targetPosition: const LatLng(38.395264, 27.0215591),
                        ),
                        capacity: '50%',
                      ),
                      pointInfoMarker(
                        markerId: 'suratkargo',
                        position: const LatLng(38.3897402, 27.0563414),
                        currentPosition: position,
                        distance: getDistanceToTarget(
                          currentPosition: position,
                          targetPosition: const LatLng(38.3897402, 27.0563414),
                        ),
                        capacity: '40%',
                      ),
                    ]);
                  });
                },
                markers: Set.from(_markers),
                mapToolbarEnabled: false,
                initialCameraPosition: initialPosition,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 25, bottom: 40),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        heroTag: 'myLocation',
                        onPressed: () async {
                          // Latitude: 38.39018200016435, Longitude: 27.056567563460472

                          mapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                  position.latitude,
                                  position.longitude,
                                ),
                                zoom: 14,
                              ),
                            ),
                          );
                        },
                        child: const Icon(Icons.my_location),
                      ),
                      const SizedBox(height: 10),
                      FloatingActionButton(
                        heroTag: 'zoomIn',
                        onPressed: () => mapController.animateCamera(
                          CameraUpdate.zoomIn(),
                        ),
                        child: const Icon(CupertinoIcons.add),
                      ),
                      const SizedBox(height: 10),
                      FloatingActionButton(
                        heroTag: 'zoomOut',
                        onPressed: () => mapController.animateCamera(
                          CameraUpdate.zoomOut(),
                        ),
                        child: const Icon(CupertinoIcons.minus),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return const PawPointsLoader();
        }
      },
    );
  }
}
