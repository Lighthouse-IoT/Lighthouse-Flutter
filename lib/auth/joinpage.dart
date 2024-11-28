import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter21/auth/loginpage.dart';

class Joinpage extends StatelessWidget {
  // 컨트롤러를 클래스 멤버 변수로 선언
  final TextEditingController nameCon = TextEditingController();
  final TextEditingController birthDateCon = TextEditingController();
  final TextEditingController idCon = TextEditingController();
  final TextEditingController pwCon = TextEditingController();
  final TextEditingController pwCheckCon = TextEditingController();
  final TextEditingController emailCon = TextEditingController();
  final TextEditingController phoneCon = TextEditingController();

  // 회원가입 API 호출
  void joinMember(BuildContext context) async {
    final dio = Dio();
    dio.options
      ..contentType = Headers.formUrlEncodedContentType
      ..connectTimeout = const Duration(milliseconds: 10000)
      ..receiveTimeout = const Duration(milliseconds: 10000);

    try {
      Response res = await dio.post(
        'http://192.168.219.77:3080/sign/join',
        data: {
          'userId': idCon.text,
          'userPw': pwCon.text,
          'userName': nameCon.text,
          'userBirthdate': birthDateCon.text,
          'userEmail': emailCon.text,
          'userPhone': phoneCon.text,
        },
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원가입 성공!')),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => Loginpage()),
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 실패: ${res.data['message']}')),
        );
      }
    } catch (e) {
      print('Dio 예외 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('네트워크 오류 발생: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // 배경색 하늘색 설정
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'E-ROOM',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('이름:'),
                  TextField(
                    controller: nameCon,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: '이름 입력',
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('생년월일:'),
                  GestureDetector(
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2000),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (selectedDate != null) {
                        birthDateCon.text =
                        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        controller: birthDateCon,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          hintText: '생년월일 선택',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('아이디:'),
                  TextField(
                    controller: idCon,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: '아이디 입력',
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('비밀번호:'),
                  TextField(
                    controller: pwCon,
                    obscureText: true,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: '비밀번호 입력',
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('비밀번호 확인:'),
                  TextField(
                    controller: pwCheckCon,
                    obscureText: true,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: '비밀번호 확인 입력',
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('이메일:'),
                  TextField(
                    controller: emailCon,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: '이메일 입력',
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('연락처:'),
                  TextField(
                    controller: phoneCon,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: '연락처 입력',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        joinMember(context);
                      },
                      child: const Text('회원가입'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
