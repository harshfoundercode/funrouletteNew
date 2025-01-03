
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  static String getUserId() {
    return _prefs?.getString('userId') ?? '';
  }
  static void setUserId(String userId) {
    _prefs?.setString('userId', userId);
  }
  // Future<void> setUserId(String userId) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   print(userId);
  //   await prefs.setString("userId", userId);
  //   print(await prefs.setString("userId", userId));
  //   _userToken = userId;
  // }

  static void clearUserId() {
    _prefs?.remove('userId');
  }

  // Chips setting
  static void setChipsValue(int chip) {
    _prefs?.setInt('chipsValue', chip);
  }

  static int getChipsValue(){
    return _prefs?.getInt("chipsValue")??0;
  }

  static void clearChipsValue() {
    _prefs?.remove('chipsValue');
  }

  static void setLastResult(int resultValue) {
    _prefs?.setInt('lastResult', resultValue);
  }

  static int getLastResult(){
    return _prefs?.getInt("lastResult")??0;
  }

  static void clearLastResult() {
    _prefs?.remove('lastResult');
  }

// Timer settings
//   static DateTime getStartTime() {
//     final timestamp = _prefs.getInt('startTimestamp');
//     return timestamp != null
//         ? DateTime.fromMillisecondsSinceEpoch(timestamp)
//         : DateTime.now();
//   }
//
//   static void setStartTime(DateTime startTime) {
//     _prefs.setInt('startTimestamp', startTime.millisecondsSinceEpoch);
//   }
//
//   static int getRemainingSeconds() {
//     return _prefs.getInt('remainingSeconds') ?? 60;
//   }
//
//   static void setRemainingSeconds(int remainingSeconds) {
//     _prefs.setInt('remainingSeconds', remainingSeconds);
//   }
//
//   static bool getTimerIsActive() {
//     return _prefs.getBool('timerIsActive') ?? false;
//   }
//
//   static void setTimerIsActive(bool isActive) {
//     _prefs.setBool('timerIsActive', isActive);
//   }

}


