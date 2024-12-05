import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter21/auth/home.dart';
import 'package:flutter21/model/exam.dart';

void main() => runApp(const Certification());

class Certification extends StatelessWidget {
  const Certification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CertificationSelectionScreen(),
    );
  }
}

// 1. 자격증 종류 선택 화면
class CertificationSelectionScreen extends StatelessWidget {
  const CertificationSelectionScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> certifications = const [
    {
      "name": "빅데이터분석기사",
      "subjects": ["빅데이터 분석 기획", "빅데이터 탐색", "빅데이터 모델링", "빅데이터 결과 분석"]
    },
    {
      "name": "한식조리기능사",
      "subjects": ["한식 재료 관리", "음식 조리 및 위생"]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('자격증 선택', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: certifications.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(certifications[index]["name"]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TimerScreen(
                          subjects: List<String>.from(
                              certifications[index]["subjects"]),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 2. 타이머 화면
class TimerScreen extends StatefulWidget {
  final List<String> subjects;

  const TimerScreen({Key? key, required this.subjects}) : super(key: key);

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Timer _timer;
  int _seconds = 0;
  bool isStudyEnded = false; // 공부 종료 상태
  final TextEditingController _keywordController = TextEditingController();
  late Map<String, bool> _selectedSubjects;

  @override
  void initState() {
    super.initState();
    _selectedSubjects = {
      for (var subject in widget.subjects) subject: false
    }; // 초기화
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _keywordController.dispose(); // 컨트롤러 해제
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stopStudy() {
    setState(() {
      isStudyEnded = true; // 공부 종료 상태 변경
    });
    _timer.cancel();
  }

  void _searchKeyword() {
    // 선택한 과목 추출
    final selectedSubjects = _selectedSubjects.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    // 과목 인덱스 저장 리스트
    List<int> trueIndices = [];
    int index = 0;

    _selectedSubjects.forEach((key, value) {
      if (value) {
        trueIndices.add(index);
      }
      index++;
    });

    // 저장한 인덱스 int -> string
    List<String> selectedSubjectNum = trueIndices.map((i) => (i + 1).toString()).toList();
    String realStringSubject = '[${selectedSubjectNum.map((e) => '"$e"').join(", ")}]';


    final keyword = _keywordController.text.trim();
    print(keyword);
    print(realStringSubject);
    if (keyword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('키워드를 입력해주세요.')),
      );
      return;
    }

    if (selectedSubjects.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('최소 하나의 과목을 선택해주세요.')),
      );
      return;
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => Exam(keyword: keyword, subjects: realStringSubject)
      ),
        (route) => false,
    );
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isStudyEnded
            ? SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '공부 종료! 과목을 선택하세요:',
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ..._selectedSubjects.keys.map((subject) {
                return CheckboxListTile(
                  title: Text(subject),
                  value: _selectedSubjects[subject],
                  onChanged: (bool? value) {
                    setState(() {
                      _selectedSubjects[subject] = value ?? false;
                    });
                  },
                );
              }).toList(),
              const Divider(height: 40, thickness: 1),
              const Text(
                '키워드를 입력하고 검색하세요:',
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _keywordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '키워드 입력',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _searchKeyword,
                child: const Text('검색'),
              ),
            ],
          ),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.access_time,
                size: 60, color: Colors.black54),
            const SizedBox(height: 20),
            Text(
              _formatTime(_seconds),
              style: const TextStyle(
                  fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _stopStudy,
              child: const Text('공부 종료'),
            ),
          ],
        ),
      ),
    );

  }
}
