import 'package:flutter/material.dart';

void main() => runApp(const level());

class level extends StatefulWidget {
  const level ({Key? key}) : super(key: key);

  @override
  _StudyGoalAppState createState() => _StudyGoalAppState();
}

class _StudyGoalAppState extends State<level> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const StudySettingsScreen(),
    );
  }
}

class StudySettingsScreen extends StatefulWidget {
  const StudySettingsScreen({Key? key}) : super(key: key);

  @override
  _StudySettingsScreenState createState() => _StudySettingsScreenState();
}

class _StudySettingsScreenState extends State<StudySettingsScreen> {
  String selectedDifficulty = "없음";
  Color difficultyColor = Colors.grey[300]!;

  void _setDifficulty(String difficulty, Color color) {
    setState(() {
      selectedDifficulty = difficulty;
      difficultyColor = color;
    });
    Navigator.pop(context);
  }

  void _showDifficultySelector() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext modalContext) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('하 (쉬움)'),
                onTap: () {
                  _setDifficulty('하 (쉬움)', Colors.blue[100]!);
                },
              ),
              ListTile(
                title: const Text('중 (보통)'),
                onTap: () {
                  _setDifficulty('중 (보통)', Colors.orange[100]!);
                },
              ),
              ListTile(
                title: const Text('상 (어려움)'),
                onTap: () {
                  _setDifficulty('상 (어려움)', Colors.red[100]!);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'E-ROOM',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: GestureDetector(
          onTap: _showDifficultySelector,
          child: Container(
            width: 250,
            height: 60,
            decoration: BoxDecoration(
              color: difficultyColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    "선택된 난이도: $selectedDifficulty",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Icon(Icons.menu, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
