import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter21/constants.dart';
import 'package:flutter21/model/exam.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

// 1. 자격증 종류 선택 화면
class CertificationSelectionScreen extends StatefulWidget {
  const CertificationSelectionScreen({Key? key}) : super(key: key);

  @override
  State<CertificationSelectionScreen> createState() =>
      _CertificationSelectionScreenState();
}

class _CertificationSelectionScreenState
    extends State<CertificationSelectionScreen> {
  Image? _image;
  bool _isLoading = false;
  final List<Map<String, dynamic>> certifications = const [
    {
      "name": "빅데이터분석기사",
      "subjects": ["빅데이터 분석 기획", "빅데이터 탐색", "빅데이터 모델링", "빅데이터 결과 분석"]
    },
    {
      "name": "한식조리기능사(추가예정)",
      "subjects": ["한식 재료 관리", "음식 조리 및 위생"]
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> fetchImage() async {
    setState(() {
      _isLoading = true;
    });
    final url = Uri.parse("$baseUrl/study/check-body");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _image = Image.memory(response.bodyBytes, fit: BoxFit.cover);
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load image');
    }
  }

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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
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
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _image != null
                    ? Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: _image!,
                      )
                    : Container(
                        height: 280, width: 360,
                        decoration: BoxDecoration(
                          color: Color(0xFFFFF4EB),
                          borderRadius: BorderRadius.circular(16), // 박스를 둥글게 처리
                        ),
                        child: Center(
                            child: _isLoading
                                ? CircularProgressIndicator(
                                    color: Color(0xFFF26B0F), // 로딩 색상
                                  )
                                : Text("상반신이 나오도록 카메라를 조절해보세요!")),
                        // color: Color(0xFFFFF4EB),
                      ),
                SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF26B0F),
                  ),
                  onPressed: fetchImage,
                  child: Text(
                    "카메라 확인하기",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
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
  late Timer _studyInfoTimer;
  int _seconds = 0;
  bool isStudyEnded = false; // 공부 종료 상태
  dynamic userInfo = '';
  static const storage = FlutterSecureStorage();
  final TextEditingController _keywordController = TextEditingController();

  late Map<String, bool> _selectedSubjects;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
    _selectedSubjects = {
      for (var subject in widget.subjects) subject: false
    }; // 초기화
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _studyInfoTimer.cancel();
    _keywordController.dispose(); // 컨트롤러 해제
    super.dispose();
  }

  _asyncMethod() async {
    userInfo = await storage.read(key: 'idToken');
    _startStudy();
    _startStudyInfo();
  }

  Future<void> startStudyServer() async {
    final url = Uri.parse("$baseUrl/study/start-study");

    try {
      final response = await http.post(url, body: {"userId": userInfo});

      if (response.statusCode == 200) {
        print(response.body);
      }
    } catch (e) {
      print(e);
      print("ERROR!!!!");
    }
  }

  Future<void> stopStudyServer() async {
    final url = Uri.parse("$baseUrl/study/end-study");

    try {
      final response = await http.post(url, body: {"userId": userInfo});

      if (response.statusCode == 200) {
        print(response.body);
      }
    } catch (e) {
      print(e);
      print("END ERROR!!!!");
    }
  }

  Future<void> startStudyJetson() async {
    final url = Uri.parse("$baseUrl/study/start-detect");

    try {
      final response = await http.post(url, body: {"userId": userInfo});

      if (response.statusCode == 200) {
        print("startStudyJetson");
        print(response.body);
      }
    } catch (e) {
      print("JETSON ERROR!!!!");
    }
  }

  void _startStudy() {
    startStudyServer();
  }

  void _startStudyInfo() {
    _studyInfoTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      startStudyJetson();
    });
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
    _studyInfoTimer.cancel();
    stopStudyServer();
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
    List<String> selectedSubjectNum =
        trueIndices.map((i) => (i + 1).toString()).toList();
    String realStringSubject =
        '[${selectedSubjectNum.map((e) => '"$e"').join(", ")}]';

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
          builder: (context) =>
              Exam(keyword: keyword, subjects: realStringSubject)),
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
                      '공부 종료! 과목을 선택하세요',
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
                        activeColor: Color(0xFFF26B0F),
                        checkColor: Colors.white,
                      );
                    }).toList(),
                    const Divider(height: 40, thickness: 1),
                    const Text(
                      '키워드를 입력하고 검색하세요',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFFF26B0F),
                          ),
                          borderRadius: BorderRadius.circular(8), // 모서리 둥글게
                        ),
                        child: TextField(
                          controller: _keywordController,
                          decoration: const InputDecoration(
                              hintText: '키워드 입력', border: InputBorder.none),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF26B0F),
                      ),
                      onPressed: _searchKeyword,
                      child: const Text(
                        '검색',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF26B0F),
                    ),
                    onPressed: _stopStudy,
                    child: const Text(
                      '공부 종료',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
