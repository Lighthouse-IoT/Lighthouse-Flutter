import 'package:flutter/material.dart';
import 'package:flutter21/auth/home.dart';
import 'package:flutter21/auth/joinpage.dart';
import 'package:dio/dio.dart';

class Loginpage extends StatelessWidget {
  const Loginpage({super.key});



  @override
  Widget build(BuildContext context) {
    TextEditingController idCon = TextEditingController();
    TextEditingController pwCon = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'E-room',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  child: TextField(
                    decoration: InputDecoration(
                      label: const Row(
                        children: [
                          Icon(Icons.account_circle),
                          SizedBox(width: 5),
                          Text('userId 입력'),
                        ],
                      ),
                      hintText: 'test@test.com',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: const OutlineInputBorder(),
                    ),
                    controller: idCon,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  child: TextField(
                    decoration: const InputDecoration(
                      label: Row(
                        children: [
                          Icon(Icons.key),
                          SizedBox(width: 5),
                          Text('userPw 입력'),
                        ],
                      ),
                      border: OutlineInputBorder(),
                    ),
                    controller: pwCon,
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => Joinpage()),
                              (route) => false,
                        );
                      },
                      child: const Text('회원가입'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (idCon.text.isEmpty || pwCon.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('ID와 PW를 입력해주세요.'),
                            ),
                          );
                          return;
                        }
                        loginMember(idCon.text, pwCon.text, context);
                      },
                      child: const Text('로그인'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loginMember(id, pw, context) async {
    final dio = Dio();
    dio.options
      ..contentType = Headers.formUrlEncodedContentType
      ..connectTimeout = const Duration(milliseconds: 10000) // Duration 객체 사용
      ..receiveTimeout = const Duration(milliseconds: 10000);

    try {
      print(id);
      Response res = await dio.post(
        'http://192.168.219.77:3080/sign/login',
        data: {'userId': id.toString(), 'userPw': pw},
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인 성공:')),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => Home()),
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인 실패: ${res.data['message']}')),
        );
      }
    } catch (e) {
      print('Dio 예외 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('네트워크 오류 발생: $e')),
      );
    }
  }
}