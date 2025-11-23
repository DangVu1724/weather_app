import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/data/models/forecast_day_model.dart';
import 'package:weather_app/data/models/weather_model.dart';

class WeatherService {
  final String apiKey = dotenv.env['WEATHER_API_KEY'] ?? '';

  Future<WeatherResponse> fetchCurrentWeatherByCoords(double lat, double lon) async {
    final url = Uri.parse(
      'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$lat,$lon&aqi=no',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      // trả về WeatherResponse từ JSON
      return WeatherResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<ForecastModel> fetchForecastByCoords(double lat, double lon, int days) async {
    final url = Uri.parse(
      'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$lat,$lon&days=$days&aqi=no&alerts=no',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      // trả về ForecastModel từ JSON
      return ForecastModel.fromJson(json.decode(response.body)['forecast']);
    } else {
      throw Exception('Failed to load forecast data');
    }
  }
}
