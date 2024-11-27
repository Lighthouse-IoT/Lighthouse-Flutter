import 'package:flutter/material.dart';
import 'timer.dart'; // timer.dart를 import

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'D - 148',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height:60),
           ElevatedButton(
              onPressed: () {
                // timer.dart로 화면 이동
                Navigator.push(
                  context,
                    MaterialPageRoute(
                    builder: (context) => const TimerScreen(), // 타이머 화면
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[100],
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
              ),
              child: const Text(
                'START',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
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
            label: 'Mypage',
          ),
        ],
        onTap: (index) {
          // 탭 클릭 시 다른 화면으로 이동 로직
          switch (index) {
            case 0:
            // Challenge 화면 이동 로직
              break;
            case 1:
            // Ranking 화면 이동 로직
              break;
            case 2:
            // Schedule 화면 이동 로직
              break;
            case 3:
            // Mypage 화면 이동 로직
              break;
          }
        },
      ),
    );
  }
}
