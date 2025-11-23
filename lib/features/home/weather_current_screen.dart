import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:weather_app/data/models/forecast_day_model.dart';
import 'package:weather_app/data/models/weather_model.dart';
import 'package:weather_app/services/location_service.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/utils/getTime.dart';
import 'package:weather_app/widgets/info_widget.dart';
import 'package:weather_app/widgets/weatherBackground.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String timeOfDay;
  Timer? timer;
  bool isLoading = true;
  WeatherResponse? weather;
  ForecastModel? forecast;

  @override
  void initState() {
    super.initState();
    timeOfDay = getTimeofDay();
    _initWeather();
    _fetchForecastToday();

    timer = Timer.periodic(const Duration(minutes: 1), (_) {
      setState(() {
        timeOfDay = getTimeofDay();
      });
    });
  }

  Future<void> _initWeather() async {
    try {
      final position = await LocationService.requestLocationPermission();
      final weatherService = WeatherService();
      final weatherData = await weatherService.fetchCurrentWeatherByCoords(position.latitude, position.longitude);

      setState(() {
        weather = weatherData;
        isLoading = false;
      });
    } catch (e) {
      print('Lỗi khi lấy vị trí hoặc weather: $e');
    }
  }

  Future<void> _fetchForecastToday() async {
    try {
      final position = await LocationService.requestLocationPermission();
      final weatherService = WeatherService();
      final forecastData = await weatherService.fetchForecastByCoords(position.latitude, position.longitude, 7);

      setState(() {
        forecast = forecastData;
      });
    } catch (e) {
      print('Lỗi khi lấy dự báo thời tiết: $e');
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WeatherBackground(
      time: timeOfDay,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: isLoading ? _buildLoadingScreen() : _buildWeatherScreen(),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
          const SizedBox(height: 20),
          Text('Đang tải dữ liệu thời tiết...', style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.8))),
        ],
      ),
    );
  }

  Widget _buildWeatherScreen() {
    return Stack(
      children: [
        // Header với thông tin chính
        Positioned(
          top: MediaQuery.of(context).padding.top + 20,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                // Vị trí và thời gian
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            weather!.location.name,
                            style: const TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [Shadow(color: Colors.black45, blurRadius: 8)],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatDateTime(weather!.location.localtime),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                              shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(getWeatherIcon(weather!.current.condition.text), color: Colors.white, size: 32),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Nhiệt độ chính
                Text(
                  '${weather!.current.tempC.round()}°',
                  style: const TextStyle(
                    fontSize: 96,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    shadows: [Shadow(color: Colors.black45, blurRadius: 12)],
                  ),
                ),
                const SizedBox(height: 8),

                // Mô tả thời tiết
                Text(
                  weather!.current.condition.text,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                    shadows: [Shadow(color: Colors.black45, blurRadius: 6)],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),

                // Cảm giác như
                Text(
                  'Cảm giác như ${weather!.current.feelslikeC.round()}°',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
                    shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom sheet với thông tin chi tiết
        DraggableScrollableSheet(
          initialChildSize: 0.4, // Tăng kích thước ban đầu để chứa forecast
          minChildSize: 0.4,
          maxChildSize: 0.8,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, spreadRadius: 2)],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                child: BackdropFilter(
                  filter: ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.darken),
                  child: ListView(
                    controller: scrollController,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Icon(Icons.drag_handle, color: Colors.white70, size: 32),
                        ),
                      ),

                      // Dự báo theo giờ
                      if (forecast != null && forecast!.forecastDay.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'Dự báo theo ngày',
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 140, // Chiều cao cố định cho horizontal list
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _getDayForecastCount(),
                            itemBuilder: (context, index) {
                              final day = forecast!.forecastDay[index];
                              return Container(
                                width: 80,
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      formatToVietnameseWeekday(DateTime.parse(day.date)),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Icon(getWeatherIcon(day.day.condition.icon), color: Colors.white, size: 28),
                                    Text(
                                      '${day.day.maxTempC.round()}°',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'Dự báo trong 24h',
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 140, // Chiều cao cố định cho horizontal list
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _getHourlyForecastCount(),
                            itemBuilder: (context, index) {
                              final hour = forecast!.forecastDay[0].hour[index * 3];
                              return Container(
                                width: 80,
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      formatHour(hour.time),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Icon(getWeatherIcon(hour.condition.text), color: Colors.white, size: 28),
                                    Text(
                                      '${hour.tempC.round()}°',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Chi tiết thời tiết',
                          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Grid với các thông số chính
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 1.8,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          children: [
                            _buildDetailCard(Icons.water_drop, 'Độ ẩm', '${weather!.current.humidity}%', Colors.blue),
                            _buildDetailCard(Icons.air, 'Gió', '${weather!.current.windKph} km/h', Colors.green),
                            _buildDetailCard(
                              Icons.speed,
                              'Áp suất',
                              '${weather!.current.pressureMb} mb',
                              Colors.orange,
                            ),
                            _buildDetailCard(
                              Icons.visibility,
                              'Tầm nhìn',
                              '${weather!.current.visKm} km',
                              Colors.purple,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Thông tin bổ sung
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildAdditionalInfo('UV', '${weather!.current.uv}'),
                              _buildAdditionalInfo('Lượng mưa', '${weather!.current.precipMm}mm'),
                              _buildAdditionalInfo('Mây', '${weather!.current.cloud}%'),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDetailCard(IconData icon, String title, String value, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.7))),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(title, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7))),
      ],
    );
  }

  int _getHourlyForecastCount() {
    if (forecast == null || forecast!.forecastDay.isEmpty || forecast!.forecastDay[0].hour.isEmpty) {
      return 0;
    }

    final totalHours = forecast!.forecastDay[0].hour.length;
    return (totalHours / 3).ceil().clamp(0, 8);
  }

  int _getDayForecastCount() {
    if (forecast == null || forecast!.forecastDay.isEmpty) {
      return 0;
    }
    final totalDays = forecast!.forecastDay.length;
    return totalDays.clamp(0, 7);
  }

  String formatToVietnameseWeekday(DateTime date) {
    final weekdays = ["Chủ nhật", "Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7"];
    return weekdays[date.weekday % 7];
  }
}
