import 'package:flutter/material.dart';

class CitySearchPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: const Text('Enter City'),
        backgroundColor: Colors.white70,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                filled: true,
                border: InputBorder.none,
                hintText: 'Enter city...',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final cityName = _controller.text;
                if (cityName.isNotEmpty) {
                  Navigator.pop(context, cityName); // Return the city name to the WeatherPage
                } else {
                  // Show error message if city name is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter a city name")),
                  );
                }
              },
              child: const Text('Get Weather'),
            ),
          ],
        ),
      ),
    );
  }
}
