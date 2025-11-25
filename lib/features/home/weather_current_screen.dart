import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:weather_app/data/models/forecast_day_model.dart';
import 'package:weather_app/data/models/weather_model.dart';
import 'package:weather_app/features/home/list_weather_city.dart';
import 'package:weather_app/services/grod_service.dart';
import 'package:weather_app/services/location_service.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/utils/getTime.dart';
import 'package:weather_app/utils/weather_translate.dart';
import 'package:weather_app/widgets/clothing_suggestion_widget.dart';
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
  double sheetHeight = 200; // <- state của bottom sheet
  late double minHeight;
  late double maxHeight;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    timeOfDay = getTimeofDay();
    _scrollController = ScrollController();
    _initWeather();
    _fetchForecastToday();

    final screenHeight =
        WidgetsBinding.instance.window.physicalSize.height / WidgetsBinding.instance.window.devicePixelRatio;

    minHeight = 200;
    maxHeight = screenHeight;
    sheetHeight = minHeight;
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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WeatherBackground(
      time: timeOfDay,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // Xử lý khi nhấn nút thêm;
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ListWeatherCity()));
              },
            ),
            SizedBox(width: 12),
            IconButton(
              onPressed: () {
                // Cài đặt
              },
              icon: Icon(Icons.settings),
            ),
          ],
        ),
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
        // === PHẦN HEADER (sẽ bị đẩy lên và mờ dần khi kéo) ===
        AnimatedOpacity(
          opacity: _getHeaderOpacity(),
          duration: const Duration(milliseconds: 300),
          child: Transform.translate(
            offset: Offset(0, -_getHeaderOffset()),
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 24, right: 24),
              child: Column(
                children: [
                  // Thành phố
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      weather!.location.name,
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black45, blurRadius: 10)],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Animation thời tiết
                  SizedBox(height: 180, child: getWeatherAnimation(weather!.current.condition.text)),
                  const SizedBox(height: 10),

                  // Nhiệt độ lớn
                  Text(
                    '${weather!.current.tempC.round()}°',
                    style: const TextStyle(
                      fontSize: 70,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      height: 0.9,
                      shadows: [Shadow(color: Colors.black45, blurRadius: 20)],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    weather == null ? '...Loading' : translateCondition(weather!.current.condition.text),
                    style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Cảm giác như ${weather!.current.feelslikeC.round()}°',
                    style: TextStyle(fontSize: 17, color: Colors.white.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
          ),
        ),

        DraggableScrollableSheet(
          initialChildSize: 0.42,
          minChildSize: 0.42,
          maxChildSize: 1.0,
          snap: true,
          snapSizes: const [0.42, 1.0],
          builder: (context, scrollController) {
            scrollController.addListener(() {
              setState(() {});
            });

            final double progress = (scrollController.hasClients)
                ? (scrollController.position.pixels / (MediaQuery.of(context).size.height * 0.58)).clamp(0.0, 1.0)
                : 0.0;

            return AnimatedBuilder(
              animation: scrollController,
              builder: (context, child) {
              
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08 + (0.07 * progress)),
                    borderRadius: BorderRadius.vertical(top: Radius.circular((1 - progress) * 32)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular((1 - progress) * 32)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20 + (progress * 10), sigmaY: 20 + (progress * 10)),
                      child: Container(
                        color: Colors.white.withOpacity(0.12 + (progress * 0.08)),
                        child: CustomScrollView(
                          controller: scrollController,
                          physics: const ClampingScrollPhysics(),
                          slivers: [
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  const SizedBox(height: 12),
                                  // Drag handle
                                  Center(
                                    child: Container(
                                      width: 48,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  _buildForecastSections(),
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
                                      childAspectRatio: 1.7,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      children: [
                                        _buildDetailCard(
                                          Icons.water_drop,
                                          'Độ ẩm',
                                          '${weather!.current.humidity}%',
                                          Colors.blue,
                                        ),
                                        _buildDetailCard(
                                          Icons.air,
                                          'Gió',
                                          '${weather!.current.windKph} km/h',
                                          Colors.green,
                                        ),
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
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24),
                                    child: ClothingSuggestionWidget(
                                      cityName: weather!.location.name,
                                      temperatureC: weather!.current.tempC,
                                      feelingTemp: weather!.current.feelslikeC,
                                      weatherCondition: weather!.current.condition.text,
                                      timeOfDay: timeOfDay,
                                      humidity: weather!.current.humidity,
                                      cloud: weather!.current.cloud,
                                      windSpeedKph: weather!.current.windKph,
                                      uv: weather!.current.uv,
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildForecastSections() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dự báo 7 ngày',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: forecast?.forecastDay.length ?? 0,
              itemBuilder: (context, i) {
                final day = forecast!.forecastDay[i];
                return Container(
                  width: 90,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        i == 0 ? 'Hôm nay' : formatToVietnameseWeekday(DateTime.parse(day.date)),
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      getWeatherAnimation(day.day.condition.text),
                      Text(
                        '${day.day.maxTempC.round()}°',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        '${day.day.minTempC.round()}°',
                        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Dự báo trong 24h',
            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: forecast != null ? (forecast!.forecastDay[0].hour.length / 2).ceil() : 0,
              itemBuilder: (context, index) {
                final hour = forecast!.forecastDay[0].hour[index * 2];
                return Container(
                  width: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatHour(hour.time),
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      getWeatherAnimation(hour.condition.text),
                      Text(
                        '${hour.tempC.round()}°',
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
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

  double _getHeaderOpacity() {
    if (!_scrollController.hasClients) return 1.0;
    final progress = (_scrollController.position.pixels / (MediaQuery.of(context).size.height * 0.58)).clamp(0.0, 1.0);
    return (1.0 - progress).clamp(0.0, 1.0);
  }

  double _getHeaderOffset() {
    if (!_scrollController.hasClients) return 0.0;
    final progress = (_scrollController.position.pixels / (MediaQuery.of(context).size.height * 0.58)).clamp(0.0, 1.0);
    return progress * 200;
  }

  String formatToVietnameseWeekday(DateTime date) {
    final weekdays = ["Chủ nhật", "Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7"];
    return weekdays[date.weekday % 7];
  }
}
