import 'package:flutter/material.dart';

void main() => runApp(const Subjectb());

class Subjectb extends StatelessWidget {
  const Subjectb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const StudyGoalsPage(),
    );
  }
}

class StudyGoalsPage extends StatelessWidget {
  const StudyGoalsPage({Key? key}) : super(key: key);

  static const List<String> goals = [
    "1.빅데이터 분석 기획",
    "2.빅데이터 탐색",
    "3.빅데이터 모델링",
    "4.빅데이터 결과 분석"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'E-ROOM',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '공부 목표 설정',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30), // "공부 목표 설정" 아래 간격
            Column(
              children: goals.map((goal) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0), // 간격 설정
                  child: Container(
                    width: 300, // 목표 항목의 가로 길이
                    height: 50, // 목표 항목의 높이
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent, // 배경 색상
                      borderRadius: BorderRadius.circular(10), // 둥근 모서리
                    ),
                    child: Center(
                      child: Text(
                        goal,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: 'Challenge',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Ranking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mypage',
          ),
        ],
      ),
    );
  }
}
