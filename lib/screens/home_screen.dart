import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/weather_api.dart'; // Correctly imports weather_api.dart
import '../widgets/search_bar.dart';
import '../widgets/weather_card.dart';
import '../widgets/error_message.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // Use WeatherService, not WeatherApi
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? _weatherData;
  List<dynamic>? _forecastData;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDarkMode = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _loadLastCity();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCity = prefs.getString('last_city');

    // Try to load cached data first
    final cachedWeather = prefs.getString('cached_weather');
    if (cachedWeather != null) {
      setState(() {
        _weatherData = json.decode(cachedWeather);
      });
      // Optionally fetch forecast too if cached
    }

    // Fetch fresh data for the last city
    _fetchWeather(lastCity ?? 'London');
  }

  Future<void> _saveCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_city', city);
  }

  Future<void> _cacheData(Map<String, dynamic> weather) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cached_weather', json.encode(weather));
  }

  Future<void> _fetchWeather(String city) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // FIX 1: Use WeatherService()
      final weather = await _weatherService.getCurrentWeather(city);
      final forecast = await _weatherService.getFiveDayForecast(city);

      setState(() {
        _weatherData = weather;
        _forecastData = forecast;
        _isLoading = false;
      });

      await _saveCity(city);
      await _cacheData(weather); // Cache the new data
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1. Check and request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permission is permanently denied');
      }

      // 2. Get the user's current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 3. Fetch weather using coordinates
      final weather = await _weatherService.getWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );

      // 4. Use the city name from the weather data to fetch the forecast
      final String cityName = weather['name'];
      final forecast = await _weatherService.getFiveDayForecast(cityName);

      // 5. Update the UI state
      setState(() {
        _weatherData = weather;
        _forecastData = forecast;
        _isLoading = false;
      });

      // 6. Save the new city to preferences
      await _saveCity(cityName);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  String _getBackgroundImage() {
    if (_weatherData == null) {
      return 'assets/image/sunny.jpg'; // default background
    }
    final condition = _weatherData!['weather'][0]['main']
        .toString()
        .toLowerCase();

    // (Your existing background logic is fine)
    if (condition.contains('cloud')) {
      return 'assets/image/cloudy.jpg';
    } else if (condition.contains('rain')) {
      return 'assets/image/rain.jpg';
    } else if (condition.contains('snow')) {
      return 'assets/image/snow.jpg';
    } else if (condition.contains('thunder')) {
      return 'assets/image/thunder.jpg';
    } else {
      return 'assets/image/clear.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    // FIX 4: Use a variable for the background image path
    final backgroundImagePath = _getBackgroundImage();

    return Scaffold(
      body: AnimatedSwitcher(
        // FIX 4: AnimatedSwitcher for background
        duration: const Duration(milliseconds: 1000),
        child: Container(
          // FIX 4: Use a Key to tell the AnimatedSwitcher the child has changed
          key: ValueKey<String>(backgroundImagePath),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundImagePath),
              fit: BoxFit.cover,
              colorFilter: _isDarkMode
                  // FIX 3: Use .withAlpha()
                  ? ColorFilter.mode(
                      Colors.black.withAlpha(137),
                      BlendMode.darken,
                    )
                  : null,
            ),
          ),
          child: Container(
            color: Colors.black.withAlpha(
              77,
            ), // .withAlpha(77) is like .withOpacity(0.3)
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.my_location,
                            color: Colors.white,
                          ),
                          onPressed: _getCurrentLocation,
                        ),
                        IconButton(
                          icon: Icon(
                            _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isDarkMode = !_isDarkMode;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  CustomSearchBar(onSearch: _fetchWeather),

                  const SizedBox(height: 20),

                  Expanded(
                    // FIX 4: Added RefreshIndicator
                    child: RefreshIndicator(
                      onRefresh: () =>
                          _fetchWeather(_weatherData?['name'] ?? 'London'),
                      child: _isLoading
                          ? Center(
                              // ... (Your loading animation)
                            )
                          : _errorMessage != null
                          // FIX 2: Use Container for padding/decoration
                          ? Center(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  // FIX 3: Use .withAlpha()
                                  color: Colors.red.withAlpha(
                                    51,
                                  ), // like .withOpacity(0.2)
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.red.withAlpha(128),
                                  ),
                                ),
                                child: Text(
                                  _errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            )
                          : _weatherData != null
                          // Make the card scrollable
                          ? SingleChildScrollView(
                              child: WeatherCard(
                                currentWeather:
                                    _weatherData, // Fix: Renamed from weatherData
                                forecastData: _forecastData,
                                isDarkMode:
                                    _isDarkMode, // Fix: Add this required parameter
                              ),
                            )
                          : const Center(
                              child: Text(
                                'Search for a city',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
