import 'package:flutter/material.dart';
import 'package:flutter21/auth/home.dart';
import 'package:flutter21/auth/idfind.dart';
import 'package:flutter21/auth/joinpage.dart';
import 'package:flutter21/auth/loginpage.dart';
import 'package:flutter21/auth/pwfind.dart';
import 'package:flutter21/challenge/allch.dart';
import 'package:flutter21/challenge/completedch.dart';
import 'package:flutter21/challenge/challenge_tab.dart';
import 'package:flutter21/challenge/ongoingch.dart';
import 'package:flutter21/model/exam.dart';
import 'package:flutter21/mypage/schedule.dart';
import 'package:flutter21/mypage/study_stats.dart';
import 'package:flutter21/study_goal/certification.dart';
import 'package:flutter21/study_goal/goal.dart';
import 'package:flutter21/study_goal/level.dart';
import 'package:flutter21/study_goal/start.dart';
import 'package:flutter21/study_goal/subjectb.dart';
import 'package:flutter21/study_goal/subjecth.dart';
import 'package:flutter21/study_goal/timer.dart';
import 'package:flutter21/startexam.dart';
import 'package:flutter21/review.dart';
import 'package:flutter21/ranking.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tab Bar Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(), // 앱 첫 화면으로 MainScreen 설정
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // 현재 선택된 탭의 인덱스

  // 탭에 해당하는 페이지들을 리스트로 설정
  final List<Widget> _pages = [
    StartScreen(),        // 첫 번째 탭: Home 화면
    Exam(userId: 'test'), // 두 번째 탭: Exam 화면
    HomeScreen(),      // 세 번째 탭: Profile 화면
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0
              ? 'Home'
              : _currentIndex == 1
              ? 'Exam'
              : 'Profile',
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
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Exam',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
