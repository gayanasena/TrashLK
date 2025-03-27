import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

part 'qr_scan_state.dart';

// Cubit for QR Scanner
class QrScannerCubit extends Cubit<Barcode?> {
  QrScannerCubit() : super(null);

  void updateScanResult(Barcode result) {
    emit(result);
  }
}
