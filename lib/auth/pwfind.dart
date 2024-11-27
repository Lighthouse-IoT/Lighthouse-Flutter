import 'package:flutter/material.dart';

void main() {
  runApp(const FindPw());
}

class FindPw extends StatelessWidget {
  const FindPw({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const FindPwScreen(), // 홈 화면으로 설정
    );
  }
}

class FindPwScreen extends StatelessWidget {
  const FindPwScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const FindPwTab(), // 비밀번호 변경 화면
    );
  }
}

class FindPwTab extends StatelessWidget {
  const FindPwTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('아이디 입력', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              hintText: '아이디 입력',
            ),
          ),
          const SizedBox(height: 20),
          const Text('전화번호 입력', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              hintText: '전화번호 입력',
            ),
          ),
          const SizedBox(height: 20),
          const Text('새 비밀번호 입력', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              hintText: '새 비밀번호 입력',
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // 비밀번호 변경 로직 추가
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '비밀번호 변경',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
