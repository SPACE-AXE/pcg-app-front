import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class LoginBtn extends StatefulWidget {
  final String id;
  final String pwd;
  const LoginBtn({super.key, required this.id, required this.pwd});

  @override
  State<LoginBtn> createState() => _LoginBtnState();
}

class _LoginBtnState extends State<LoginBtn> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff39c5bb),
          elevation: 5,
        ),
        onPressed: () {
          Map<String, dynamic> userData = {
            'username': widget.id,
            'password': widget.pwd,
          };
          logIn(userData);
          Navigator.pop(context);
        },
        child: const Text(
          "로그인",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void logIn(Map<String, dynamic> userData) async {
    String url = 'https://api.parkchargego.link/auth/login';
    Uri uri = Uri.parse(url);
    http.Response response = await http.post(uri, body: userData);

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "로그인이 완료되었습니다.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xff39c5bb),
        textColor: Colors.white,
        fontSize: 16,
      );
    } else {
      print(uri);
      Fluttertoast.showToast(
        msg: '사용할 수 없는 아이디입니다.',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xff39c5bb),
      );
    }
  }
}
