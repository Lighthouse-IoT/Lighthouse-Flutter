import 'package:flutter/material.dart';
import 'pwfind.dart'; // 비밀번호 변경 화면 가져오기

class FindId extends StatelessWidget {
  const FindId({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 탭의 개수
      child: Scaffold(
        appBar: AppBar(
          title: const Text('E-ROOM'),
          centerTitle: true,
          backgroundColor: Colors.lightBlueAccent,
          bottom: const TabBar(
            tabs: [
              Tab(text: '아이디 찾기'),
              Tab(text: '비밀번호 변경'),
            ],
            labelColor: Colors.black,
            indicatorColor: Colors.black,
          ),
        ),
        body: const TabBarView(
          children: [
            FindIdTab(), // 아이디 찾기 화면
            FindPw(), // 비밀번호 변경 화면
          ],
        ),
      ),
    );
  }
}

class FindIdTab extends StatelessWidget {
  const FindIdTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('휴대전화번호 입력', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: '휴대전화번호 입력',
            ),
          ),
          const SizedBox(height: 20),
          const Text('이메일 입력', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: '이메일 입력',
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // 아이디 찾기 로직 추가
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent, // 버튼의 배경색 변경
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // 버튼 내부 여백
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // 버튼의 둥근 모서리
                ),
              ),
              child: const Text(
                '아이디 찾기',
                style: TextStyle(
                  color: Colors.black, // 버튼 텍스트 색상
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
