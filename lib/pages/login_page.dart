import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toefl/models/login.dart';
import 'package:toefl/remote/api/login_api.dart';
import 'package:toefl/routes/route_key.dart';
import 'package:toefl/utils/colors.dart';
import 'package:toefl/utils/hex_color.dart';
import 'package:toefl/widgets/blue_button.dart';
import 'package:toefl/widgets/form_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final loginApi = LoginApi();
    Login? login;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SvgPicture.asset('assets/images/login.svg'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: HexColor(mariner700),
                      ),
                    ),
                    Text(
                      "Hello there, sign in to continue",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: HexColor(neutral50),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InputText(
                            controller: emailController,
                            title: "Email",
                            hintText: "Email",
                            suffixIcon: null,
                            focusNode: _emailFocusNode,
                          ),
                          SizedBox(height: 15.0),
                          InputText(
                            controller: passwordController,
                            title: "Password",
                            hintText: "Password",
                            suffixIcon: Icons.visibility_off,
                            focusNode: _passwordFocusNode,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    BlueButton(
                      title: 'Login',
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          login = await loginApi.postLogin(emailController.text,  passwordController.text);
                        }
                      },
                    ),
                    const SizedBox(height: 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don’t have an account? ",
                          style: TextStyle(
                            color: HexColor(neutral50),
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, RouteKey.regist);
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
