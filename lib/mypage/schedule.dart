import 'package:flutter/material.dart';

void main() => runApp(const Schedule());

class Schedule extends StatelessWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ScheduleScreen(),
    );
  }
}

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

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
            // 상단 텍스트
            Container(
              width: double.infinity, // 전체 너비로 확장
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  '시험 일정',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // D-Day 표시
            const Text(
              'D - 148',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            // 버튼 리스트
            Expanded(
              child: ListView(
                children: [
                  _buildExamButton('빅분기 8회 필기', '4월 6일 (토)'),
                  const SizedBox(height: 12),
                  _buildExamButton('빅분기 8회 실기', '6월 22일 (토)'),
                  const SizedBox(height: 12),
                  _buildExamButton('빅분기 9회 필기', '9월 7일 (토)'),
                  const SizedBox(height: 12),
                  _buildExamButton('빅분기 9회 실기', '11월 30일 (토)'),
                ],
              ),
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

  // 버튼 생성 함수
  Widget _buildExamButton(String title, String subtitle) {
    return Container(
      width: double.infinity, // 전체 너비로 확장
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.purple[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4), // 제목과 날짜 사이 간격
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
