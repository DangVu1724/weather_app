import 'package:flutter/material.dart';
import 'package:weather_app/services/grod_service.dart';

class ClothingSuggestionWidget extends StatefulWidget {
  final String cityName;
  final double temperatureC;
  final double feelingTemp;
  final String weatherCondition;
  final String timeOfDay;
  final int humidity;
  final int cloud;
  final double windSpeedKph;
  final double uv;

  const ClothingSuggestionWidget({
    super.key,
    required this.cityName,
    required this.temperatureC,
    required this.feelingTemp,
    required this.weatherCondition,
    required this.timeOfDay,
    required this.humidity,
    required this.cloud,
    required this.windSpeedKph,
    required this.uv,
  });

  @override
  State<ClothingSuggestionWidget> createState() => _ClothingSuggestionWidgetState();
}

class _ClothingSuggestionWidgetState extends State<ClothingSuggestionWidget> {
  late Future<String> suggestionFuture;

  @override
  void initState() {
    super.initState();
    suggestionFuture = getClothingSuggestionGroq(
      cityName: widget.cityName,
      temperatureC: widget.temperatureC,
      feelingTemp: widget.feelingTemp,
      weatherCondition: widget.weatherCondition,
      timeOfDay: widget.timeOfDay,
      humidity: widget.humidity,
      cloud: widget.cloud,
      windSpeedKph: widget.windSpeedKph,
      uv: widget.uv,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.white,
              Colors.lightBlue.shade50,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header với icon và title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.checkroom,
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'GỢI Ý TRANG PHỤC',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Content
              FutureBuilder<String>(
                future: suggestionFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingState();
                  } else if (snapshot.hasError) {
                    return _buildErrorState(snapshot.error.toString());
                  } else if (snapshot.hasData) {
                    return _buildSuccessState(snapshot.data!);
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          const SizedBox(height: 16),
          Text(
            'Đang phân tích thời tiết ${widget.cityName}...',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48,
          ),
          const SizedBox(height: 12),
          const Text(
            'Không thể tải gợi ý',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                suggestionFuture = getClothingSuggestionGroq(
                  cityName: widget.cityName,
                  temperatureC: widget.temperatureC,
                  feelingTemp: widget.feelingTemp,
                  weatherCondition: widget.weatherCondition,
                  timeOfDay: widget.timeOfDay,
                  humidity: widget.humidity,
                  cloud: widget.cloud,
                  windSpeedKph: widget.windSpeedKph,
                  uv: widget.uv,
                );
              });
            },
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Thử lại'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState(String content) {
    final lines = content.split('\n');
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge thành phố
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Text(
              widget.cityName,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Nội dung gợi ý
          Container(
            constraints: const BoxConstraints(
              minHeight: 80,
            ),
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: lines.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final line = lines[index].trim();
                if (line.isEmpty) return const SizedBox.shrink();
                
                // Chỉ tô đậm phần lưu ý đặc biệt
                bool isSpecialNote = line.toLowerCase().contains('lưu ý') || 
                                    line.toLowerCase().contains('đặc biệt') ||
                                    line.startsWith('2.');
                
                return Text(
                  line,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSpecialNote ? FontWeight.bold : FontWeight.normal,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Footer với thông tin thời gian
          Container(
            padding: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 6),
                Text(
                  'Cập nhật lúc ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}