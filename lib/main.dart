import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'weather_screen.dart'; // WeatherScreen クラスをインポート

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'あの日の天気',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MapController _mapController = MapController();
  DateTime _selectedDate = DateTime.now();

  LatLng _pinPosition = LatLng(35.6812362,139.7671248); // 初期ピンの位置（例：東京）

  void _updatePinPosition(LatLng position) {
    setState(() {
      _pinPosition = position;
    });
    _mapController.move(position, _mapController.zoom); // 地図のビューを更新
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime lastDate = DateTime(now.year, now.month, now.day - 1); // 昨日の日付
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: lastDate, // 初期選択日付
      firstDate: DateTime(1940),  // 選択可能な最初の日付
      lastDate: lastDate,         // 選択可能な最後の日付（昨日まで）
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }


  Future<void> _onGoButtonPressed(BuildContext context) async {
    // APIから天気情報を取得するロジック（省略）
    var response = await http.get(
      Uri.parse('https://archive-api.open-meteo.com/v1/archive'
          '?latitude=${_pinPosition.latitude}'
          '&longitude=${_pinPosition.longitude}'
          '&start_date=${DateFormat('yyyy-MM-dd').format(_selectedDate)}'
          '&end_date=${DateFormat('yyyy-MM-dd').format(_selectedDate)}'
          '&daily=weathercode,temperature_2m_max,temperature_2m_min,precipitation_sum'
      ),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherScreen(
            weatherData: data,
            selectedDate: _selectedDate,
          ),
        ),
      );
    } else {
      // エラー処理
      print('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('あの日の天気')),
      body: Column(
        children: [
          Padding( // ここにPaddingウィジェットを追加
          padding: const EdgeInsets.symmetric(vertical: 10.0), // 上下に10ピクセルの隙間
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text('Select Date'),
              ),
              Text(
                DateFormat.yMd().format(_selectedDate),
              ),
              ElevatedButton(
                onPressed: () => _onGoButtonPressed(context),
                child: Text('Go'),
              ),
            ],
          ),
          ),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: _pinPosition,
                zoom: 13.0,       // 初期のズームレベル
                minZoom: 5.0,     // 最小ズームレベル
                maxZoom: 18.0,    // 最大ズームレベル
                interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                onTap: (latLng) => _updatePinPosition(latLng),
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _pinPosition,
                      builder: (ctx) => Container(
                        child: Icon(Icons.location_pin, color: Colors.red, size: 40.0),
                      ),
                    ),
                  ],
                ),
              ],
              nonRotatedChildren: [
                  Positioned(
                    right: 10, // 右から10ピクセルの位置に配置
                    bottom: 70, // 下から50ピクセルの位置に配置
                    child: FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: () {
                        _mapController.move(_mapController.center, _mapController.zoom + 1);
                      },
                    ),
                  ),
                  Positioned(
                    right: 10, // 右から10ピクセルの位置に配置
                    bottom: 10, // 下から10ピクセルの位置に配置
                    child: FloatingActionButton(
                      child: Icon(Icons.remove),
                      onPressed: () {
                        _mapController.move(_mapController.center, _mapController.zoom - 1);
                      },
                    ),
                  ),
                ],
            ),
          ),
        ],
      ),
    );
  }
}
