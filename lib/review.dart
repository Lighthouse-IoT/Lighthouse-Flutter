import 'package:flutter/material.dart';
import 'package:flutter21/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // JSON을 디코딩하려면 필요합니다.
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WrongAnswersPage extends StatefulWidget {
  @override
  _WrongAnswersPageState createState() => _WrongAnswersPageState();
}

class _WrongAnswersPageState extends State<WrongAnswersPage>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> solvedWrongAnswers = [];
  List<Map<String, dynamic>> unsolvedWrongAnswers = [];
  List<TextEditingController> controllers = [];
  bool _isLoading = true;
  String errorMessage = '';

  static const storage = FlutterSecureStorage();
  dynamic userInfo = '';

  var userId;

  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
    // TabController 초기화
    _tabController =
        TabController(length: 2, vsync: this); // 탭의 개수에 맞게 length 설정
  }

  @override
  void dispose() {
    controllers.forEach((controller) => controller.dispose());
    _tabController.dispose();
    super.dispose();
  }

  _asyncMethod() async {
    userId = await storage.read(key: 'idToken'); // `userId` 값을 갱신

    if (userId != null) {
      setState(() {
        userId = userId; // 이미 갱신된 값을 `setState`로 반영
      });
      fetchWrongAnswers(); // 오답 데이터를 가져오는 함수 호출
    } else {
      print('로그인이 필요합니다.');
    }
  }

  Future<void> fetchWrongAnswers() async {
    var userId = await storage.read(key: 'idToken');
    final url =
        Uri.parse('$baseUrl/review/reviews?userId=$userId'); // userId 적용

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        setState(() {
          // 서버에서 받아온 데이터를 state에 저장
          solvedWrongAnswers = List<Map<String, dynamic>>.from(
              jsonData.where((item) => item['is_reviewed'] == 'Y'));
          unsolvedWrongAnswers = List<Map<String, dynamic>>.from(
              jsonData.where((item) => item['is_reviewed'] == 'N'));

          // TextEditingController는 아직 풀이를 작성하지 않은 문제 수에 맞게 생성
          controllers = List.generate(
              unsolvedWrongAnswers.length, (index) => TextEditingController());
          _isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = '문제를 가져오지 못했습니다. (${response.statusCode})';
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = '문제를 불러오는 중 오류가 발생했습니다.';
        _isLoading = false;
      });
    }
  }

  Future<void> saveWrongAnswer(int index, String answerNote) async {
    final url = Uri.parse('$baseUrl/review/memo');
    final wrongAnswer = unsolvedWrongAnswers[index];

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'reviewIdx': wrongAnswer['review_idx'],
          'memo': answerNote,
          'userId': userId,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          solvedWrongAnswers.add(unsolvedWrongAnswers.removeAt(index));
          controllers.removeAt(index);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오답 풀이 저장 실패 (${response.statusCode})')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('서버와 통신 중 오류가 발생했습니다.')),
      );
    }
  }

  Widget _buildSolvedTab() {
    return ListView.builder(
      itemCount: solvedWrongAnswers.length,
      itemBuilder: (context, index) {
        final wrongAnswer = solvedWrongAnswers[index];
        return Card(
          margin: EdgeInsets.all(10),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 추가된 ex_license, ex_test, test_img 등 출력
                Text('${wrongAnswer['ex_license'] ?? 'Not Available'}'),
                Text('문제: ${wrongAnswer['ex_test'] ?? 'Not Available'}'),
                if (wrongAnswer['test_img'] != null &&
                    wrongAnswer['test_img'].isNotEmpty)
                  Image.network(wrongAnswer['test_img'] ?? '')
                else
                  Container(
                    height: 10,
                  ),
                _buildAnswerOption('1', wrongAnswer['ex1'],
                    wrongAnswer['user_answer'], '1', wrongAnswer['correct_ex']),
                _buildAnswerOption('2', wrongAnswer['ex2'],
                    wrongAnswer['user_answer'], '2', wrongAnswer['correct_ex']),
                _buildAnswerOption('3', wrongAnswer['ex3'],
                    wrongAnswer['user_answer'], '3', wrongAnswer['correct_ex']),
                _buildAnswerOption('4', wrongAnswer['ex4'],
                    wrongAnswer['user_answer'], '4', wrongAnswer['correct_ex']),
                if (wrongAnswer['review_text'] != null &&
                    wrongAnswer['review_text']!.isNotEmpty)
                  Text(
                    '오답 풀이: ${wrongAnswer['review_text']}',
                    style: TextStyle(fontSize: 16),
                  )
                else
                  Text(
                    '오답 풀이가 없습니다.',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUnsolvedTab() {
    return ListView.builder(
      itemCount: unsolvedWrongAnswers.length,
      itemBuilder: (context, index) {
        final wrongAnswer = unsolvedWrongAnswers[index];
        return Card(
          margin: EdgeInsets.all(10),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 추가된 ex_license, ex_test, test_img 등 출력
                Text('${wrongAnswer['ex_license'] ?? '정보 없음'}'),
                Text('문제: ${wrongAnswer['ex_test'] ?? '정보 없음'}'),
                if (wrongAnswer['test_img'] != null &&
                    wrongAnswer['test_img'].isNotEmpty)
                  Image.network(wrongAnswer['test_img'] ?? '')
                else
                  Container(
                    height: 10,
                  ),
                _buildAnswerOption('1', wrongAnswer['ex1'],
                    wrongAnswer['user_answer'], '1', wrongAnswer['correct_ex']),
                _buildAnswerOption('2', wrongAnswer['ex2'],
                    wrongAnswer['user_answer'], '2', wrongAnswer['correct_ex']),
                _buildAnswerOption('3', wrongAnswer['ex3'],
                    wrongAnswer['user_answer'], '3', wrongAnswer['correct_ex']),
                _buildAnswerOption('4', wrongAnswer['ex4'],
                    wrongAnswer['user_answer'], '4', wrongAnswer['correct_ex']),
                SizedBox(height: 8),
                TextField(
                  controller: controllers[index],
                  decoration: InputDecoration(
                    labelText: '오답 정리 입력',
                    hintText: '문제풀이에 대해 간단히 정리해보세요.',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    final answerNote = controllers[index].text.trim();
                    if (answerNote.isNotEmpty) {
                      await saveWrongAnswer(index, answerNote);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('오답 풀이를 입력해주세요.')),
                      );
                    }
                  },
                  child: Text('저장하기'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnswerOption(String optionNumber, String optionText,
      int? userAnswer, String correctAnswer, String correctEx) {
    Color answerColor;
    String answerText;

    // 정답 값과 보기 값이 실수로 변환될 수 있도록 처리
    double correctAnswerDouble = double.tryParse(correctEx) ?? 0.0;
    double optionNumberDouble = double.tryParse(optionNumber) ?? 0.0;

    // 사용자가 선택한 답변과 정답 비교
    bool isUserAnswerCorrect =
        userAnswer != null && userAnswer == int.tryParse(optionNumber);
    bool isCorrectAnswer = correctAnswerDouble == optionNumberDouble;

    if (isUserAnswerCorrect) {
      // 사용자가 선택한 답변은 빨간색으로 표시
      answerColor = Colors.red;
      answerText = '$optionNumber. $optionText';
    } else if (isCorrectAnswer) {
      // 정답인 경우 파란색으로 표시
      answerColor = Colors.blue;
      answerText = '$optionNumber. $optionText (정답)';
    } else {
      // 그 외에는 기본 색상
      answerColor = Colors.black;
      answerText = '$optionNumber. $optionText';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        answerText,
        style: TextStyle(color: answerColor, fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("오답 노트"),
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: "푼 오답 문제"),
              Tab(text: "안 푼 오답 문제"),
            ],
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(
                    child:
                        Text(errorMessage, style: TextStyle(color: Colors.red)),
                  )
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildSolvedTab(),
                      _buildUnsolvedTab(),
                    ],
                  ),
      ),
    );
  }
}
