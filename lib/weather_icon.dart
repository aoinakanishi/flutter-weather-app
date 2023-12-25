// weather_icon.dart
import 'package:flutter/material.dart';

class WeatherIcon extends StatelessWidget {
  final int weatherCode;

  WeatherIcon(this.weatherCode);

  @override
  Widget build(BuildContext context) {
    String imageName;

    switch (weatherCode) {
      case 0: // 晴れ
        imageName = 'clear-sky.png';
        break;
      case 1: // 部分的に晴れ
      case 2: // 曇り時々晴れ
      case 3: // 曇り
        imageName = 'partly-cloudy.png';
        break;
      case 45: // 霧
      case 48: // 凍霧
        imageName = 'overcast.png';
        break;
      case 51: // 弱い霧雨
      case 53: // 霧雨
      case 55: // 強い霧雨
      case 56: // 凍霧雨
      case 57: // 強い凍霧雨
        imageName = 'light-rain.png';
        break;
      case 61: // 弱い雨
      case 63: // 雨
      case 65: // 強い雨
        imageName = 'rain.png';
        break;
      case 66: // 弱い凍雨
      case 67: // 強い凍雨
        imageName = 'heavy-rain.png';
        break;
      case 71: // 弱い雪
      case 73: // 雪
      case 75: // 強い雪
        imageName = 'snow.png';
        break;
      case 77: // 霰
      case 85: // 霙
      case 86: // 強い霙
        imageName = 'heavy-snow.png';
        break;
      case 95: // 雷雨
      case 96: // 弱い雷雨
      case 99: // 強い雷雨
        imageName = 'storm.png';
        break;
      default:
        imageName = 'blizzard.png'; // 未知または該当なしの場合
    }

    return Image.asset(
      'assets/images/$imageName',
      width: 50.0,  // 幅を50ピクセルに設定
      height: 50.0, // 高さを50ピクセルに設定
    );
  }
}

