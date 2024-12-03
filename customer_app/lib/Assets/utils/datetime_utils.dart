bool _isShopOpen(DateTime now) {
  int hour = now.hour;
  int weekday = now.weekday;
  if ((weekday >= DateTime.monday && weekday <= DateTime.friday) &&
      (hour >= 9 && hour < 17)) return true;
  if ((weekday == DateTime.saturday || weekday == DateTime.sunday) &&
      (hour >= 9 && hour < 12)) return true;
  return false;
}

String formatDateTime(DateTime date) =>
    '${date.year}-${date.month}-${date.day}';
