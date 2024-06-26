import 'package:appfront/Screen/Auth/find_account/find_account_screen.dart';
import 'package:appfront/Screen/Auth/register/register_screen.dart';
import 'package:appfront/Screen/Auth/reset_pwd/reset_pwd_screen.dart';
import 'package:flutter/material.dart';

class ThreeBtn extends StatelessWidget {
  const ThreeBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FindAccountScreen(),
                ),
              );
            },
            child: const Text("아이디 찾기"),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ResetPwdScreen(),
                ),
              );
            },
            child: const Text("비밀번호 재설정"),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisterScreen(),
                ),
              );
            },
            child: const Text("회원 가입"),
          ),
        ],
      ),
    );
  }
}
