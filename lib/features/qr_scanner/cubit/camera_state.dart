part of 'camera_cubit.dart';

abstract class CameraState extends Equatable {
  const CameraState({
    required this.isLoading,
    required this.qrValue,
    required this.feedback,
  });
  final bool isLoading;
  final String qrValue;
  final String feedback;

  @override
  List<Object> get props => [isLoading, qrValue, feedback];
}

class CameraInitial extends CameraState {
  const CameraInitial({
    super.isLoading = false,
    super.qrValue = '',
    super.feedback = 'No QR code scanned yet.',
  });
}

class CameraScanned extends CameraState {
  const CameraScanned({
    required super.qrValue,
    super.isLoading = false,
    super.feedback = 'QR code scanned successfully!\nLoading data...',
  });
}

class CameraError extends CameraState {
  const CameraError({
    required super.feedback,
    super.isLoading = false,
    super.qrValue = '',
  });
}
