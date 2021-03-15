class DatetimeConverter {
  static String timestampToLable(String timestamp) {
    final date = DateTime.parse(timestamp);
    return '${date.hour}:${date.minute}, ${date.day}/${date.month}/${date.year}';
  }
}
