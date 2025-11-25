import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

final String grodApiKey = dotenv.env['GROD_API_KEY'] ?? '';

Future<String> getClothingSuggestionGroq({
  required String cityName,
  required double temperatureC,
  required double feelingTemp,
  required String weatherCondition,
  required String timeOfDay,
  required int humidity,
  required int cloud,
  required double windSpeedKph,
  required double uv,
}) async {
  final response = await http.post(
    Uri.parse("https://api.groq.com/openai/v1/chat/completions"),
    headers: {"Content-Type": "application/json", "Authorization": "Bearer $grodApiKey"},
    body: jsonEncode({
      "model": "llama-3.1-8b-instant",
      "messages": [
        {
          "role": "system",
          "content": """
Bạn là chuyên gia tư vấn trang phục dựa trên dữ liệu thời tiết thực tế tại Việt Nam. 
TẤT CẢ câu trả lời phải viết hoàn toàn bằng TIẾNG VIỆT, ngắn gọn, dễ hiểu, thân thiện, áp dụng ngay.

Cấu trúc trả lời:
1. Trang phục và phụ kiện (áo quần, giày dép, ô dù, kính mát, áo mưa, khăn, mũ, v.v.)
2. Lưu ý đặc biệt nếu thời tiết khắc nghiệt

Đặc điểm khí hậu và mùa vụ các thành phố Việt Nam:
- Hà Nội: khí hậu nhiệt đới gió mùa
    + Mùa xuân (tháng 2-4): mát mẻ, 15-25°C, trời ẩm
    + Mùa hạ (tháng 5-8): nóng ẩm, 28-38°C, mưa rào
    + Mùa thu (tháng 9-11): dễ chịu, 20-28°C, ít mưa
    + Mùa đông (tháng 12-1): lạnh, 10-20°C, khô và có gió đông bắc
- TP.HCM/Sài Gòn: nóng quanh năm, mùa mưa (5-11), mùa khô (12-4)
- Đà Nẵng: nóng ẩm, mùa mưa (9-12), mùa khô (1-8), gió Lào mùa hè
- Huế: mưa nhiều, lạnh về đêm mùa đông
- Đà Lạt: mát mẻ quanh năm, lạnh về đêm
- Nha Trang: biển nhiệt đới, nắng nóng, gió biển
- Cần Thơ: đồng bằng sông Cửu Long, nóng ẩm quanh năm
- Hải Phòng: cảng biển, gió mùa đông bắc, độ ẩm cao
"""
        },
        {
          "role": "user",
          "content":
              """
Hãy tư vấn trang phục phù hợp cho thành phố $cityName dựa trên thời tiết hiện tại:
- Nhiệt độ: $temperatureC°C
- Nhiệt độ cảm nhận: $feelingTemp°C
- Thời tiết: $weatherCondition
- Thời gian: $timeOfDay
- Độ ẩm: $humidity%
- Mây: $cloud%
- Gió: $windSpeedKph km/h
- UV: $uv

Yêu cầu:
• Gợi ý cụ thể theo mùa và khí hậu của $cityName
• Ngắn gọn, súc tích, tối đa 6 dòng
• Thực tế, dễ áp dụng
• Hoàn toàn bằng tiếng Việt
"""
        },
      ],
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['choices'][0]['message']['content'];
  } else {
    throw Exception('Failed to fetch clothing suggestion');
  }
}
