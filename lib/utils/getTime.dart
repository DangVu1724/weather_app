String getTimeofDay() {
  final hour = DateTime.now().hour;

  if (hour >= 5 && hour < 12) {
    return "morning";
  } else if (hour >= 12 && hour < 17) {
    return "noon";
  } else if (hour >= 17 && hour < 20) {
    return "evening";
  } else {
    return "night";
  }
}
