import 'package:flutter/material.dart';

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


  IconData getWeatherIcon(String condition) {
    final lowerCondition = condition.toLowerCase();
    if (lowerCondition.contains('sunny') || lowerCondition.contains('clear')) {
      return Icons.wb_sunny;
    } else if (lowerCondition.contains('cloud')) {
      return Icons.cloud;
    } else if (lowerCondition.contains('rain')) {
      return Icons.beach_access;
    } else if (lowerCondition.contains('storm')) {
      return Icons.flash_on;
    } else if (lowerCondition.contains('snow')) {
      return Icons.ac_unit;
    } else if (lowerCondition.contains('fog') || lowerCondition.contains('mist')) {
      return Icons.blur_on;
    } else {
      return Icons.wb_cloudy;
    }
  }