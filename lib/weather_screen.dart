import 'package:flutter/material.dart';
import 'weather_icon.dart';

class WeatherScreen extends StatelessWidget {
  final dynamic weatherData;
  final DateTime selectedDate;

  WeatherScreen({Key? key, required this.weatherData, required this.selectedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dailyData = weatherData['daily'];
    var date = dailyData['time'][0];
    var weatherCode = dailyData['weathercode'][0] ?? 'データなし';
    var maxTemp = dailyData['temperature_2m_max'][0]?.toStringAsFixed(1) ?? 'データなし';
    var minTemp = dailyData['temperature_2m_min'][0]?.toStringAsFixed(1) ?? 'データなし';
    var precipitation = dailyData['precipitation_sum'][0]?.toStringAsFixed(1) ?? 'データなし';

    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('日付: $date', style: TextStyle(fontSize: 18)),
            WeatherIcon(weatherCode),
            SizedBox(height: 8), // アイコンと説明の間のスペース
            Text(
                '天気: ${getWeatherDescription(weatherCode)}',
                style: TextStyle(fontSize: 18),
            ),
            Text('最高気温: $maxTemp°C', style: TextStyle(fontSize: 18)),
            Text('最低気温: $minTemp°C', style: TextStyle(fontSize: 18)),
            Text('降水量: $precipitation mm', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  String getWeatherDescription(int weatherCode) {
  switch (weatherCode) {
    case 0: return '晴れ';
    case 1: return 'ほぼ晴れ';
    case 2: return '部分的に曇り';
    case 3: return '曇り';
    case 4: return '霧';
    case 5: return '霧雨';
    case 10: return '薄い霧';
    case 20: return '霧雨';
    case 21: return '小雨';
    case 22: return '大雨';
    case 23: return '霙';
    case 30: return '小雪';
    case 31: return '雪';
    case 32: return '大雪';
    case 40: return '霧';
    case 41: return '霧雨';
    case 42: return '大雨';
    case 43: return '霙';
    case 50: return '小雪';
    case 51: return '雪';
    case 52: return '大雪';
    case 60: return '雨';
    case 61: return '小雨';
    case 62: return '大雨';
    case 63: return '霙';
    case 70: return '小雪';
    case 71: return '雪';
    case 72: return '大雪';
    case 73: return '猛吹雪';
    case 80: return 'にわか雨';
    case 81: return 'にわか雪';
    case 82: return '雷雨';
    case 83: return '強いにわか雨';
    case 84: return '強いにわか雪';
    case 85: return '軽い霙';
    case 86: return '強い霙';
    case 95: return '雷雨';
    case 96: return '雷雨(強雨)';
    case 99: return '雷雨(強雨と雹)';
    default: return '不明';
  }
}

}
