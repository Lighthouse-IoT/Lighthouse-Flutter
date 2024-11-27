import 'package:flutter/material.dart';
import 'allch.dart'; // 모든 챌린지 파일
import 'ongoingch.dart'; // 진행 중 챌린지 파일
import 'completedch.dart'; // 완료된 챌린지 파일

class ChallengeTab extends StatefulWidget {
  const ChallengeTab({Key? key}) : super(key: key);

  @override
  State<ChallengeTab> createState() => _ChallengeTabState();
}

class _ChallengeTabState extends State<ChallengeTab>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3, // 탭 개수: All, Ongoing, Completed
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
      appBar: AppBar(
        title: const Text('챌린지 관리'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '챌린지 앱'),
            Tab(text: '진행 중'),
            Tab(text: '완료됨'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
        Allch(),
        OngoingCh(),
        Completedch(),  // 완료된 챌린지 화면
        ],
      ),
    );
  }
}
