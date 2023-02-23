import 'package:vibration/vibration.dart';

class Vibrator {
  Vibrator._();

  static Future<void> tryVibrate({
    Duration duration = const Duration(milliseconds: 500),
  }) async {
    var hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.cancel();
      Vibration.vibrate(duration: duration.inMilliseconds);
    }
  }
}
