import 'package:flutter/material.dart';

import 'package:weather_app_2/model/WeatherModel.dart';
import 'package:weather_app_2/service/api_service.dart';
import 'package:weather_app_2/ui/components/future_forecust_listitem.dart';
import 'package:weather_app_2/ui/components/hourly_weather_listitem.dart';
import 'package:weather_app_2/ui/components/todays_weather.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiService apiService = ApiService();
  final _textFieldController = TextEditingController();
  String searchText = "auto:ip";

  Future<String?> _showSearchBottomSheet(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, 
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Search Location",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _textFieldController,
                decoration: const InputDecoration(
                  hintText: "Search by city, Zip, lat, lang",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_textFieldController.text.isEmpty) return;
                      Navigator.pop(context, _textFieldController.text);
                    },
                    child: const Text("Ok"),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text("Weather App",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
            onPressed: () async {
              _textFieldController.clear();
              String? text = await _showSearchBottomSheet(context);
              if (text != null && text.isNotEmpty) {
                setState(() {
                  searchText = text;
                });
              }
            },
            icon: const Icon(Icons.search,color: Colors.white,),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                searchText = "auto:ip"; 
              });
            },
            icon: const Icon(Icons.my_location,color: Colors.white,),
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<WeatherModel>(
          future: apiService.getWeatherData(searchText),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              WeatherModel? weatherModel = snapshot.data;
              return SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    TodaysWeather(weatherModel: weatherModel),
                    const SizedBox(height: 10),
                    const Text(
                      "Weather by Hours",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                    const SizedBox(height: 10),

                    // Hourly weather
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          Hour? hour = weatherModel
                              ?.forecast
                              ?.forecastday?[0]
                              .hour?[index];
                          return HourlyWeatherListitem(hour: hour);
                        },
                        itemCount: weatherModel
                                ?.forecast
                                ?.forecastday?[0]
                                .hour
                                ?.length ??
                            0,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Next 7 days Weather",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                    const SizedBox(height: 10),

                    // Forecast for next 7 days
                    Expanded(
                      child: ListView.builder(
                        itemCount:
                            weatherModel?.forecast?.forecastday?.length ?? 0,
                        itemBuilder: (context, index) {
                          final forecastList =
                              weatherModel?.forecast?.forecastday;
                          if (forecastList == null) return const SizedBox.shrink();
                          Forecastday forecastday = forecastList[index];
                          return FutureForcastListItem(
                            forecastday: forecastday,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            if (snapshot.hasError) {
              return const Center(child: Text("Error has occurred", style: TextStyle(color: Colors.white)));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
