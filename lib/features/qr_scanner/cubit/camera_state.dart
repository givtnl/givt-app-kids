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
    organisation = const Organisation.empty(),
  }) : super(
          isLoading: isLoading,
          qrValue: qrValue,
          feedback: feedback,
        );
}

class CameraScanned extends CameraState {
  final String qrValue;
  const CameraScanned({
    required this.qrValue,
    isLoading = false,
    feedback = 'QR code scanned successfully!\nLoading data...',
  }) : super(
          isLoading: isLoading,
          qrValue: qrValue,
          feedback: feedback,
        );
}

class CameraError extends CameraState {
  final String feedback;
  const CameraError({
    required this.feedback,
    isLoading = false,
    qrValue = '',
  }) : super(
          isLoading: isLoading,
          qrValue: qrValue,
          feedback: feedback,
        );
}
