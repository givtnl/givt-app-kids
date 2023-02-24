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

  static Future<void> tryVibratePattern({
    List<int> pattern = const [
      50,
      100,
      150,
      400,
    ],
  }) async {
    var hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.cancel();
      Vibration.vibrate(pattern: pattern);
    }
  }
}
