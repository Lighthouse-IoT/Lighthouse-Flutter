import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model/exammodel.dart';


class Startexam extends StatefulWidget {
  final String userId;

  Startexam({required this.userId});

  @override
  _StartexamState createState() => _StartexamState();
}

class _StartexamState extends State<Startexam> {
  int _currentQuestionIndex = 0;
  List<ExamItem> _examItems = []; // 서버에서 가져온 문제 리스트
  int? _selectedOption; // 사용자가 선택한 보기 인덱스
  bool _isLoading = false;


  Future<void> fetchQuestionsFromDB() async {
    final url = Uri.parse('http://192.168.219.77:3080/exam/first-exam');
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        setState(() {
          _examItems = jsonData.map((item) => ExamItem.fromJson(item)).toList();
          _isLoading = false;
        });
      } else {
        print('문제 가져오기 실패: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('문제를 가져오지 못했습니다.')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('네트워크 에러: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('네트워크 에러가 발생했습니다.')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }
  // 사용자 답변 데이터를 서버로 전송하는 함수
  Future<void> submitAnswer({
    required String exIdx,
    required String userAnswer,
    required String correctEx,
  }) async {
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchQuestionsFromDB(); // 초기화 시 문제를 가져옴
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()), // 로딩 스피너
      );
    }

    if (_examItems.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text('문제를 불러오지 못했습니다.', style: TextStyle(fontSize: 18, color: Colors.red)),
        ),
      );
    }

    final currentQuestion = _examItems[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(currentQuestion.exLicense),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("문제 ${_currentQuestionIndex + 1}/${_examItems.length}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
            SizedBox(height: 20),
            Text(currentQuestion.exTest, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            if (currentQuestion.testImg != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Image.network(
                  Uri.encodeFull(currentQuestion.testImg!),
                  errorBuilder: (context, error, stackTrace) =>
                      Text('이미지를 불러올 수 없습니다.'),
                ),
              ),
            OptionTile(optionText: currentQuestion.ex1, isSelected: _selectedOption == 0, onTap: () => setState(() => _selectedOption = 0)),
            SizedBox(height: 10),
            OptionTile(optionText: currentQuestion.ex2, isSelected: _selectedOption == 1, onTap: () => setState(() => _selectedOption = 1)),
            SizedBox(height: 10),
            OptionTile(optionText: currentQuestion.ex3, isSelected: _selectedOption == 2, onTap: () => setState(() => _selectedOption = 2)),
            SizedBox(height: 10),
            OptionTile(optionText: currentQuestion.ex4, isSelected: _selectedOption == 3, onTap: () => setState(() => _selectedOption = 3)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: nextQuestion,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              child: Text("다음으로", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class OptionTile extends StatelessWidget {
  final String optionText;
  final bool isSelected;
  final VoidCallback onTap;

  OptionTile({required this.optionText, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.indigo.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.indigo),
        ),
        child: Text(optionText, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}


class ResultPage extends StatelessWidget {
  Future<int> fetchPoint() async {
    final url = Uri.parse('http://192.168.219.77:3080/exam/first-result');
    final data = {
      'userId': 'hello', // 전달받은 userId 사용
    };
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        }, body: jsonEncode(data)
      );


      // 응답 상태 코드 출력
      print('HTTP 상태 코드: ${response.statusCode}');
      // 서버에서 전달된 원본 데이터 출력
      print('서버 응답 데이터: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = jsonDecode(response.body);
        print('디코딩된 데이터: $decodedData');
        return decodedData['point'];
      } else {
        throw Exception('점수를 가져오는 데 실패했습니다. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('에러 발생: $e');
      throw Exception('네트워크 에러가 발생했습니다: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Points")),
      body: FutureBuilder<int>(
        future: fetchPoint(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            final errorMessage = snapshot.error.toString();
            // 메시지 필터링
            final cleanMessage = errorMessage.replaceFirst('Exception: ', '');
            return Center(
              child: Text(
                "에러 발생: $cleanMessage",
                style: const TextStyle(fontSize: 18, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          } else if (snapshot.hasData) {
            return Center(
              child: Text(
                  '획득한 점수: ${(snapshot.data)}',
                style: const TextStyle(fontSize: 24),
              ),
            );
          } else {
            return const Center(child: Text("점수를 가져올 수 없습니다."));
          }
        },
      ),
    );
  }
}