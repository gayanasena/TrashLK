part of 'qr_scan_cubit.dart';

sealed class QrScanState extends Equatable {
  const QrScanState();

  @override
  List<Object> get props => [];
}

final class QrScanInitial extends QrScanState {}

final class QrScanSuccess extends QrScanState {
  const QrScanSuccess();

  @override
  List<Object> get props => [];
}
