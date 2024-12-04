import 'package:flutter/material.dart';
import 'package:flutter21/auth/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResultPage extends StatelessWidget {
  Future<int> fetchPoint() async {
    final url = Uri.parse('http://192.168.219.77:3080/exam/result');
    final data = {
      'userId': 'hello', // 전달받은 userId 사용
    };
    try {
      final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          }, body: jsonEncode(data)
      );


      // 응답 상태 코드 출력
      print('HTTP 상태 코드: ${response.statusCode}');
      // 서버에서 전달된 원본 데이터 출력
      print('서버 응답 데이터: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = jsonDecode(response.body);
        print('디코딩된 데이터: $decodedData');
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
      appBar: AppBar(title: const Text("User Points")),
      body: FutureBuilder<int>(
        future: fetchPoint(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            final errorMessage = snapshot.error.toString();
            // 메시지 필터링
            final cleanMessage = errorMessage.replaceFirst('Exception: ', '');
            return Center(
              child: Text(
                "에러 발생: $cleanMessage",
                style: const TextStyle(fontSize: 18, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          } else if (snapshot.hasData) {
            final dividedScore = snapshot.data!;
            return Column(
              children: [
                Center(
                  child: Text(
                    '점수 : ${dividedScore}',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                ElevatedButton(onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen()
                    ),
                        (route) => false,
                  );
                }, child: Text("확인"))
              ],
            );
          } else {
            return const Center(child: Text("점수를 가져올 수 없습니다."));
          }
        },
      ),
    );
  }
}