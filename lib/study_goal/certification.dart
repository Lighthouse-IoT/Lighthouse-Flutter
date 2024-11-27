import 'package:flutter/material.dart';

void main() => runApp(const Certification());

class Certification extends StatelessWidget {
  const Certification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const StudySettingsScreen(),
    );
  }
}

class StudySettingsScreen extends StatefulWidget {
  const StudySettingsScreen({Key? key}) : super(key: key);

  @override
  _StudySettingsScreenState createState() => _StudySettingsScreenState();
}

class _StudySettingsScreenState extends State<StudySettingsScreen> {
  final List<String> goals = ["1.한식조리기능사", "2.빅데이터분석기사"]; // 공부 목표 리스트

  int _currentIndex = 0; // 현재 선택된 탭 인덱스

  final List<Widget> _pages = [
    Center(child: Text('Challenge Page', style: TextStyle(fontSize: 20))),
    Center(child: Text('Ranking Page', style: TextStyle(fontSize: 20))),
    Center(child: Text('Schedule Page', style: TextStyle(fontSize: 20))),
    Center(child: Text('MyPage', style: TextStyle(fontSize: 20))),
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
      body: _currentIndex == 0
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '공부 목표 설정',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40), // "공부 목표 설정" 아래 간격
            Column(
              children: goals.map((goal) {
                return Column(
                  children: [
                    Container(
                      width: 250,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue[300], // 색상 변경
                        borderRadius: BorderRadius.circular(10),
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
                    const SizedBox(height: 40), // 각 목표 항목 사이 간격
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      )
          : _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // 현재 선택된 탭 업데이트
          });
        },
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
            label: 'MyPage',
          ),
        ],
      ),
    );
  }
}
