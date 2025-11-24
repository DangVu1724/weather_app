final Map<String, String> weatherVN = {
  "Sunny": "Nắng",
  "Clear": "Trời quang",
  "Partly cloudy": "Ít mây",
  "Cloudy": "Nhiều mây",
  "Overcast": "U ám",

  "Mist": "Sương mù nhẹ",
  "Fog": "Sương mù",
  "Freezing fog": "Sương mù băng giá",

  "Partly Cloudy": "Ít mây",
  "Patchy rain possible": "Có thể mưa rải rác",
  "Light rain": "Mưa nhẹ",
  "Moderate rain": "Mưa vừa",
  "Heavy rain": "Mưa to",
  "Moderate rain at times": "Mưa vừa từng lúc",
  "Heavy rain at times": "Mưa to từng lúc",
  "Rain": "Mưa",

  "Patchy light drizzle": "Mưa phùn nhẹ",
  "Light drizzle": "Mưa phùn",
  "Freezing drizzle": "Mưa phùn đóng băng",
  "Heavy freezing drizzle": "Mưa phùn đóng băng nặng",
  "Patchy freezing drizzle possible": "Có thể có mưa phùn đóng băng",

  "Patchy light rain": "Mưa nhẹ rải rác",
  "Patchy moderate rain": "Mưa vừa rải rác",
  "Patchy heavy rain": "Mưa to rải rác",
  "Patchy rain nearby": "Mưa rải rác gần đây",

  "Light freezing rain": "Mưa lạnh nhẹ",
  "Moderate or heavy freezing rain": "Mưa lạnh vừa hoặc nặng",

  "Patchy snow possible": "Có thể có tuyết rải rác",
  "Light snow": "Tuyết nhẹ",
  "Moderate snow": "Tuyết vừa",
  "Heavy snow": "Tuyết dày",
  "Patchy light snow": "Tuyết nhẹ rải rác",
  "Patchy moderate snow": "Tuyết vừa rải rác",
  "Patchy heavy snow": "Tuyết dày rải rác",

  "Blowing snow": "Gió tuyết",
  "Blizzard": "Bão tuyết",

  "Ice pellets": "Mưa đá nhỏ",
  "Light sleet": "Mưa tuyết nhẹ",
  "Moderate or heavy sleet": "Mưa tuyết vừa hoặc to",
  "Patchy sleet possible": "Có thể có mưa tuyết",

  "Light sleet showers": "Mưa tuyết nhẹ",
  "Moderate or heavy sleet showers": "Mưa tuyết vừa hoặc to",

  "Light snow showers": "Tuyết rào nhẹ",
  "Moderate or heavy snow showers": "Tuyết rào vừa hoặc to",

  "Light rain shower": "Mưa rào nhẹ",
  "Moderate or heavy rain shower": "Mưa rào vừa hoặc to",
  "Torrential rain shower": "Mưa rào rất to",

  "Light showers of ice pellets": "Mưa đá nhẹ",
  "Moderate or heavy showers of ice pellets": "Mưa đá vừa hoặc to",

  "Thundery outbreaks possible": "Có thể có giông",
  "Patchy light rain with thunder": "Mưa nhẹ kèm sấm sét",
  "Moderate or heavy rain with thunder": "Mưa vừa hoặc to kèm sấm sét",
  "Patchy light snow with thunder": "Tuyết nhẹ kèm sấm sét",
  "Moderate or heavy snow with thunder": "Tuyết vừa hoặc to kèm sấm sét",

  "Thunderstorm": "Giông bão",

  "Haze": "Mù khói",
  "Smoke": "Khói",
  "Dust": "Bụi",
};

String translateCondition(String text) {
  return weatherVN[text] ?? text; 
}
