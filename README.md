🌦️ SkySense – Flutter Weather App

A beautifully designed, real-time weather app built using Flutter.
SkySense provides live weather updates, forecasts, and location-based data — all wrapped in a smooth, modern interface.

🚀 Features

✅ Current Weather: Displays temperature, humidity, wind speed, and conditions.
✅ 5-Day Forecast: Visual overview of upcoming weather trends.
✅ Search by City: Instantly check weather for any location worldwide.
✅ Auto Location Detection: Get weather data based on your current position.
✅ Dynamic Backgrounds: Weather-based images for clear, cloudy, rain, and snow.
✅ Dark Mode Toggle: Switch between light and dark themes.
✅ Last City Memory: Saves your last searched city using SharedPreferences.

🛠️ Tech Stack
Category	Technology
Framework	Flutter
Language	Dart
API	OpenWeatherMap API
State	Stateful Widgets
Storage	SharedPreferences
Location	Geolocator
Animation	AnimationController & Tween
Package Manager	pub.dev


⚙️ Installation

Clone this repository

git clone https://github.com/ajaaaa2/skysense.git
cd skysense


Install dependencies

flutter pub get


Add your OpenWeatherMap API key

Create a file /lib/service/weather_api.dart

Replace YOUR_API_KEY with your actual API key.

Run the app

flutter run

🧩 Folder Structure
lib/
│
├── main.dart
├── screens/
│   └── home_screen.dart
├── service/
│   └── weather_api.dart
├── widgets/
│   ├── weather_card.dart
│   ├── search_bar.dart
│   └── error_message.dart
└── assets/
    ├── images/
    │   ├── clear.jpg
    │   ├── cloudy.jpg
    │   ├── rain.jpg
    │   ├── snow.jpg
    │   └── thunderstorm.jpg

🌍 API Reference

Data fetched from OpenWeatherMap API

Example endpoint:

https://api.openweathermap.org/data/2.5/weather?q=London&appid=YOUR_API_KEY&units=metric

🧱 Build for Release

To build for Android:

flutter build appbundle --release


To build for iOS:

flutter build ios --release

🧑‍💻 Developer

Ajmal C
Flutter Developer • AI Automation Enthusiast
📍 Calicut, India

🔗 LinkedIn

🔗 GitHub

⭐ Show Some Love

If you like SkySense, please ⭐ star the repo — it helps support more awesome Flutter projects!
