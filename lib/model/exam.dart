import 'dart:convert'; // JSON 인코딩/디코딩
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter21/model/exammodel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Exam extends StatefulWidget {
  final String userId; // 로그인 페이지에서 전달받은 userId
  final String keyword;
  final String subjects;

  Exam({required this.userId, required this.keyword, required this.subjects});

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<Exam> {
  int _currentQuestionIndex = 0; // 현재 보여줄 문제의 인덱스
  List<ExamItem> _examItems = []; // 서버에서 가져온 문제 리스트
  int? _selectedOption; // 사용자가 선택한 보기 인덱스
  // 문제를 서버에서 가져오는 함수
  Future<void> fetchQuestionsFromDB() async {
    print(widget.keyword);
    print(widget.subjects);
    final url = Uri.parse(
        'http://192.168.219.77:3080/exam/recommended-exams?q=${widget.keyword}&section=${widget.subjects}');

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        setState(() {
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

  // 사용자 답변 데이터를 서버로 전송하는 함수
  Future<void> submitAnswer({
    required String exIdx,
    required String userAnswer,
    required String correctEx,
  }) async {
    // var userId = await storage.read(key: 'idToken');
    final url = Uri.parse('http://192.168.219.77:3080/exam/solving');

    final data = {
      'userId': 'hello', // 전달받은 userId 사용
      'exIdx': exIdx,
      'userAnswer': userAnswer,
      'correctEx': correctEx,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('정답 제출 성공: ${response.body}');
      } else {
        print('정답 제출 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('정답 제출 중 에러: $e');
    }
  }

  // 다음 문제로 이동
  void nextQuestion() {
    if (_selectedOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('답안을 선택해주세요.')),
      );
      return;
    }

    final currentQuestion = _examItems[_currentQuestionIndex];

    // 사용자 답변 제출
    submitAnswer(
      exIdx: currentQuestion.exIdx.toString(),
      userAnswer: (['1', '2', '3', '4'])[_selectedOption!],
      correctEx: currentQuestion.correctEx,
    );

    if (_currentQuestionIndex < _examItems.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOption = null; // 다음 문제로 이동 시 선택 초기화
      });
    } else {
      // TODO: 여기 경로 살려야됨
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => ()
      //   ),
      //     (route) => false,
      // );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 문제를 완료했습니다.')),
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

    final currentQuestion = _examItems[_currentQuestionIndex];

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
            if (currentQuestion.testImg != null &&
                currentQuestion.testImg!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Image.network(
                  Uri.encodeFull(currentQuestion.testImg!),
                  errorBuilder: (context, error, stackTrace) =>
                      Text('이미지를 불러올 수 없습니다.'),
                ),
              ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
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
                  onPressed: nextQuestion,
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
