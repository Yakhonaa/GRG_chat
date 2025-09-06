String getTime() {
  DateTime now = DateTime.now();
  int hour = now.hour;
  int minute = now.minute;
  String currentTime = '$hour:$minute';
  return currentTime;
}