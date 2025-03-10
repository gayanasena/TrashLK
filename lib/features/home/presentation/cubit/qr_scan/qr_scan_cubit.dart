import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'qr_scan_state.dart';

// Cubit for QR Scanner
class QrScannerCubit extends Cubit<QrScanState?> {
  QrScannerCubit() : super(null);

  void updateScanResult(QrScanState result) {
    emit(result);
  }
}
