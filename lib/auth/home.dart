import 'package:flutter/material.dart';
import 'package:flutter21/startexam.dart';
import 'package:flutter21/study_goal/certification.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../mypage/study_stats.dart';
import '../review.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const storage = FlutterSecureStorage();
  dynamic userName = '';
  var userImage;
  var userPoint;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPoint();
    });
  }

  Future<void> fetchPoint() async {
    var userId = await storage.read(key: 'idToken');
    final url = Uri.parse('http://192.168.219.77:3080/profile/user-profile/${userId}');
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = jsonDecode(response.body);
        setState(() {
          userName = decodedData['user_name'];
          userImage = decodedData['user_image'];
          userPoint = decodedData['user_point'];
        });
      } else {
        throw Exception('점수를 가져오는 데 실패했습니다.');
      }
    } catch (e) {
      print('에러 발생: $e');
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (userImage != null)
                      ClipOval(
                        child: Image.network(
                          Uri.encodeFull(userImage!),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Text('이미지를 불러올 수 없습니다.'),
                        ),
                      ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('${userPoint.toString()} 포인트'),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,  // 아이콘과 텍스트 간 간격을 고르게 설정
                      children: [
                        // 첫 번째 아이콘과 텍스트
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Startexam(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.mark_chat_read_outlined),
                              iconSize: 40, // 아이콘 크기 키우기
                              padding: const EdgeInsets.all(0), // 아이콘 간격 기본
                              color: Colors.black,
                            ),
                            const Text(
                              '배치고사',
                              style: TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        // 두 번째 아이콘과 텍스트
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WrongAnswersPage(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.rate_review_outlined),
                              iconSize: 40, // 아이콘 크기 키우기
                              padding: const EdgeInsets.all(0), // 아이콘 간격 기본
                              color: Colors.black,
                            ),
                            const Text(
                              '오답정리',
                              style: TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 40),
            Expanded(
              child: LearningStatsScreen(), // 학습 통계 화면을 바로 표시
            ),
          ],
        ),
      ),
    );
  }
}
