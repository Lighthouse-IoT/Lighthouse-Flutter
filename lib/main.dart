import 'package:flutter/material.dart';
import 'package:flutter21/auth/loginpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tab Bar Example',
      theme: ThemeData(
        fontFamily: "Goyang",
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.white, // 앱바 색 설정
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          showUnselectedLabels: true,
          showSelectedLabels: true,
          backgroundColor: Colors.white, // 하단 네비게이션 바 색 설정
          selectedItemColor: Color(0xFFF26B0F), // 선택된 아이템 색
          unselectedItemColor: Colors.grey, // 선택되지 않은 아이템 색
        ),
      ),
      home: Loginpage(), // 앱 첫 화면으로 MainScreen 설정
    );
  }
}
