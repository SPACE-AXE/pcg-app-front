import 'package:appfront/Screen/Auth/register/widgets/custom_form_field.dart';
import 'package:appfront/Screen/Auth/register/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _id = TextEditingController();
  final TextEditingController _nickname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _pwdKey = GlobalKey<FormState>();

  bool idDuplicateFlag = false;
  final RegExp _emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  String _birth = '';
  bool emailCheck = true;
  bool pwdCheckFlag = false;

  String username = '';
  String nickname = '';
  String email = '';
  String name = '';
  String password = '';
  String birth = '';
  String phone = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('회원가입'),
        ),
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Expanded(flex: 1, child: idInput(context)),
                // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Expanded(flex: 1, child: nicknameInput(context)),
                // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Expanded(flex: 1, child: emailInput(context)),
                // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Expanded(flex: 1, child: nameInput(context)),
                // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Expanded(flex: 1, child: passwordInput(context)),
                // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Expanded(flex: 1, child: passwordCheckInput(context)),
                // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Expanded(flex: 1, child: birthInput(context)),
                // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Expanded(flex: 1, child: phoneInput(context)),
                // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                enterBtn(context),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              ],
            ),
          ),
        ));
  }

  ElevatedButton enterBtn(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(200, 10),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (_birth == "") {
              Fluttertoast.showToast(
                msg: "생일을 입력해주세요.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: const Color(0xff39c5bb),
                textColor: Colors.white,
                fontSize: 16,
              );
            } else if (!pwdCheckFlag) {
              _pwdKey.currentState!.validate();
            } else if (idDuplicateFlag) {
              setState(() {
                username = _id.text;
                nickname = _nickname.text;
                email = _email.text;
                name = _name.text;
                password = _password.text;
                phone = _phone.text;
              });
              Map<String, dynamic> userData = {
                'name': name,
                'nickname': nickname,
                'email': email,
                'username': username,
                'password': password,
                'birth': birth,
              };
              register(userData);
              Navigator.pop(context);
            } else {
              Fluttertoast.showToast(
                msg: "아이디 중복확인이 필요합니다.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: const Color(0xff39c5bb),
                textColor: Colors.white,
                fontSize: 16,
              );
            }
          }
        },
        child: const Text(
          "회원가입",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ));
  }

  Container phoneInput(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "필수 입력값입니다.";
          }
          return null;
        },
        maxLength: 13,
        controller: _phone,
        decoration: const InputDecoration(
          counterText: '',
          hintText: "전화번호",
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff39c5bb),
            ),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _phone.value = _phone.value.copyWith(
              // 입력된 숫자를 정규식에 맞게 변환하여 적용
              text: value.replaceAllMapped(
                RegExp(r'(\d{3})(\d{4})(\d{4})'),
                (m) => '${m[1]}-${m[2]}-${m[3]}',
              ),
              selection: TextSelection.collapsed(offset: value.length),
            );
          });
        },
      ),
    );
  }

  Container birthInput(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      width: MediaQuery.of(context).size.width * 0.6,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              readOnly: true,
              decoration: InputDecoration(
                counterText: '',
                hintText: _birth == '' ? "생일" : "생일: $_birth",
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff39c5bb),
                  ),
                ),
              ),
              onChanged: (value) {
                if (_pwdKey.currentState!.validate()) {
                  pwdCheckFlag = !pwdCheckFlag;
                }
              },
            ),
          ),
          Expanded(
              flex: 1,
              child: IconButton(
                  iconSize: 30,
                  onPressed: () {
                    showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now())
                        .then((selectedDate) {
                      if (selectedDate != null) {
                        setState(() {
                          birth = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                              .format(selectedDate);
                          _birth =
                              DateFormat("yyyy-MM-dd").format(selectedDate);
                        });
                      }
                    });
                  },
                  icon: const Icon(Icons.date_range))),
        ],
      ),
    );
  }

  Container passwordInput(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(),
        width: MediaQuery.of(context).size.width * 0.6,
        child: CustomFormField(
          obscureText: true,
          text: "비밀번호",
          controller: _password,
        ));
  }

  Container passwordCheckInput(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      width: MediaQuery.of(context).size.width * 0.6,
      child: Form(
        key: _pwdKey,
        child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "필수 입력값입니다.";
            }
            if (value != _password.text) {
              return "비밀번호가 일치하지 않습니다.";
            }
            return null;
          },
          maxLength: 13,
          obscureText: true,
          decoration: const InputDecoration(
            counterText: '',
            hintText: "비밀번호 확인",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xff39c5bb),
              ),
            ),
          ),
          onChanged: (value) {
            if (_pwdKey.currentState!.validate()) {
              pwdCheckFlag = !pwdCheckFlag;
            }
          },
        ),
      ),
    );
  }

  Container nameInput(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(),
        width: MediaQuery.of(context).size.width * 0.6,
        child: CustomFormField(
          obscureText: false,
          text: "이름",
          controller: _name,
        ));
  }

  Container emailInput(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "필수 입력값입니다.";
          } else if (!emailCheck) {
            return "이메일 형식에 맞지 않습니다.";
          }
          return null;
        },
        controller: _email,
        decoration: InputDecoration(
          errorText: emailCheck ? null : "이메일 형식에 맞지 않습니다",
          hintText: "이메일",
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff39c5bb),
            ),
          ),
        ),
        onChanged: (value) {
          if (!_emailRegExp.hasMatch(value)) {
            setState(() {
              emailCheck = false;
            });
          } else {
            setState(() {
              emailCheck = true;
            });
          }
        },
      ),
    );
  }

  Container nicknameInput(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "필수 입력값입니다.";
          }
          return null;
        },
        controller: _nickname,
        decoration: const InputDecoration(
          hintText: "닉네임",
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff39c5bb),
            ),
          ),
        ),
      ),
    );
  }

  Container idInput(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      width: MediaQuery.of(context).size.width * 0.6,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: CustomFormField(
              obscureText: false,
              text: "아이디",
              controller: _id,
            ),
          ),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  username = _id.text;
                });
                idDuplicateFlag ? null : checkUserIdDuplicate(username);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(1),
                side: BorderSide(
                  color: idDuplicateFlag ? const Color(0xff39c5bb) : Colors.red,
                ),
              ),
              child: const Text(
                "중복확인",
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }

  void checkUserIdDuplicate(String username) async {
    String url = 'https://api.parkchargego.link/api/v1/auth/check-username-duplicate/';
    // URL을 올바르게 형성하기 위해 Uri 클래스를 사용합니다.
    Uri uri = Uri.parse('$url$username');
    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      print(uri);
      Fluttertoast.showToast(
        msg: "사용할 수 있는 아이디입니다.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xff39c5bb),
        textColor: Colors.white,
        fontSize: 16,
      );
      setState(() {
        idDuplicateFlag = !idDuplicateFlag;
      });
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

void register(Map<String, dynamic> userData) async {
  String url = 'https://api.parkchargego.link/api/v1/auth/register';
  Uri uri = Uri.parse(url);
  http.Response response = await http.post(uri, body: userData);

  if (response.statusCode == 201) {
    CustomToast.showToast("회원가입이 완료되었습니다.");
  } else {
    print(uri);
    print(response.body);
    CustomToast.showToast("이메일 혹은 전화번호가 중복되었습니다.");
  }
}

class ButtonStateManager {
  bool idDuplicateFlag = false;
}
