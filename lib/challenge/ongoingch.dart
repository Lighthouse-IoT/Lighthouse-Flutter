import 'package:flutter/material.dart';

class OngoingCh extends StatelessWidget {
  const OngoingCh({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('진행 중 챌린지'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: const ListTile(
                title: Text('진행 중 챌린지 1'),
                subtitle: Text('기간: N일'),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: const ListTile(
                title: Text('진행 중 챌린지 2'),
                subtitle: Text('기간: N일'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
