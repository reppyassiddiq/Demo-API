import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'weather_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _cityController = TextEditingController();
  Map<String, dynamic>? _weatherData;
  String? _error;

  Future<void> _fetchWeather() async {
    final city = _cityController.text;
    if (city.isEmpty) return;

    try {
      final data = await _weatherService.getWeather(city);
      setState(() {
        _weatherData = data;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _weatherData = null;
      });
    }
  }

  String _getWeatherImage(double temp) {
    if (temp <= 25) {
      return 'assets/berawan.png';
    } else if (temp > 25 && temp <= 30) {
      return 'assets/deras.png';
    } else {
      return 'assets/terik.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Weather App",
          style: GoogleFonts.lato(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
      ),
      body: Container(
        color: Colors.blue.shade50,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Kotak Input
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        labelText: "Enter City",
                        labelStyle: TextStyle(color: Colors.blueAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search, color: Colors.blueAccent),
                          onPressed: _fetchWeather,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  if (_error != null)
                    Text(
                      _error!,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  if (_weatherData != null)
                    AnimatedOpacity(
                      opacity: _weatherData != null ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 500),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "${_weatherData!['name']}, ${_weatherData!['sys']['country']}",
                              style: GoogleFonts.lato(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            Image.asset(
                              _getWeatherImage(_weatherData!['main']['temp']),
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                            Text(
                              "${_weatherData!['main']['temp']}°C",
                              style: GoogleFonts.lato(
                                fontSize: 48,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _weatherData!['weather'][0]['description'],
                              style: GoogleFonts.lato(
                                fontSize: 20,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
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
