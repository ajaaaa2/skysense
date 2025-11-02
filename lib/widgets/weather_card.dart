import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart'; // Import Lottie

class WeatherCard extends StatelessWidget {
  final Map<String, dynamic>? currentWeather;
  final List<dynamic>? forecastData;
  final bool isDarkMode;

  const WeatherCard({
    super.key,
    required this.currentWeather,
    required this.forecastData,
    required this.isDarkMode,
  });

  // Helper to get Lottie animation path based on weather condition
  String _getLottieAnimationPath(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
      case 'clear sky':
        return 'assets/lottie_icons/suncloud.json';
      case 'clouds':
      case 'few clouds':
      case 'scattered clouds':
      case 'broken clouds':
        return 'assets/lottie_icons/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/lottie_icons/rainy.json';
      case 'thunderstorm':
        return 'assets/lottie_icons/wetherwind.json';
      case 'snow':
        return 'assets/lottie_icons/snowy.json';
      case 'mist':
      case 'fog':
      case 'haze':
        return 'assets/lottie_icons/thunder.json';
      default:
        return 'assets/lottie_icons/cloudy.json'; // Default to cloudy
    }
  }

  // Helper to get a regular Material icon for smaller display (e.g., hourly)
  IconData _getWeatherIconData(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
      case 'clear sky':
        return Icons.wb_sunny;
      case 'clouds':
      case 'few clouds':
      case 'scattered clouds':
      case 'broken clouds':
        return Icons.cloud;
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return Icons.water_drop;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      case 'mist':
      case 'fog':
      case 'haze':
        return Icons.blur_on;
      default:
        return Icons.cloud;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = isDarkMode ? Colors.grey[800] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final hintColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];

    if (currentWeather == null) {
      return Center(
        child: Text(
          'No weather data available.',
          style: TextStyle(color: textColor),
        ),
      );
    }

    // Extract relevant current weather data
    final String cityName = currentWeather!['name'] ?? 'N/A';
    final double currentTemp =
        currentWeather!['main']['temp']?.toDouble() ?? 0.0;
    final String weatherCondition =
        currentWeather!['weather'][0]['main'] ?? 'N/A';
    final String weatherDescription =
        currentWeather!['weather'][0]['description'] ?? 'N/A';
    final int humidity = currentWeather!['main']['humidity'] ?? 0;
    final double windSpeed =
        currentWeather!['wind']['speed']?.toDouble() ?? 0.0;

    // Filter forecast data for hourly (next 24 hours / 8 entries)
    final List<dynamic> hourlyForecast = forecastData != null
        ? forecastData!.take(8).toList()
        : [];

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      margin: const EdgeInsets.all(
        0,
      ), // Removed default margin to give more control in HomeScreen
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Date & City
            Text(
              DateFormat('EEEE, MMM d').format(DateTime.now()),
              style: TextStyle(fontSize: 16, color: hintColor),
            ),
            const SizedBox(height: 8),
            Text(
              cityName,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 24),

            // Main Weather Icon & Temperature
            SizedBox(
              height: 150, // Fixed height for Lottie animation
              width: 150,
              child: Lottie.asset(
                _getLottieAnimationPath(weatherCondition),
                fit: BoxFit.cover,
                repeat: true,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${currentTemp.round()}°C',
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              weatherDescription.replaceFirst(
                weatherDescription[0],
                weatherDescription[0].toUpperCase(),
              ),
              style: TextStyle(fontSize: 20, color: hintColor),
            ),
            const SizedBox(height: 24),

            // Wind & Humidity
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Icon(Icons.air, color: hintColor, size: 28),
                    const SizedBox(height: 4),
                    Text(
                      '${windSpeed.round()} m/s',
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                    Text(
                      'Wind',
                      style: TextStyle(fontSize: 14, color: hintColor),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.water_drop, color: hintColor, size: 28),
                    const SizedBox(height: 4),
                    Text(
                      '$humidity%',
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                    Text(
                      'Humidity',
                      style: TextStyle(fontSize: 14, color: hintColor),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Hourly Forecast Title
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hourly Forecast',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Hourly Forecast List
            SizedBox(
              height: 120, // Fixed height for the horizontal list
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: hourlyForecast.length,
                itemBuilder: (context, index) {
                  final item = hourlyForecast[index];
                  final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                    item['dt'] * 1000,
                  );
                  final String hour = DateFormat('ha').format(dateTime);
                  final String condition = item['weather'][0]['main'];
                  final double temp = item['main']['temp']?.toDouble() ?? 0.0;

                  return Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.grey[700]
                          : Colors
                                .grey[200], // Slightly different color for hourly
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          hour,
                          style: TextStyle(fontSize: 14, color: hintColor),
                        ),
                        const SizedBox(height: 8),
                        Icon(
                          _getWeatherIconData(
                            condition,
                          ), // Use regular icon for small display
                          color: textColor,
                          size: 30,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${temp.round()}°C',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Add a Daily Forecast here later as an enhancement
          ],
        ),
      ),
    );
  }
}
