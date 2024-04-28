const String MAP_API_WEB_KEY = "AIzaSyAoc2aHlUjskR9pu6b9QYCd5wk4WNiKA_I";
const double PER_METER_COORDINATE_FACTOR = 0.00001;
const String appVersion = "v0.0.32";

class ThemeValue {
  static const int light = 1;
  static const int dark = -1;
  static const int systemPreferred = 0;
}

double minLatitude(double latitude, int radius) {
  return latitude - (PER_METER_COORDINATE_FACTOR * radius);
}

double maxLatitude(double latitude, int radius) {
  return latitude + (PER_METER_COORDINATE_FACTOR * radius);
}

double minLongitude(double longitude, int radius) {
  return longitude - (PER_METER_COORDINATE_FACTOR * radius);
}

double maxLongitude(double longitude, int radius) {
  return longitude + (PER_METER_COORDINATE_FACTOR * radius);
}

const String channelId = 'Local ride';
const String channelName = 'Local ride';
const String channelDescription = 'This channel is used for Local ride notifications.';
const String notificationIcon = 'launcher';
const String notificationSound = 'notification';
/*

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    channelId, channelName,
    description: channelDescription,
    importance: Importance.high,
    enableLights: true,
    ledColor: Colors.red,
    enableVibration: true,
    showBadge: true,
    playSound: true,
    sound: RawResourceAndroidNotificationSound(notificationSound));

final FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
*/
