import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_display.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/pages/city_search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      home: const WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Weather? _weather;
  final WeatherModel _weatherModel = WeatherModel(); // Instance of WeatherModel

  void _fetchWeather(String cityName) async {
    if (cityName.isEmpty) {
      _showErrorDialog("Please enter a city name.");
      return;
    }

    try {
      final weather = await WeatherService(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      _showErrorDialog("City not found. Please check the spelling.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather('Tagaytay'); // Default city
  }

  String getWeatherAnimation(String mainCondition) {
    final description = mainCondition.toLowerCase();
    if (description.contains('rain') || description.contains('drizzle')) {
      return 'assets/rainy.json';
    } else if (description.contains('clouds')) {
      return 'assets/cloudy.json';
    } else if (description.contains('thunderstorm')) {
      return 'assets/thunder.json';
    } else if (description.contains('snow')) {
      return 'assets/snow.json';
    } else {
      return 'assets/sunny.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    String temperatureMessage = "";
    if (_weather != null) {
      temperatureMessage = _weatherModel.getMessage(_weather!.temperature.round());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        backgroundColor: Colors.white70,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),  // Icon for the search button
            onPressed: () async {
              // Navigate to the CitySearchPage
              final cityName = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CitySearchPage()),
              );

              if (cityName != null && cityName.isNotEmpty) {
                // Fetch weather for the selected city
                _fetchWeather(cityName);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.location_on),  // Icon for the reset button
            onPressed: () {
              // Reset to default city when pressed
              _fetchWeather('Dasmarinas');
            },
          ),
        ],
      ),
      backgroundColor: Colors.blueGrey,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  '${_weather?.temperature.round()}°C',
                  style: const TextStyle(fontSize: 60),
                ),
                Lottie.asset(getWeatherAnimation(
                    _weather?.mainCondition ?? "assets/sunny.json")),
                if (_weather != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      '$temperatureMessage in ${_weather?.cityName}',
                      style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
