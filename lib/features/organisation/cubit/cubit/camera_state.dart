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
    isLoading = false,
    qrValue = '',
    feedback = 'No QR code scanned yet.',
  }) : super(isLoading: isLoading, qrValue: qrValue, feedback: feedback);
}

class CameraLoading extends CameraState {
  const CameraLoading({isLoading = true, qrValue = '', feedback = 'Loading...'})
      : super(isLoading: isLoading, qrValue: qrValue, feedback: feedback);
}

class CameraScanned extends CameraState {
  final String qrValue;
  const CameraScanned({required this.qrValue, isLoading = false})
      : super(isLoading: isLoading, qrValue: qrValue, feedback: 'Scanned!');
}
