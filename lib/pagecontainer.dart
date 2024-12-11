import 'package:flutter/material.dart';
import 'package:flutter21/ranking.dart';
import 'package:flutter21/review.dart';
import 'package:flutter21/study_goal/start.dart';
import 'auth/home.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // 현재 선택된 탭의 인덱스

  // 탭에 해당하는 페이지들을 리스트로 설정
  final List<Widget> _pages = [
    StartScreen(),
    HomeScreen(),
    WrongAnswersPage(),
    RankingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            backgroundColor: Colors.white,
            icon: Icon(Icons.menu_book_outlined),
            label: 'study',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.person_rounded),
            label: 'profile',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.library_books_outlined),
            label: 'review',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.stacked_bar_chart_rounded),
            label: 'ranking',
          ),
        ],
      ),
    );
  }
}
