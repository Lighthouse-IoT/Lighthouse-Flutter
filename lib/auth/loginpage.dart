import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter21/auth/joinpage.dart';
import 'package:flutter21/constants.dart';
import 'package:flutter21/pagecontainer.dart';
import 'package:flutter21/realfirst.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final TextEditingController idCon = TextEditingController();
  final TextEditingController pwCon = TextEditingController();
  static const storage = FlutterSecureStorage();
  dynamic userInfo = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    userInfo = await storage.read(key: 'idToken');

    if (userInfo != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => MainScreen()),
        (route) => false,
      );
    } else {
      print('로그인이 필요합니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'E-ROOM',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    decoration: InputDecoration(
                        label: const Row(
                          children: [
                            Icon(Icons.account_circle),
                            SizedBox(width: 5),
                            Text('아이디'),
                          ],
                        ),
                        hintText: '아이디를 입렵하세요',
                        floatingLabelStyle:
                            const TextStyle(color: Color(0xFFF26B0F)),
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black54)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFF26B0F)))),
                    controller: idCon,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    decoration: const InputDecoration(
                        label: Row(
                          children: [
                            Icon(Icons.key),
                            SizedBox(width: 5),
                            Text('비밀번호'),
                          ],
                        ),
                        hintText: '비밀번호를 입력하세요',
                        floatingLabelStyle:
                            const TextStyle(color: Color(0xFFF26B0F)),
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black54)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFF26B0F)))),
                    controller: pwCon,
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF26B0F),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => Joinpage()),
                          (route) => false,
                        );
                      },
                      child: const Text('회원가입',
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF26B0F),
                      ),
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
                      child: const Text('로그인',
                          style: TextStyle(
                            color: Colors.white,
                          )),
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
        '$baseUrl/sign/login',
        data: {'userId': id.toString(), 'userPw': pw},
      );

      if (res.statusCode == 200) {
        await storage.write(key: 'idToken', value: res.data['userId']);
        await storage.write(key: 'nameToken', value: res.data['userName']);
        if (res.data['isFirst'] == 'Y') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => FirstScreen()),
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('로그인 성공')),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => MainScreen()),
            (route) => false,
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인 실패: ${res.data['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('아이디와 비밀번호를 확인해주세요.')),
      );
    }
  }

  @override
  void dispose() {
    idCon.dispose();
    pwCon.dispose();
    super.dispose();
  }
}
