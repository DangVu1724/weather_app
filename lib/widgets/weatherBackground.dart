import 'package:flutter/material.dart';

class WeatherBackground extends StatelessWidget {
  final String time; // morning/noon/evening/night
  final Widget child;

  const WeatherBackground({
    super.key,
    required this.time,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final image = _getBackgroundImage(time);

    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }

  /// Hàm lấy ảnh theo thời điểm
  String _getBackgroundImage(String time) {
    return {
      "morning": "assets/images/morning.png",
      "noon": "assets/images/noon.png",
      "evening": "assets/images/evening.png",
      "night": "assets/images/night.png",
    }[time]!;
  }
}
