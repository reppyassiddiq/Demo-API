import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = "18eb9c6bd8930f9247ffd6dad18014ce"; // Ganti dengan API Key-mu
  final String baseUrl = "https://api.openweathermap.org/data/2.5/weather";

  Future<Map<String, dynamic>> getWeather(String city) async {
    final url = Uri.parse("$baseUrl?q=$city&appid=$apiKey&units=metric");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch weather data");
    }
  }
}
