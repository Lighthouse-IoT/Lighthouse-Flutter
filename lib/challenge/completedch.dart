import 'package:flutter/material.dart';

void main() {
  runApp(const Completedch());
}

class Completedch extends StatelessWidget {
  const Completedch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ChallengeTab(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ChallengeTab extends StatefulWidget {
  const ChallengeTab({Key? key}) : super(key: key);

  @override
  State<ChallengeTab> createState() => _ChallengeTabState();
}

class _ChallengeTabState extends State<ChallengeTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3, // 3개의 탭
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: const [
          ChallengeListView(statusFilter: null), // 모든 챌린지
          ChallengeListView(statusFilter: '진행 중'), // 진행 중
          ChallengeListView(statusFilter: '종료'), // 종료
        ],
      ),
    );
  }
}

class ChallengeListView extends StatelessWidget {
  final String? statusFilter;

  const ChallengeListView({Key? key, this.statusFilter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> challenges = [
      {
        'title': '한식 조리기능사',
        'description': '챌린지 진행해야할 내용',
        'period': '11월 22일 - 11월 24일',
        'status': '성공',
        'backgroundColor': Colors.green[100],
        'statusColor': Colors.green,
      },
      {
        'title': '빅데이터 분석기사',
        'description': '챌린지 진행해야할 내용',
        'period': '11월 24일 - 11월 29일',
        'status': '실패',
        'backgroundColor': Colors.grey[300],
        'statusColor': Colors.grey,
      },
    ];

    final filteredChallenges = challenges.where((challenge) {
      if (statusFilter == null) return true;
      if (statusFilter == '진행 중') return challenge['status'] == '진행 중';
      if (statusFilter == '종료') return challenge['status'] == '성공' || challenge['status'] == '실패';
      return true;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: filteredChallenges.length,
        itemBuilder: (context, index) {
          final challenge = filteredChallenges[index];
          return ChallengeCard(
            title: challenge['title'] as String,
            description: challenge['description'] as String,
            period: challenge['period'] as String,
            status: challenge['status'] as String,
            backgroundColor: challenge['backgroundColor'] as Color? ?? Colors.white,
            statusColor: challenge['statusColor'] as Color? ?? Colors.grey,
          );
        },
      ),
    );
  }
}

class ChallengeCard extends StatelessWidget {
  final String title;
  final String description;
  final String period;
  final String status;
  final Color backgroundColor;
  final Color statusColor;

  const ChallengeCard({
    Key? key,
    required this.title,
    required this.description,
    required this.period,
    required this.status,
    required this.backgroundColor,
    required this.statusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: backgroundColor,
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
