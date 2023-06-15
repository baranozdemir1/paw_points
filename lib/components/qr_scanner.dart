import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:paw_points/components/qr_scan_overlay.dart';
import 'package:paw_points/components/qr_scanner_error_widget.dart';
import 'package:paw_points/size_config.dart';

class QRScanner extends StatelessWidget {
  const QRScanner({super.key, required this.onDetect});

  final void Function(BarcodeCapture) onDetect;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    MobileScannerController cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      detectionTimeoutMs: 1000,
      facing: CameraFacing.back,
      torchEnabled: false,
      formats: [BarcodeFormat.qrCode],
    );

    double scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 330.0;

    final scanWindow = Rect.fromCenter(
      center: MediaQuery.of(context).size.center(Offset.zero),
      width: scanArea,
      height: scanArea,
    );

    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            errorBuilder: (context, error, child) {
              return ScannerErrorWidget(error: error);
            },
            scanWindow: scanWindow,
            controller: cameraController,
            onDetect: onDetect,
          ),
          QRScannerOverlay(
            overlayColour: Colors.black.withOpacity(0.5),
            scanArea: scanArea,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(height: getProportionateScreenHeight(25)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      heroTag: 'writePointKey',
                      onPressed: () {
                        // write the key showdialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              titlePadding: const EdgeInsets.only(
                                top: 15,
                                left: 20,
                                bottom: 15,
                              ),
                              actionsPadding: const EdgeInsets.only(
                                right: 20,
                                bottom: 5,
                                top: 5,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              title: const Text('Write Key'),
                              content: const TextField(
                                maxLength: 4,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 15,
                                  ),
                                  hintText: 'Enter Key',
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Write'),
                                  onPressed: () {
                                    // write the key
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Icon(
                        Icons.abc,
                        size: getProportionateScreenWidth(35),
                      ),
                    ),
                    const SizedBox(width: 20),
                    FloatingActionButton(
                      heroTag: 'toggleTorch',
                      onPressed: () => cameraController.toggleTorch(),
                      child: ValueListenableBuilder(
                        valueListenable: cameraController.torchState,
                        builder: (context, state, child) {
                          switch (state) {
                            case TorchState.off:
                              return const Icon(
                                Icons.flash_off,
                              );
                            case TorchState.on:
                              return const Icon(
                                Icons.flash_on,
                                color: Colors.yellow,
                              );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    FloatingActionButton(
                      heroTag: 'closeScreen',
                      onPressed: () => Navigator.pop(context),
                      child: const Icon(CupertinoIcons.xmark),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
