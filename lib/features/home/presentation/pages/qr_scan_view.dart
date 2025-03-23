import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:wasteapp/features/home/presentation/cubit/qr_scan/qr_scan_cubit.dart';

class QrScanView extends StatelessWidget {
  const QrScanView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QrScannerCubit(),
      child: const QrScanScreen(),
    );
  }
}

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(flex: 4, child: _buildQrView(context)),
              Expanded(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      BlocConsumer<QrScannerCubit, Barcode?>(
                        listener: (context, state) {
                          openBinDetailView(state?.code ?? "");
                        },
                        builder: (context, result) {
                          return Text(
                            result != null
                                ? 'Barcode Scan Completed !'
                                : 'Please scan the QR code on the bin',
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          _buildFlashToggleButton(),
                          _buildCameraFlipButton(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              SafeArea(child: SizedBox()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  shape: CircleBorder(),
                  backgroundColor: Colors.white,
                  child: Icon(Icons.arrow_back, size: 24.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea =
        (MediaQuery.of(context).size.width < 400 ||
                MediaQuery.of(context).size.height < 400)
            ? 150.0
            : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: (controller) {
        setState(() {
          this.controller = controller;
        });
        controller.scannedDataStream.listen((scanData) {
          context.read<QrScannerCubit>().updateScanResult(scanData);
        });
      },
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, p),
    );
  }

  Widget _buildFlashToggleButton() {
    return Container(
      margin: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: () async {
          await controller?.toggleFlash();
          setState(() {});
        },
        child: FutureBuilder(
          future: controller?.getFlashStatus(),
          builder: (context, snapshot) {
            return Icon(
              !(snapshot.data ?? false) ? Icons.flash_on : Icons.flash_off,
            );
          },
        ),
      ),
    );
  }

  Widget _buildCameraFlipButton() {
    return Container(
      margin: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: () async {
          await controller?.flipCamera();
          setState(() {});
        },
        child: FutureBuilder(
          future: controller?.getCameraInfo(),
          builder: (context, snapshot) {
            return Text(
              snapshot.data != null
                  ? 'Camera facing ${describeEnum(snapshot.data!)}'
                  : 'loading',
            );
          },
        ),
      ),
    );
  }

  void _onPermissionSet(BuildContext context, bool permissionGranted) {
    if (!permissionGranted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No Permission')));
    }
  }

  void openBinDetailView(String binCode) {
    if (binCode.isNotEmpty) {
      // TODO: navigate to detail view.
    } else {
      // TODO: Show snack bar.
    }
  }
}
