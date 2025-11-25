import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/data/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/utils/getTime.dart';
import 'package:weather_app/utils/weather_translate.dart';
import 'package:weather_app/widgets/info_widget.dart';

class ListWeatherCity extends ConsumerStatefulWidget {
  const ListWeatherCity({super.key});

  @override
  ConsumerState<ListWeatherCity> createState() => _ListWeatherCityState();
}

class _ListWeatherCityState extends ConsumerState<ListWeatherCity> {
  late String timeOfDay;
  Timer? timer;
  bool isLoading = true;

  // Danh sách 10 tỉnh/thành phố VN
  final List<String> cities = [
    'Ha Noi',
    'Ho Chi Minh',
    'Da Nang',
    'Hai Phong',
    'Can Tho',
    'Nha Trang',
    'Hue',
    'Vung Tau',
    'Quy Nhon',
    'Da Lat',
  ];

  // Map lưu dữ liệu thời tiết cho từng city
  final Map<String, WeatherResponse?> weatherMap = {};

  @override
  void initState() {
    super.initState();
    timeOfDay = getTimeofDay();
    _initWeather();

    timer = Timer.periodic(const Duration(minutes: 1), (_) {
      setState(() {
        timeOfDay = getTimeofDay();
      });
    });
  }

  Future<void> _initWeather() async {
    try {
      final weatherService = WeatherService();

      // Tạo list future
      List<Future<void>> futures = cities.map((city) async {
        final data = await weatherService.fetchCurrentWeatherByLocation(city);
        weatherMap[city] = data;
      }).toList();

      // Chạy tất cả cùng lúc
      await Future.wait(futures);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Lỗi khi lấy weather: $e');
    }
  }

  // Hàm tạo màu nền dựa trên thời tiết
  Color _getCardColor(String condition) {
    final conditionLower = condition.toLowerCase();
    if (conditionLower.contains('sunny') || conditionLower.contains('clear')) {
      return const Color(0xFFFEF5E6); // Màu cam nhạt
    } else if (conditionLower.contains('cloud') || conditionLower.contains('overcast')) {
      return const Color(0xFFF0F2F5); // Màu xám nhạt
    } else if (conditionLower.contains('rain') || conditionLower.contains('drizzle')) {
      return const Color(0xFFE8F4FD); // Màu xanh da trời nhạt
    } else if (conditionLower.contains('snow')) {
      return const Color(0xFFF0F8FF); // Màu xanh tuyết
    } else {
      return const Color(0xFFF5F5F7); // Màu mặc định (Apple-style)
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Thời tiết Việt Nam',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.blue),
            onPressed: _initWeather,
          ),
        ],
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: cities.length,
        itemBuilder: (context, index) {
          final city = cities[index];
          final weather = weatherMap[city];
          final condition = weather?.current.condition.text ?? 'unknown';
          
          return Container(
            height: 170,
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: _getCardColor(condition),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  // Xử lý khi nhấn vào thành phố
                },
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      // Phần thông tin bên trái
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _getCityName(city),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              weather?.location.country ?? 'Việt Nam',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (weather != null) ...[
                              Text(
                                translateCondition(condition),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.water_drop,
                                    size: 14,
                                    color: Colors.blue.withOpacity(0.7),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${weather.current.humidity}%',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      
                      // Phần nhiệt độ và icon thời tiết
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            weather == null 
                                ? (isLoading ? '...' : '--') 
                                : '${weather.current.tempC.round()}°',
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                            ),
                          ),
                          if (weather != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Cảm giác ${weather.current.feelslikeC.round()}°',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ],
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Icon thời tiết
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: getWeatherAnimation(condition),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getCityName(String englishName) {
    final Map<String, String> cityNames = {
      'Ha Noi': 'Hà Nội',
      'Ho Chi Minh': 'TP.Hồ Chí Minh',
      'Da Nang': 'Đà Nẵng',
      'Hai Phong': 'Hải Phòng',
      'Can Tho': 'Cần Thơ',
      'Nha Trang': 'Nha Trang',
      'Hue': 'Huế',
      'Vung Tau': 'Vũng Tàu',
      'Quy Nhon': 'Quy Nhơn',
      'Da Lat': 'Đà Lạt',
    };
    return cityNames[englishName] ?? englishName;
  }
}