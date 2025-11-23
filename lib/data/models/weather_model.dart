
class WeatherResponse {
  final Location location;
  final Current current;

  WeatherResponse({
    required this.location,
    required this.current,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      location: Location.fromJson(json["location"]),
      current: Current.fromJson(json["current"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "current": current.toJson(),
      };
}

// -------------------- LOCATION --------------------
class Location {
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String tzId;
  final int localtimeEpoch;
  final String localtime;

  Location({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.tzId,
    required this.localtimeEpoch,
    required this.localtime,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        name: json["name"] ?? "",
        region: json["region"] ?? "",
        country: json["country"] ?? "",
        lat: (json["lat"] as num).toDouble(),
        lon: (json["lon"] as num).toDouble(),
        tzId: json["tz_id"] ?? "",
        localtimeEpoch: json["localtime_epoch"] ?? 0,
        localtime: json["localtime"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "region": region,
        "country": country,
        "lat": lat,
        "lon": lon,
        "tz_id": tzId,
        "localtime_epoch": localtimeEpoch,
        "localtime": localtime,
      };
}

// -------------------- CONDITION --------------------
class Condition {
  final String text;
  final String icon;
  final int code;

  Condition({
    required this.text,
    required this.icon,
    required this.code,
  });

  factory Condition.fromJson(Map<String, dynamic> json) => Condition(
        text: json["text"] ?? "",
        icon: json["icon"] ?? "",
        code: json["code"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "icon": icon,
        "code": code,
      };
}

// -------------------- CURRENT WEATHER --------------------
class Current {
  final int lastUpdatedEpoch;
  final String lastUpdated;
  final double tempC;
  final double tempF;
  final int isDay;
  final Condition condition;
  final double windMph;
  final double windKph;
  final int windDegree;
  final String windDir;
  final double pressureMb;
  final double pressureIn;
  final double precipMm;
  final double precipIn;
  final int humidity;
  final int cloud;
  final double feelslikeC;
  final double feelslikeF;
  final double windchillC;
  final double windchillF;
  final double heatindexC;
  final double heatindexF;
  final double dewpointC;
  final double dewpointF;
  final double visKm;
  final double visMiles;
  final double uv;
  final double gustMph;
  final double gustKph;

  Current({
    required this.lastUpdatedEpoch,
    required this.lastUpdated,
    required this.tempC,
    required this.tempF,
    required this.isDay,
    required this.condition,
    required this.windMph,
    required this.windKph,
    required this.windDegree,
    required this.windDir,
    required this.pressureMb,
    required this.pressureIn,
    required this.precipMm,
    required this.precipIn,
    required this.humidity,
    required this.cloud,
    required this.feelslikeC,
    required this.feelslikeF,
    required this.windchillC,
    required this.windchillF,
    required this.heatindexC,
    required this.heatindexF,
    required this.dewpointC,
    required this.dewpointF,
    required this.visKm,
    required this.visMiles,
    required this.uv,
    required this.gustMph,
    required this.gustKph,
  });

  factory Current.fromJson(Map<String, dynamic> json) => Current(
        lastUpdatedEpoch: json["last_updated_epoch"] ?? 0,
        lastUpdated: json["last_updated"] ?? "",
        tempC: (json["temp_c"] as num).toDouble(),
        tempF: (json["temp_f"] as num).toDouble(),
        isDay: json["is_day"] ?? 0,
        condition: Condition.fromJson(json["condition"]),
        windMph: (json["wind_mph"] as num).toDouble(),
        windKph: (json["wind_kph"] as num).toDouble(),
        windDegree: json["wind_degree"] ?? 0,
        windDir: json["wind_dir"] ?? "",
        pressureMb: (json["pressure_mb"] as num).toDouble(),
        pressureIn: (json["pressure_in"] as num).toDouble(),
        precipMm: (json["precip_mm"] as num).toDouble(),
        precipIn: (json["precip_in"] as num).toDouble(),
        humidity: json["humidity"] ?? 0,
        cloud: json["cloud"] ?? 0,
        feelslikeC: (json["feelslike_c"] as num).toDouble(),
        feelslikeF: (json["feelslike_f"] as num).toDouble(),
        windchillC: (json["windchill_c"] as num).toDouble(),
        windchillF: (json["windchill_f"] as num).toDouble(),
        heatindexC: (json["heatindex_c"] as num).toDouble(),
        heatindexF: (json["heatindex_f"] as num).toDouble(),
        dewpointC: (json["dewpoint_c"] as num).toDouble(),
        dewpointF: (json["dewpoint_f"] as num).toDouble(),
        visKm: (json["vis_km"] as num).toDouble(),
        visMiles: (json["vis_miles"] as num).toDouble(),
        uv: (json["uv"] as num).toDouble(),
        gustMph: (json["gust_mph"] as num).toDouble(),
        gustKph: (json["gust_kph"] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "last_updated_epoch": lastUpdatedEpoch,
        "last_updated": lastUpdated,
        "temp_c": tempC,
        "temp_f": tempF,
        "is_day": isDay,
        "condition": condition.toJson(),
        "wind_mph": windMph,
        "wind_kph": windKph,
        "wind_degree": windDegree,
        "wind_dir": windDir,
        "pressure_mb": pressureMb,
        "pressure_in": pressureIn,
        "precip_mm": precipMm,
        "precip_in": precipIn,
        "humidity": humidity,
        "cloud": cloud,
        "feelslike_c": feelslikeC,
        "feelslike_f": feelslikeF,
        "windchill_c": windchillC,
        "windchill_f": windchillF,
        "heatindex_c": heatindexC,
        "heatindex_f": heatindexF,
        "dewpoint_c": dewpointC,
        "dewpoint_f": dewpointF,
        "vis_km": visKm,
        "vis_miles": visMiles,
        "uv": uv,
        "gust_mph": gustMph,
        "gust_kph": gustKph,
      };
}
