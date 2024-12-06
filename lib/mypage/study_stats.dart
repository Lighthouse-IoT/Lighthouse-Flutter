import 'package:flutter/material.dart';
import 'package:flutter21/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fl_chart/fl_chart.dart';

class LearningStatsScreen extends StatefulWidget {
  @override
  State<LearningStatsScreen> createState() => _LearningStatsScreenState();
}

class _LearningStatsScreenState extends State<LearningStatsScreen> {
  static const storage = FlutterSecureStorage();
  String? userId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    userId = await storage.read(key: 'idToken');
    print('유저:${userId}');

    if (userId != null) {
      setState(() {
        userId = userId;
      });
      fetchUserStats();
    } else {
      print('로그인이 필요합니다.');
    }
  }

  List<String> dates = [];
  List<int> totalStudyTimes = [];
  List<int> realStudyTimes = [];
  int averageStudyTime = 0;
  int totalStudyTime = 0;
  String errorMessage = '';

  Future<void> fetchUserStats() async {
    final url = Uri.parse('$baseUrl/profile/study-info?userId=$userId');
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
          if (item['date'] != null &&
              item['total_study_time'] != null &&
              item['real_study_time'] != null) {
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
          int totalStudyTimeSum = totalStudyTimes.reduce((a, b) => a + b);

          totalStudyTime = totalStudyTimeSum.toInt();

          // 순공부시간의 합을 구하는 부분
          int realStudyTimeSum = realStudyTimes.reduce((a, b) => a + b);

          // 평균 순공부시간 계산 (순공부시간 합을 실수로 계산하여 나눔)
          int diffStudyTimeSum = realStudyTimeSum;

          // 평균 순공부시간 계산 (0으로 나누지 않도록 처리)
          if (realStudyTimes.isNotEmpty) {
            averageStudyTime =
                (diffStudyTimeSum / realStudyTimes.length).toInt();
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

  @override
  Widget build(BuildContext context) {
    // 데이터를 받아온 후, 리스트가 비어 있지 않은지 확인
    if (dates.isEmpty || realStudyTimes.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('최근 5일 공부 통계',
          style: TextStyle(
              fontWeight: FontWeight.w700
          ),),
          centerTitle: true,
          // backgroundColor: Colors.deepPurple,
        ),
        body: Center(
          child: Text(
            errorMessage.isEmpty ? '데이터 로딩 중...' : errorMessage,
            style: TextStyle(fontSize: 16, color: Colors.red,fontWeight: FontWeight.w700),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('학습통계',style: TextStyle(fontWeight: FontWeight.w700),),
        // centerTitle: true,
        backgroundColor: Colors.white,
    
      ),
      body: Container(
        color: Color(0xFFFFF4EB),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        
              // 그래프 영역
              SizedBox(height: 40),
              Container(
                height: 350,
                child: BarChart(
                  BarChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false, // 세로줄 숨기기
                    ),
                    titlesData: FlTitlesData(
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            final date = DateTime.parse(dates[value.toInt()]);
                            return Text('${date.month}/${date.day}',
                                style: TextStyle(fontSize: 12));
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          getTitlesWidget: (value, meta) {
                            if (value == meta.max) {
                              return SizedBox.shrink(); // 가장 큰 값 숨기기
                            }
                            return Text(
                              '${(value.toDouble() / 60).toStringAsFixed(1)}시간',
                              style: TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            );
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(dates.length, (index) {
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: totalStudyTimes[index].toDouble(),
                            color: Color(0xFFF26B0F),
                            width: 12,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          BarChartRodData(
                            toY: realStudyTimes[index].toDouble(),
                            color: Color(0xFFFCC737),
                            width: 12,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                        barsSpace: 6,
                      );
                    }),
                      barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                              tooltipPadding: EdgeInsets.all(8), // Adjust padding
                              // Tooltip background color
                              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                final int studyMinutes = rod.toY.toInt();
                                return BarTooltipItem(
                                  '$studyMinutes 분',
                                  TextStyle(color: Colors.white, fontSize: 14),
                                );
                        }
                      )
                    )
                  ),
                ),
              ),
        
              // 하단 요약 정보
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.timeline, size: 20),
                  Text('5일 평균 수치입니다',),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('평균 순공부 시간', style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700)),
                  Text(
                      '${(averageStudyTime ~/ 60)}시간 ${(averageStudyTime % 60)}분',
                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('총 공부 시간', style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700)),
                  Text('${(totalStudyTime ~/ 60)}시간 ${(totalStudyTime % 60)}분',
                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
