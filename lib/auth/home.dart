import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  // 예시: 버튼 클릭 카운트 상태
  int _followCount = 0;

  static const storage = FlutterSecureStorage();
  dynamic userName = '';

  var userImage;
  var userPoint;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPoint();
    }) ;
  }

  _asyncMethod() async {
    userName = await storage.read(key: 'nameToken');

    if (userName != null) {
      setState(() {
        userName = userName;
      });
    } else {
      print('로그인이 필요합니다.');
    }
  }

  Future<int> fetchPoint() async {
    var userId = await storage.read(key: 'idToken');
    final url = Uri.parse('http://192.168.219.77:3080/profile/user-profile/${userId}');
    try {
      final response = await http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
      );

      // 응답 상태 코드 출력
      print('HTTP 상태 코드: ${response.statusCode}');
      // 서버에서 전달된 원본 데이터 출력
      print('서버 응답 데이터: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = jsonDecode(response.body);
        print('디코딩된 데이터: $decodedData');
        setState(() {
          userName = decodedData['user_name'];
          userImage = decodedData['user_image'];
          userPoint = decodedData['user_point'];
        });
        return decodedData['point'];
      } else {
        throw Exception('점수를 가져오는 데 실패했습니다. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('에러 발생: $e');
      throw Exception('네트워크 에러가 발생했습니다: $e');
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
            // 사용자 정보와 메뉴
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (userImage != null)
                    ClipOval(
                      child: Image.network(
                        Uri.encodeFull(userImage!),
                        width: 60, // 너비
                        height: 60, // 높이
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Text('이미지를 불러올 수 없습니다.'),// 이미지를 잘라서 맞춤
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${userPoint.toString()} 포인트'
                        ),
                        const SizedBox(height: 2),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _followCount++;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('팔로우'),
                        ),
                      ],
                    ),
                  ],
                ),
                // 메뉴 버튼 아래 "개인정보 수정" 추가
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        print("메뉴 버튼 클릭됨");
                      },
                      icon: const Icon(Icons.menu, color: Colors.black),
                    ),
                    const Text(
                      '개인정보 수정',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 100),

            // 탭 버튼 6개를 3줄로 배치
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMenuButton(
                          '학습통계 확인', Icons.bar_chart, Colors.lightBlueAccent),
                      _buildMenuButton(
                          '오답정리', Icons.edit, Colors.lightBlueAccent),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMenuButton(
                          '기출문제', Icons.grade, Colors.lightBlueAccent),
                      _buildMenuButton(
                          '공부시작', Icons.assignment, Colors.lightBlueAccent),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(String title, IconData icon, Color color) {
    return Container(
      width: 130,
      height: 90,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: Colors.black), // 아이콘 크기 조정
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
