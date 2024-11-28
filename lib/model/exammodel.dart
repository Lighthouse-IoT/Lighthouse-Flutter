class ExamItem {
  final int exIdx;
  final String exLicense;
  final String exSection;
  final String exTest;
  final String testType;
  final String? testImg;
  final String ex1;
  final String ex2;
  final String ex3;
  final String ex4; // ex4 추가
  final String correctEx;
  final int exLevel;
  final String? userAnswer;

  ExamItem({
    required this.exIdx,
    required this.exLicense,
    required this.exSection,
    required this.exTest,
    required this.testType,
    required this.testImg,
    required this.ex1,
    required this.ex2,
    required this.ex3,
    required this.ex4, // ex4 필드 초기화
    required this.correctEx,
    required this.exLevel,
    this.userAnswer
  });

  // JSON -> 객체 변환
  factory ExamItem.fromJson(Map<String, dynamic> json) {
    return ExamItem(
      exIdx: json['ex_idx'],
      exLicense: json['ex_license'],
      exSection: json['ex_section'],
      exTest: json['ex_test'],
      testType: json['test_type'],
      testImg: json['test_img'],
      ex1: json['ex1'],
      ex2: json['ex2'],
      ex3: json['ex3'],
      ex4: json['ex4'], // ex4 매핑
      correctEx: json['correct_ex'],
      exLevel: json['ex_level'],
      userAnswer: json['user_answer'],
    );
  }

  // 객체 -> JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'ex_idx': exIdx,
      'ex_license': exLicense,
      'ex_section': exSection,
      'ex_test': exTest,
      'test_type': testType,
      'test_img': testImg,
      'ex1': ex1,
      'ex2': ex2,
      'ex3': ex3,
      'ex4': ex4, // ex4 추가
      'correct_ex': correctEx,
      'ex_level': exLevel,
      'user_answer': userAnswer,
    };
  }
}
