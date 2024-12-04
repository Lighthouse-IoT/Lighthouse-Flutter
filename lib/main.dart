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
        primarySwatch: Colors.blue,
      ),
      home: Loginpage(), // 앱 첫 화면으로 MainScreen 설정
    );
  }
}


