import 'package:flutter/material.dart';
import 'ongoingch.dart' as ongo;
import 'completedch.dart' as com;

class Allch extends StatelessWidget {
  const Allch ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('모든 챌린지'),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: '모든 챌린지'),
              Tab(text: '진행 중'),
              Tab(text: '종료'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildChallengeList(),
            ongo.OngoingCh(),
            com.Completedch(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.edit),
              label: 'Challenge',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events),
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
      ),
    );
  }

  Widget _buildChallengeList() {
    final List<Map<String, dynamic>> challenges = [
      {
        'title': '챌린지 이름',
        'description': '챌린지 진행해야할 내용',
        'period': '기간: N일',
        'points': '200P',
        'backgroundColor': Colors.blue[50],
        'borderColor': Colors.blue[200],
      },
      {
        'title': '챌린지 이름',
        'description': '챌린지 진행해야할 내용',
        'period': '기간: N일',
        'points': '100P',
        'backgroundColor': Colors.blue[50],
        'borderColor': Colors.blue[200],
      },
      {
        'title': '챌린지 이름',
        'description': '챌린지 진행해야할 내용',
        'period': '기간: N일',
        'points': '300P',
        'backgroundColor': Colors.blue[50],
        'borderColor': Colors.blue[200],
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          final challenge = challenges[index];
          return _buildChallengeCard(
            title: challenge['title'] as String,
            description: challenge['description'] as String,
            period: challenge['period'] as String,
            points: challenge['points'] as String,
            backgroundColor: challenge['backgroundColor'] as Color?,
            borderColor: challenge['borderColor'] as Color?,
          );
        },
      ),
    );
  }

  Widget _buildChallengeCard({
    required String title,
    required String description,
    required String period,
    required String points,
    required Color? backgroundColor,
    required Color? borderColor,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: borderColor ?? Colors.transparent, width: 2.0),
      ),
      color: backgroundColor ?? Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14.0, color: Colors.black87),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    period,
                    style: const TextStyle(fontSize: 12.0, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Text(
              points,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
