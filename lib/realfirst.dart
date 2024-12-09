import 'package:flutter/material.dart';
import 'package:flutter21/startexam.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'E-ROOM',
          style: TextStyle(color: Colors.black, fontSize: 24,fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/eroomlogo.png', // 여기에 앱 아이덴티티를 표현하는 이미지 경로 입력
              height: 300,
            ),
            const SizedBox(height: 10),
            // 앱 아이덴티티 표현 섹션
            const Text(
              "AI 비서와 함께 더 나은 학습 경험을! \n"
                  "더 효율적으로, 더 똑똑하게 학습하세요.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "기출문제를 풀고 실력을 점검하세요. \n"
                  "AI가 당신의 학습을 최적화합니다.\n\n",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                height: 1.5, // 줄 간격 설정
              ),
            ),
            const SizedBox(height: 20),


            // Start 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Startexam(), // 타이머 화면
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF26B0F),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
              ),
              child: const Text(
                '배치고사',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
