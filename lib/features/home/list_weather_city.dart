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

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Cities'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initWeather, // Refresh toàn bộ danh sách
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (context, index) {
          final city = cities[index];
          final weather = weatherMap[city];

          return Container(
            height: 170,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.deepPurpleAccent, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          weather == null ? (isLoading ? 'Loading...' : 'Error') : '${weather.current.tempC.round()}°C',
                          style: const TextStyle(fontSize: 30, color: Color.fromARGB(179, 9, 7, 7)),
                        ),
                        SizedBox(height: 3),
                        Text(
                          '${weather?.current.feelslikeC.round()}°C',
                          style: const TextStyle(fontSize: 16, color: Color.fromARGB(179, 9, 7, 7)),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 80,
                      width: 80,
                      child: getWeatherAnimation(weather?.current.condition.text ?? 'unknown'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(city, style: const TextStyle(fontSize: 20, color: Colors.white)),
                    Text(
                      ', ${weather?.location.country ?? 'N/A'}',
                      style: const TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),

                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text( weather == null ? '...Loading' : translateCondition(weather.current.condition.text), style: const TextStyle(color: Colors.white70)),
                    Text('${weather?.current.humidity}% Độ ẩm', style: const TextStyle(color: Colors.white70)),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
