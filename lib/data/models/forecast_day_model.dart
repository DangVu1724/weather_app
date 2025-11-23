class ForecastModel {
  final List<ForecastDayModel> forecastDay;

  ForecastModel({required this.forecastDay});

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      forecastDay: (json['forecastday'] as List)
          .map((e) => ForecastDayModel.fromJson(e))
          .toList(),
    );
  }
}

class ForecastDayModel {
  final String date;
  final int dateEpoch;
  final DayModel day;
  final AstroModel astro;
  final List<HourModel> hour;

  ForecastDayModel({
    required this.date,
    required this.dateEpoch,
    required this.day,
    required this.astro,
    required this.hour,
  });

  factory ForecastDayModel.fromJson(Map<String, dynamic> json) {
    return ForecastDayModel(
      date: json['date'],
      dateEpoch: json['date_epoch'],
      day: DayModel.fromJson(json['day']),
      astro: AstroModel.fromJson(json['astro']),
      hour: (json['hour'] as List)
          .map((e) => HourModel.fromJson(e))
          .toList(),
    );
  }
}

class AstroModel {
  final String sunrise;
  final String sunset;
  final String moonrise;
  final String moonset;
  final String moonPhase;

  AstroModel({
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonset,
    required this.moonPhase,
  });

  factory AstroModel.fromJson(Map<String, dynamic> json) {
    return AstroModel(
      sunrise: json['sunrise'] ?? "",
      sunset: json['sunset'] ?? "",
      moonrise: json['moonrise'] ?? "",
      moonset: json['moonset'] ?? "",
      moonPhase: json['moon_phase'] ?? "",
    );
  }
}

class DayModel {
  final double maxTempC;
  final double minTempC;
  final double avgTempC;
  final double maxWindKph;
  final int dailyChanceOfRain;
  final int dailyChanceOfSnow;
  final ConditionModel condition;

  DayModel({
    required this.maxTempC,
    required this.minTempC,
    required this.avgTempC,
    required this.maxWindKph,
    required this.dailyChanceOfRain,
    required this.dailyChanceOfSnow,
    required this.condition,
  });

  factory DayModel.fromJson(Map<String, dynamic> json) {
    return DayModel(
      maxTempC: (json['maxtemp_c'] as num).toDouble(),
      minTempC: (json['mintemp_c'] as num).toDouble(),
      avgTempC: (json['avgtemp_c'] as num).toDouble(),
      maxWindKph: (json['maxwind_kph'] as num).toDouble(),
      dailyChanceOfRain: json['daily_chance_of_rain'] ?? 0,
      dailyChanceOfSnow: json['daily_chance_of_snow'] ?? 0,
      condition: ConditionModel.fromJson(json['condition']),
    );
  }
}

class HourModel {
  final int timeEpoch;
  final String time;
  final double tempC;
  final double tempF;
  final int isDay;
  final ConditionModel condition;
  final double windMph;
  final double windKph;
  final int humidity;
  final int cloud;

  HourModel({
    required this.timeEpoch,
    required this.time,
    required this.tempC,
    required this.tempF,
    required this.isDay,
    required this.condition,
    required this.windMph,
    required this.windKph,
    required this.humidity,
    required this.cloud,
  });

  factory HourModel.fromJson(Map<String, dynamic> json) {
    return HourModel(
      timeEpoch: json['time_epoch'],
      time: json['time'],
      tempC: (json['temp_c'] as num).toDouble(),
      tempF: (json['temp_f'] as num).toDouble(),
      isDay: json['is_day'],
      condition: ConditionModel.fromJson(json['condition']),
      windMph: (json['wind_mph'] as num).toDouble(),
      windKph: (json['wind_kph'] as num).toDouble(),
      humidity: json['humidity'],
      cloud: json['cloud'],
    );
  }
}

class ConditionModel {
  final String text;
  final String icon;
  final int code;

  ConditionModel({required this.text, required this.icon, required this.code});

  factory ConditionModel.fromJson(Map<String, dynamic> json) {
    return ConditionModel(
      text: json['text'] ?? "",
      icon: json['icon'] ?? "",
      code: json['code'] ?? 0,
    );
  }
}

