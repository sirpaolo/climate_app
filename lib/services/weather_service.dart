import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';

Future<Weather> WeatherService(String cityName) async {
  String apiKey = "e5128f18306a06ab29401c054bae9f27";
  final response = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric'));
  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    return Weather.getData(jsonDecode(response.body));
  } else {
    throw Exception("Failed to load weather data");
  }
}
