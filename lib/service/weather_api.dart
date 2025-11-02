import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String apiKey =
      '90a716d75205a84789afc3ba069806a0'; // Get from openweathermap.org
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Map<String, dynamic>> getCurrentWeather(String city) async {
    final url = '$baseUrl/weather?q=$city&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('City not found');
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> getWeatherByCoordinates(
    double lat,
    double lon,
  ) async {
    final url = '$baseUrl/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<dynamic>> getFiveDayForecast(String city) async {
    final url = '$baseUrl/forecast?q=$city&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['list'];
      } else {
        throw Exception('Failed to load forecast data');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
