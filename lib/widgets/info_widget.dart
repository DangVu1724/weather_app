import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

String formatDateTime(String localtime) {
  try {
    final dateTime = DateTime.parse(localtime);
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute • $day/$month/${dateTime.year}';
  } catch (e) {
    return localtime;
  }
}

String formatHour(String timeString) {
  try {
    final timeParts = timeString.split(' ');
    if (timeParts.length >= 2) {
      final time = timeParts[1];
      final hour = int.parse(time.split(':')[0]);
      return '${hour.toString().padLeft(2, '0')}:00';
    }
    return timeString;
  } catch (e) {
    return timeString;
  }
}

Widget getWeatherAnimation(String condition) {
  final c = condition.toLowerCase();

  if (c.contains("sunny") || c.contains("clear")) {
    return Lottie.asset('assets/animations/Weather-sunny.json');
  }

  if (c.contains("cloudy") || c.contains("overcast")) {
    return Lottie.asset('assets/animations/Weather-partly cloudy.json');
  }


  if (c.contains("drizzle") ||
      c.contains("light drizzle") ||
      c.contains("patchy light drizzle")) {
    return Lottie.asset('assets/animations/Weather-partly showe.json');
  }

  if (c.contains("patchy light rain") ||
      c.contains("light rain") ||
      c.contains("rain shower") ||
      c.contains("light rain shower")) {
    return Lottie.asset('assets/animations/Weather-partly showe.json');
  }

  if (c.contains("moderate rain") ||
      c.contains("heavy rain") ||
      c.contains("torrential rain")) {
    return Lottie.asset('assets/animations/Weather-storm.json');
  }

  
  if (c.contains("thunder") ||
      c.contains("storm") ||
      c.contains("rain with thunder")) {
    return Lottie.asset('assets/animations/Weather-thunder.json');  }

  if (c.contains("snow")) {
    return Lottie.asset('assets/animations/Weather-snow.json');
  }

  if (c.contains("fog") || c.contains("mist")) {
    return Lottie.asset('assets/animations/Foggy.json');
  }

  return Lottie.asset('assets/animations/Weather-sunny.json');
}

