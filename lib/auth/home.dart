import 'package:flutter/material.dart';
import 'package:flutter21/constants.dart';
import 'package:flutter21/startexam.dart';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import '../mypage/study_stats.dart';
import '../review.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const storage = FlutterSecureStorage();
  dynamic userName = '';
  var userImage;
  var userPoint;
  File? _selectedImage;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPoint();
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      _uploadImage(_selectedImage!);
    }
  }

  Future<void> _uploadImage(File image) async {
    var userId = await storage.read(key: 'idToken');

    try {
      final uri = Uri.parse(
          "$baseUrl/profile/upload-image?directory=profile&userId=$userId"); // 서버 URL
      final request = http.MultipartRequest('POST', uri)
        ..fields['userId'] = "tester"
        ..files.add(await http.MultipartFile.fromPath('image', image.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        print('Image uploaded successfully!');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이미지가 성공적으로 업로드되었습니다.')),
        );
        setState(() {});
      } else {
        print('Failed to upload image: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이미지 업로드 실패.')),
        );
      }
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('서버 업로드 중 오류 발생.')),
      );
    }
  }

  Future<void> fetchPoint() async {
    var userId = await storage.read(key: 'idToken');
    final url = Uri.parse('$baseUrl/profile/user-profile/$userId');
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = jsonDecode(response.body);
        setState(() {
          userName = decodedData['user_name'];
          userImage = decodedData['user_image'];
          userPoint = decodedData['user_point'];
        });
      } else {
        throw Exception('점수를 가져오는 데 실패했습니다.');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'E-ROOM',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (userImage != null)
                      GestureDetector(
                        onTap: _pickImage,
                        child: ClipOval(
                          child: Image.network(
                            Uri.encodeFull(
                                '$userImage?${DateTime.now().millisecondsSinceEpoch}'),
                            key: UniqueKey(),
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Text('이미지를 불러올 수 없습니다.'),
                          ),
                        ),
                      ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('${userPoint.toString()} 포인트'),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceEvenly, // 아이콘과 텍스트 간 간격을 고르게 설정
                      children: [
                        // 첫 번째 아이콘과 텍스트
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Startexam(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.mark_chat_read_outlined),
                              iconSize: 40, // 아이콘 크기 키우기
                              padding: const EdgeInsets.all(0), // 아이콘 간격 기본
                              color: Colors.black,
                            ),
                            const Text(
                              '배치고사',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        // 두 번째 아이콘과 텍스트
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WrongAnswersPage(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.rate_review_outlined),
                              iconSize: 40, // 아이콘 크기 키우기
                              padding: const EdgeInsets.all(0), // 아이콘 간격 기본
                              color: Colors.black,
                            ),
                            const Text(
                              '오답정리',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            // const SizedBox(height: 25),
            Expanded(
              child: LearningStatsScreen(), // 학습 통계 화면을 바로 표시
            ),
          ],
        ),
      ),
    );
  }
}
