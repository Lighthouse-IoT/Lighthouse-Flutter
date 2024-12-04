import 'package:flutter/material.dart';
import 'package:flutter21/ranking.dart';
import 'package:flutter21/review.dart';
import 'package:flutter21/startexam.dart';
import 'package:flutter21/study_goal/start.dart';
import 'package:flutter21/study_goal/subjectb.dart';
import 'auth/home.dart';
import 'model/exam.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 2; // 현재 선택된 탭의 인덱스

  // 탭에 해당하는 페이지들을 리스트로 설정
  final List<Widget> _pages = [
    StartScreen(),        // 첫 번째 탭: Home 화면
    Startexam(),      // 세 번째 탭: Profile 화면
    RankingPage()

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0
              ? 'study'
              : _currentIndex == 1
              ? 'Home'
              : 'goal',
        ),
      ),
      body: _pages[_currentIndex], // 현재 선택된 탭에 해당하는 화면 표시
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // 선택된 탭의 인덱스 업데이트
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'study',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'goal',
          ),
        ],
      ),
    );
  }
}
