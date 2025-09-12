import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_2/model/WeatherModel.dart';

class FutureForcastListItem extends StatelessWidget {
  final Forecastday? forecastday;

  const FutureForcastListItem({super.key, required this.forecastday});

  @override
  Widget build(BuildContext context) {
    
    String dateText = "";
    try {
      if (forecastday?.date != null && forecastday!.date!.isNotEmpty) {
        dateText = DateFormat.MMMEd().format(DateTime.parse(forecastday!.date!));
      }
    } catch (e) {
      dateText = "Unknown Date";
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.all(8),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Weather Icon
          Image.network(
            "https:${forecastday?.day?.condition?.icon ?? ""}",
            height: 40,
            width: 40,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.image_not_supported, color: Colors.white),
          ),

          // Date
          Expanded(
            flex: 2,
            child: Text(
              dateText,
              style: const TextStyle(color: Colors.white),
            ),
          ),

          // Weather Condition
          Expanded(
            flex: 3,
            child: Text(
              forecastday?.day?.condition?.text ?? "",
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Max / Min Temp
          Expanded(
            child: Text(
              "${forecastday?.day?.maxtempC?.round() ?? '-'}°/"
              "${forecastday?.day?.mintempC?.round() ?? '-'}°",
              style: const TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
