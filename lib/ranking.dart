import 'package:flutter/material.dart';

final List<Map<String, dynamic>> userList = [
  {'name': '홍길동', 'points': 1200, 'avatar': Icons.person},
  {'name': '김철수', 'points': 1100, 'avatar': Icons.person_outline},
  {'name': '이영희', 'points': 1050, 'avatar': Icons.person_pin},
  {'name': '박서준', 'points': 1020, 'avatar': Icons.person},
  {'name': '정미나', 'points': 1000, 'avatar': Icons.person_outline},
];

class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  List<String> favoriteUsers = [];
  String searchQuery = ''; // 검색어 저장

  @override
  Widget build(BuildContext context) {
    // 검색어로 필터링된 리스트 생성
    List<Map<String, dynamic>> filteredList = userList
        .where((user) => user['name'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('E-ROOM 랭킹'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 검색 입력 필드
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                labelText: '사용자 검색',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final user = filteredList[index];
                  final isFavorite = favoriteUsers.contains(user['name']);

                  // 카드 색상 및 순위 아이콘 설정
                  Color cardColor;
                  String rankIcon;
                  switch (index) {
                    case 0:
                      cardColor = Colors.amber.shade200;
                      rankIcon = '🥇';
                      break;
                    case 1:
                      cardColor = Colors.amber.shade100;
                      rankIcon = '🥈';
                      break;
                    case 2:
                      cardColor = Colors.grey.shade300;
                      rankIcon = '🥉';
                      break;
                    default:
                      cardColor = Colors.white;
                      rankIcon = '';
                  }

                  return Card(
                    color: cardColor,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple.shade100,
                        child: Icon(user['avatar'], color: Colors.deepPurple),
                      ),
                      title: Text(
                        '$rankIcon ${user['name']}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '포인트: ${user['points']}pt',
                        style: TextStyle(fontSize: 16),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            if (isFavorite) {
                              favoriteUsers.remove(user['name']);
                            } else {
                              favoriteUsers.add(user['name']);
                            }
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
