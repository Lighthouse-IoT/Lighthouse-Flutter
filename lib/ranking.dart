import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fl_chart/fl_chart.dart';


class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  static const storage = FlutterSecureStorage();
  String? userId;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    }) ;
    userListFuture = fetchUserList();
  }

  _asyncMethod() async {
    userId = await storage.read(key: 'idToken');

    if (userId != null) {
      setState(() {
        userId = userId;
      });
    } else {
      print('로그인이 필요합니다.');
    }
  }

  late Future<List<Map<String, dynamic>>> userListFuture;

  Future<List<Map<String, dynamic>>> fetchUserList() async {
    // 서버 URL
    final url = Uri.parse('http://192.168.219.77:3080/ranking/best-point');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // 서버에서 받은 데이터를 매핑하여 반환
        return data.map((user) {
          return {
            'userId': user['user_id'], // 서버에서 받아온 사용자 ID
            'userName': user['user_name'], // 사용자 이름
            'userPoint': user['user_point'], // 사용자 포인트
            'userImage': user['user_image'] ?? '', // 사용자 이미지 (없으면 기본값)
          };
        }).toList();
      } else {
        throw Exception('Failed to load user list');
      }
    } catch (e) {
      print('Error fetching user list: $e');
      throw Exception('Error fetching data');
    }
  }

// 순위에 따른 아이콘 반환
  String getRankIcon(int index) {
    switch (index) {
      case 0:
        return '🥇';
      case 1:
        return '🥈';
      case 2:
        return '🥉';
      default:
        return '';
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'E-ROOM',
            style: TextStyle(color: Colors.black, fontSize: 24),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: userListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('데이터를 불러오는데 실패했습니다.'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('사용자 데이터가 없습니다.'));
            }
            final userList = snapshot.data!;

            return Scaffold(
              appBar: AppBar(
              title: Text('전체랭킹'),
              backgroundColor: Colors.white,
            ),
              body: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: userList.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final user = userList[index];
                          final rankIcon = getRankIcon(index);

                          return Container(
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            child: Card(
                              color: Colors.white,
                              // 기본 색상만 사용 (순위별 색상 제거)
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero, // 모서리를 직각으로 설정
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 30,
                                ),
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min, // Row의 크기를 최소로 제한
                                  children: [
                                    Text(
                                      rankIcon, // 이모지 아이콘 추가
                                      style: const TextStyle(
                                      fontSize: 24,
                                      ),
                                    ),
                                    Text(
                                      '${index + 1}', // 순위 표시 (index는 0부터 시작하므로 +1)
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(width: 25), // 순위와 프로필 사진 사이 간격
                                    CircleAvatar(
                                      backgroundImage: user['userImage'].isNotEmpty
                                          ? NetworkImage(user['userImage'])
                                          : const AssetImage('assets/profile.png') as ImageProvider,
                                      backgroundColor: Colors.white,
                                    ),
                                  ],
                                ),
                                title: Text(
                                  '${user['userName']}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                trailing: Text(
                                  '포인트: ${user['userPoint']}pt',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                onTap: () {
                                  // 클릭 시 UserDetailsPage로 이동하며 userId 전달
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UserDetailPage(userId: user['userId']),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
              ),
            );
          },
        ),
      ),
    );
  }
}
class UserDetailPage extends StatefulWidget {
  final String userId; // 랭킹에서 선택된 사용자의 userId를 전달받음
  UserDetailPage({required this.userId});

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> solvedWrongAnswers = [];
  Map<String, dynamic> userStats = {};
  bool _isLoading = true;
  String errorMessage = '';

  List<String> dates = [];
  List<int> totalStudyTimes = [];
  List<int> realStudyTimes = [];
  int averageStudyTime = 0;
  int totalStudyTime = 0;


