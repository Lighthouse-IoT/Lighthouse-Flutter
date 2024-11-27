import 'dart:convert'; // JSON 인코딩/디코딩
import 'package:flutter/material.dart';
import 'package:flutter21/model/exammodel.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(Exam());
}

// 앱의 진입점 클래스
class Exam extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Arial', // 원하는 폰트 설정
      ),
      home: HomeScreen(), // 기본 화면으로 HomeScreen 설정
      debugShowCheckedModeBanner: false,
    );
  }
}

// 홈 화면
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // 현재 선택된 탭의 인덱스

  // 각 탭에 대응하는 화면들
  final List<Widget> _screens = [
    QuestionScreen(), // 첫 번째 탭: 문제 화면
    ChallengeScreen(), // 두 번째 탭: 챌린지 화면
    RankingScreen(), // 세 번째 탭: 랭킹 화면
    ScheduleScreen(), // 네 번째 탭: 스케줄 화면
    MyPageScreen(), // 다섯 번째 탭: 마이페이지 화면
  ];

  // 탭 클릭 시 화면 전환
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // 현재 선택된 화면 표시
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Challenge',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Ranking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'MyPage',
          ),
        ],
      ),
    );
  }
}

// 문제 화면
class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int _currentQuestionIndex = 0; // 현재 보여줄 문제의 인덱스
  List<ExamItem> _examItems = []; // 서버에서 가져온 문제 리스트
  int? _selectedOption; // 사용자가 선택한 보기 인덱스

  // 백엔드에서 문제를 가져오는 함수
  Future<void> fetchQuestionsFromDB() async {
    final url = Uri.parse(
        'http://192.168.219.77:3080/exam/recommended-exams?q=신경망&section=["2"]');

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        setState(() {
          // JSON 데이터를 ExamItem 객체로 변환하여 저장
          _examItems =
              jsonData.map((item) => ExamItem.fromJson(item)).toList();
        });
      } else {
        print('문제 가져오기 실패: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('문제를 가져오지 못했습니다.')),
        );
      }
    } catch (e) {
      print('네트워크 에러: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('네트워크 에러가 발생했습니다.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchQuestionsFromDB(); // 초기화 시 문제를 가져옴
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _examItems.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOption = null; // 다음 문제로 이동 시 선택 초기화
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('마지막 문제입니다.')),
      );
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _selectedOption = null; // 이전 문제로 이동 시 선택 초기화
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('첫 번째 문제입니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_examItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('E-ROOM'),
        ),
        body: Center(
          child: CircularProgressIndicator(), // 문제를 불러오는 동안 로딩 화면
        ),
      );
    }

    // 현재 표시할 문제
    final currentQuestion = _examItems[_currentQuestionIndex];
    print(currentQuestion.testImg);
    return Scaffold(
      appBar: AppBar(
        title: Text('E-ROOM'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '문제 ${_currentQuestionIndex + 1}/${_examItems.length}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              currentQuestion.exTest,
              style: TextStyle(fontSize: 18, height: 1.5),
            ),
            if (currentQuestion.testImg != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Image.network(
                  Uri.encodeFull(currentQuestion.testImg!),
                  // errorBuilder: (context, error, stackTrace) =>
                  //     Text('이미지를 불러올 수 없습니다.'),
                ),
              ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 4, // 보기 개수
                itemBuilder: (context, index) {
                  final options = [
                    currentQuestion.ex1,
                    currentQuestion.ex2,
                    currentQuestion.ex3,
                    currentQuestion.ex4,
                  ];
                  return RadioListTile<int>(
                    title: Text('${index + 1}) ${options[index]}'),
                    value: index,
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value;
                      });
                    },
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: previousQuestion,
                  child: Text('이전 문제'),
                ),
                ElevatedButton(
                  onPressed: nextQuestion,
                  child: Text('다음 문제'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 각 탭의 임시 화면
class ChallengeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Challenge Screen')),
    );
  }
}

class RankingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Ranking Screen')),
    );
  }
}

class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Schedule Screen')),
    );
  }
}

class MyPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('MyPage Screen')),
    );
  }
}
