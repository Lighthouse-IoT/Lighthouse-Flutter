import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class LearningStatsScreen extends StatefulWidget {
  const LearningStatsScreen({Key? key}) : super(key: key);

  @override
  State<LearningStatsScreen> createState() => _LearningStatsScreenState();
}

class _LearningStatsScreenState extends State<LearningStatsScreen> {
  String totalStudyTime = '00:00:00';
  String averageStudyTime = '00:00:00';
  String focusTime = '00:00:00';


  String convertMinutesToTimeFormat(int minutes) {
    final int hours = minutes ~/ 60;
    final int remainingMinutes = minutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}:00';
  }

  static const storage = FlutterSecureStorage();
  dynamic userInfo = '';

  var userId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchStudyInfo();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    }) ;
  }

  _asyncMethod() async {
    userInfo = await storage.read(key: 'idToken');

    if (userId != null) {
      setState(() {
        userId = userId;
      });
    } else {
      print('로그인이 필요합니다.');
    }
  }

  Future<void> fetchStudyInfo() async {
    final String url = 'http://192.168.219.77:3080/profile/study-info/${userId}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          totalStudyTime = convertMinutesToTimeFormat(data['totalStudyTime'] ?? 0);
          averageStudyTime = convertMinutesToTimeFormat(data['averageStudyTime'] ?? 0);
          focusTime = convertMinutesToTimeFormat(data['focusTime'] ?? 0);
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching study info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'E-ROOM',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '학습통계 확인',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              '최근 5일 공부통계',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildStatsRow('총 학습시간', totalStudyTime),
                  const SizedBox(height: 16),
                  _buildStatsRow('평균 학습시간', averageStudyTime),
                  const SizedBox(height: 16),
                  _buildStatsRow('순공시간', focusTime),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