  static const storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchUserStats();
    fetchWrongAnswers();
  }

  Future<void> fetchUserStats() async {
    final userId = widget.userId; // 랭킹에서 전달받은 userId 사용
    final url = Uri.parse('http://192.168.219.77:3080/profile/study-info?userId=$userId');
    print('UserId: $userId');


    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        // 데이터가 비어 있지 않은지 확인
        if (jsonData == null || jsonData.isEmpty) {
          setState(() {
            errorMessage = '데이터가 없습니다.';
          });
          return;
        }

        // 날짜별 데이터 처리
        List<String> tempDates = [];
        List<int> tempTotalStudyTimes = [];
        List<int> tempRealStudyTimes = [];

        for (var item in jsonData) {
          // 각 항목의 필드가 예상한 값이 존재하는지 확인
          if (item['date'] != null && item['total_study_time'] != null && item['real_study_time'] != null) {
            tempDates.add(item['date']);
            tempTotalStudyTimes.add(item['total_study_time']);
            tempRealStudyTimes.add(item['real_study_time']);
          }
        }

        // 데이터가 없는 경우
        if (tempDates.isEmpty) {
          setState(() {
            errorMessage = '유효한 데이터가 없습니다.';
          });
          return;
        }

        // 상태 업데이트
        setState(() {
          dates = tempDates;
          totalStudyTimes = tempTotalStudyTimes;
          realStudyTimes = tempRealStudyTimes;

          // 
          int totalStudyTimeSum = totalStudyTimes.reduce((a,b) => a+b);

          totalStudyTime = totalStudyTimeSum.toInt();

          // 순공부시간의 합을 구하는 부분
          int realStudyTimeSum = realStudyTimes.reduce((a, b) => a + b);

          // 평균 순공부시간 계산 (순공부시간 합을 실수로 계산하여 나눔)
          int diffStudyTimeSum = realStudyTimeSum;

          // 평균 순공부시간 계산 (0으로 나누지 않도록 처리)
          if (realStudyTimes.isNotEmpty) {
            averageStudyTime = (diffStudyTimeSum / realStudyTimes.length).toInt();
          } else {
            averageStudyTime = 0;
          }
        });
      } else {
        setState(() {
          errorMessage = '사용자 통계를 가져오지 못했습니다. (${response.statusCode})';
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = '사용자 통계를 불러오는 중 오류가 발생했습니다.';
      });
    }
  }


  Future<void> fetchWrongAnswers() async {
    final userId = widget.userId; // 랭킹에서 전달받은 userId 사용
    final url = Uri.parse('http://192.168.219.77:3080/review/reviews?userId=$userId');
    print('UserId: $userId');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},

      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        setState(() {
          solvedWrongAnswers = List<Map<String, dynamic>>.from(
              jsonData.where((item) => item['is_reviewed'] == 'Y'));
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


  Widget _buildStatsTab() {
    // 데이터를 받아온 후, 리스트가 비어 있지 않은지 확인
    if (dates.isEmpty || realStudyTimes.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('최근 5일 공부 통계'),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
        ),
        body: Center(child: Text(errorMessage.isEmpty ? '데이터 로딩 중...' : errorMessage)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('최근 5일 공부 통계',),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 그래프 영역
            SizedBox(height: 40),
            Container(
              height: 400,
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(show: true,
                  drawVerticalLine: false
                  ),
                  titlesData: FlTitlesData(
                    topTitles: AxisTitles(sideTitles: SideTitles(
                      showTitles: false,  // 왼쪽 숫자 제거
                    ),),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          // 월/일 형태로 날짜 표시
                          final date = DateTime.parse(dates[value.toInt()]);
                          return Text('${date.month}/${date.day}', style: TextStyle(fontSize: 12));
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,  // 왼쪽에 숫자 표시
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          if (value == meta.max) {
                            return SizedBox.shrink();  // 가장 큰 값은 숨깁니다.
                          }
                          return Text('${(value.toDouble() / 60).toStringAsFixed(1)}시간', style: TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,  // 한 줄로 표시하고, 넘치는 부분은 생략
                          maxLines: 1); // 한 줄로 제한); // 분 단위로 표시
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,  // 오른쪽 숫자 제거
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(dates.length, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        // 각 barRods에 개별적으로 값을 넘기기 위해 toDouble()을 사용합니다.
                        BarChartRodData(
                          toY: totalStudyTimes[index].toDouble(), // totalStudyTimes[index]를 toDouble()으로 변환
                          color: Colors.blue, // 전체 공부 시간 막대 색상
                          width: 12,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        BarChartRodData(
                          toY: realStudyTimes[index].toDouble(), // realStudyTimes[index]를 toDouble()으로 변환
                          color: Colors.green, // 순공부 시간 막대 색상
                          width: 12,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                      barsSpace: 6, // 막대 간 간격
                    );
                  }),
                ),
              ),
            ),

            // 하단 요약 정보
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.timeline, size: 20),
                Text('5일 평균 수치입니다'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('평균 순공부 시간', style: TextStyle(fontSize: 18)),
                Text('${(averageStudyTime ~/ 60)}시간 ${(averageStudyTime % 60)}분', style: TextStyle(fontSize: 18)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('총 공부 시간', style: TextStyle(fontSize: 18)),
                Text('${(totalStudyTime ~/ 60)}시간 ${(totalStudyTime % 60)}분', style: TextStyle(fontSize: 18)),
              ],
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildWrongAnswersTab() {
    // 오답 문제가 없을 때 처리
    if (solvedWrongAnswers.isEmpty) {
      return Center(
        child: Text(
          '오답 문제가 없습니다.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

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
                Text('${wrongAnswer['ex_license'] ?? 'Not Available'}'),
                Text('문제: ${wrongAnswer['ex_test'] ?? 'Not Available'}'),
                if (wrongAnswer['test_img'] != null && wrongAnswer['test_img'].isNotEmpty)
                  Image.network(wrongAnswer['test_img'] ?? '')
                else
                  Container(height: 10),
                _buildAnswerOption('1', wrongAnswer['ex1'], wrongAnswer['user_answer'], '1', wrongAnswer['correct_ex']),
                _buildAnswerOption('2', wrongAnswer['ex2'], wrongAnswer['user_answer'], '2', wrongAnswer['correct_ex']),
                _buildAnswerOption('3', wrongAnswer['ex3'], wrongAnswer['user_answer'], '3', wrongAnswer['correct_ex']),
                _buildAnswerOption('4', wrongAnswer['ex4'], wrongAnswer['user_answer'], '4', wrongAnswer['correct_ex']),
                // review_text가 없으면 '오답 풀이가 없습니다'라는 메시지 표시
                Text(
                  wrongAnswer.containsKey('review_text') && (wrongAnswer['review_text'] != null && wrongAnswer['review_text'].isNotEmpty)
                      ? '오답 풀이: ${wrongAnswer['review_text']}'
                      : '오답 풀이가 없습니다.',
                  style: TextStyle(
                    color: (wrongAnswer.containsKey('review_text') && (wrongAnswer['review_text'] != null && wrongAnswer['review_text'].isNotEmpty))
                        ? Colors.black
                        : Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnswerOption(String optionNumber, String optionText, int? userAnswer, String correctAnswer, String correctEx) {
    Color answerColor;
    String answerText;

    double correctAnswerDouble = double.tryParse(correctEx) ?? 0.0;
    double optionNumberDouble = double.tryParse(optionNumber) ?? 0.0;

    bool isUserAnswerCorrect = userAnswer != null && userAnswer == int.tryParse(optionNumber);
    bool isCorrectAnswer = correctAnswerDouble == optionNumberDouble;

    if (isUserAnswerCorrect) {
      answerColor = Colors.red;
      answerText = '$optionNumber. $optionText';
    } else if (isCorrectAnswer) {
      answerColor = Colors.blue;
      answerText = '$optionNumber. $optionText (정답)';
    } else {
      answerColor = Colors.black;
      answerText = '$optionNumber. $optionText';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(answerText, style: TextStyle(color: answerColor, fontSize: 16)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("사용자 정보"),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Color(0xFF3f51b5), // 눌린 탭의 텍스트 색
          unselectedLabelColor: Colors.grey, // 눌리지 않은 탭의 텍스트 색
          indicatorColor: Color(0xFF3f51b5),
          tabs: [
            Tab(text: '통계'),
            Tab(text: '오답 노트'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStatsTab(),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.red)))
              : _buildWrongAnswersTab(),
        ],
      ),
    );
  }
}



