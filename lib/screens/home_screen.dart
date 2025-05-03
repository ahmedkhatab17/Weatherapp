import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weather/screens/weekly_forecast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _WeatherHomePage2State();
}

class _WeatherHomePage2State extends State<HomeScreen> {
  String city = "Cairo";
  double temperature = 0.0;
  double minTemp = 0.0;
  double maxTemp = 0.0;
  String description = "";
  double lat = 0.0;
  double lon = 0.0;

  @override
  void initState() {
    super.initState();
    fetchWeather(city);
  }

  Future<void> fetchWeather(String cityName) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=86d9ee800e0e82e5c5221611e2d00981&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          temperature = data['main']['temp'];
          minTemp = data['main']['temp_min'];
          maxTemp = data['main']['temp_max'];
          description = data['weather'][0]['main'];
          city = data['name'];
          lat = data['coord']['lat'];
          lon = data['coord']['lon'];
        });
      } else {
        print("Failed to fetch weather");
      }
    } catch (e) {
      print("Error fetching weather: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1F0C4D), Color(0xFF693E99)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      TimeOfDay.now().format(context),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: const [
                        Icon(
                          Icons.signal_cellular_4_bar,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.wifi, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Icon(Icons.battery_full, color: Colors.white, size: 20),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Image.asset('assets/images/weather_header.png', height: 120),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(10),

                child: Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          city,
                          style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${temperature.round()}°',
                          style: const TextStyle(
                            fontSize: 35,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Max: ${maxTemp.round()}°   Min: ${minTemp.round()}°',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset('assets/images/house.png', height: 250),

                    Container(
                      height: 225,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3E2D8F), Color(0xFF693E99)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => WeatherApp(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Today",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),

                              Text(
                                "${_getMonthName(DateTime.now().month)} ${DateTime.now().day}, ${DateTime.now().year}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),

                          const Divider(color: Colors.white24, thickness: 1),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(4, (index) {
                              final time = DateTime.now().add(
                                Duration(hours: index + 1),
                              );
                              final formattedTime =
                                  "${time.hour.toString().padLeft(2, '0')}:00";

                              return CustomWeatherTile(
                                image: 'assets/images/weather_header.png',
                                temp: '${temperature.round()}°',
                                time: formattedTime,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap:
                                () => showModalBottomSheet(
                                  context: context,
                                  backgroundColor: const Color(0xFF3E2D8F),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(8),
                                    ),
                                  ),
                                  builder:
                                      (_) => LocationSelector(
                                        onCitySelected: (newCity) {
                                          Navigator.pop(context);
                                          fetchWeather(newCity);
                                        },
                                      ),
                                ),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: const Color(0xFF3E2D8F),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(8),
                                  ),
                                ),
                                builder: (context) {
                                  final TextEditingController cityController =
                                      TextEditingController();

                                  return Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Enter City Name',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: cityController,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: 'City Name',
                                            hintStyle: const TextStyle(
                                              color: Colors.white70,
                                            ),
                                            filled: true,
                                            fillColor: Colors.white24,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            String newCity =
                                                cityController.text.trim();
                                            if (newCity.isNotEmpty) {
                                              Navigator.pop(context);
                                              fetchWeather(newCity);
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.deepPurpleAccent,
                                          ),
                                          child: const Text(
                                            'Search',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Icon(
                              Icons.add_circle,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const WeatherApp(),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomWeatherTile extends StatelessWidget {
  final String image;
  final String temp;
  final String time;

  const CustomWeatherTile({
    super.key,
    required this.image,
    required this.temp,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(image, height: 28),
        const SizedBox(height: 5),
        Text(temp, style: const TextStyle(color: Colors.white, fontSize: 15)),
        const SizedBox(height: 5),
        Text(time, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}

class LocationSelector extends StatelessWidget {
  final void Function(String) onCitySelected;

  const LocationSelector({super.key, required this.onCitySelected});

  @override
  Widget build(BuildContext context) {
    final List<String> countries = [
      'Cairo',
      'Riyadh',
      'Dubai',
      'Kuwait',
      'Doha',
      'Manama',
      'Muscat',
      'Amman',
      'Beirut',
      'Casablanca',
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Choose Your City',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 250,
            child: ListView.separated(
              itemCount: countries.length,
              separatorBuilder: (_, __) => const Divider(color: Colors.white24),
              itemBuilder:
                  (context, index) => ListTile(
                    title: Text(
                      countries[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () => onCitySelected(countries[index]),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.48, // Increased width
      padding: const EdgeInsets.all(20), // Increased padding
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7B61FF), Color(0xFF8F71F3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20), // Adjusted border radius
        border: Border.all(
          color: Colors.white.withOpacity(0.3), // Border color
          width: 2, // Border width
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.white70,
                size: 20,
              ), // Increased icon size
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ), // Increased font size
              ),
            ],
          ),
          const SizedBox(height: 12), // Adjusted spacing
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ), // Increased font size
          ),
        ],
      ),
    );
  }
}

String _getMonthName(int month) {
  const List<String> monthNames = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  return monthNames[month - 1];
}
