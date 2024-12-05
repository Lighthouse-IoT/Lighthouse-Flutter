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
import 'package:flutter21/pagecontainer.dart';
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
        // primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
        color: Colors.white,  // 앱바 색 설정
      ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,  // 하단 네비게이션 바 색 설정
          selectedItemColor: Colors.black87,  // 선택된 아이템 색
          unselectedItemColor: Colors.grey,  // 선택되지 않은 아이템 색
        ),
      ),
      home: Loginpage(), // 앱 첫 화면으로 MainScreen 설정
    );
  }
}


