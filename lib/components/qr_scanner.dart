import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:paw_points/components/qr_scan_overlay.dart';
import 'package:paw_points/components/qr_scanner_error_widget.dart';

class QRScanner extends StatelessWidget {
  const QRScanner({super.key, required this.onDetect});

  final void Function(BarcodeCapture) onDetect;

  @override
  Widget build(BuildContext context) {
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
                const SizedBox(height: 350),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      onPressed: () => cameraController.toggleTorch(),
                      child: ValueListenableBuilder(
                        valueListenable: cameraController.torchState,
                        builder: (context, state, child) {
                          switch (state) {
                            case TorchState.off:
                              return const Icon(
                                Icons.flash_off,
                                color: Colors.grey,
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
                      onPressed: () => cameraController.switchCamera(),
                      child: const Icon(CupertinoIcons.switch_camera),
                    ),
                    const SizedBox(width: 20),
                    FloatingActionButton(
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
