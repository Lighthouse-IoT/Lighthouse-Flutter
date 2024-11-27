import 'package:flutter/material.dart';

class TabScaffold extends StatelessWidget {
  final List<Widget> tabs; // 탭 이름 리스트
  final List<Widget> views; // 탭에 연결된 화면 리스트

  const TabScaffold({Key? key, required this.tabs, required this.views})
      : assert(tabs.length == views.length), // 탭과 화면의 개수가 같아야 함
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length, // 탭 개수
      child: Scaffold(
        appBar: AppBar(
          title: const Text('E-ROOM'),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          bottom: TabBar(
            labelColor: Colors.lightBlueAccent,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.black,
            tabs: tabs,
          ),
        ),
        body: TabBarView(
          children: views,
        ),
      ),
    );
  }
}
