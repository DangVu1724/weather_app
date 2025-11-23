import 'package:flutter/material.dart';

class WeatherBackground extends StatelessWidget {
  final String time; // morning/noon/evening/night
  final Widget child;

  const WeatherBackground({super.key, required this.time, required this.child});

  @override
  Widget build(BuildContext context) {
    final gradient = _getGradient(time);

    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      child: child,
    );
  }

  /// Hàm chọn gradient theo thời gian
  LinearGradient _getGradient(String time) {
    const morningGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFf6d365),
        Color(0xFFfda085),
      ],
    );

    const noonGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF70e1f5),
        Color(0xFFffd194),
      ],
    );

    const eveningGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFf83600),
        Color(0xFFfe8c00),
      ],
    );

    const nightGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF141e30),
        Color(0xFF243b55),
      ],
    );

    return {
      "morning": morningGradient,
      "noon": noonGradient,
      "evening": eveningGradient,
      "night": nightGradient,
    }[time]!;
  }
}
