import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:wasteapp/features/home/data/Services/firebase_services.dart';
import 'package:wasteapp/features/home/data/model/bins_model.dart';
import 'package:wasteapp/features/home/presentation/cubit/qr_scan/qr_scan_cubit.dart';
import 'package:wasteapp/routes/routes_extension.dart';

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
  late FirebaseServices firebaseServices;
  QRViewController? controller;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  List<Bin> lisBin = [];
  bool isDetected = false;

  @override
  void initState() {
    super.initState();
    firebaseServices = FirebaseServices();
    getBinData();
  }

  Future<void> getBinData() async {
    lisBin = await firebaseServices.fetchAllBins();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
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
                  onPressed: () => Navigator.pop(context),
                  shape: const CircleBorder(),
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.arrow_back, size: 24.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    final scanArea =
        (MediaQuery.of(context).size.width < 400 ||
                MediaQuery.of(context).size.height < 400)
            ? 150.0
            : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: (controller) {
        setState(() => this.controller = controller);
        controller.scannedDataStream.listen((scanData) {
          if (!isDetected) {
            context.read<QrScannerCubit>().updateScanResult(scanData);
          }
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
          if (controller != null) {
            await controller!.toggleFlash();
            setState(() {});
          }
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
          if (controller != null) {
            await controller!.flipCamera();
            setState(() {});
          }
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

  void openBinDetailView(String binCode) async {
    if (binCode.isEmpty || lisBin.isEmpty || isDetected) return;

    for (var bin in lisBin) {
      if (binCode == bin.reference) {
        isDetected = true;

        bool result = await firebaseServices.qrScanUpdate(binCode, bin);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result ? 'Bin accessed successfully.' : 'Please try again!',
            ),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {
                isDetected = false;
                if (result) context.popScreen();
              },
            ),
          ),
        );
        return;
      }
    }

    if (!isDetected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid QR Code, Please try again...')),
      );
    }
  }
}
