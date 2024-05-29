import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:toefl/routes/route_key.dart';
import 'package:toefl/utils/colors.dart';
import 'package:toefl/utils/hex_color.dart';
import 'package:toefl/widgets/blue_button.dart';

import '../remote/api/user_api.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({super.key});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  UserApi userApi = UserApi();
  late List<TextEditingController?> controls;
  var otp = "";
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          borderRadius: BorderRadius.circular(40),
          child: const Icon(
            Icons.chevron_left_rounded,
            size: 30,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              // Added Expanded here
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      "OTP Verification",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: HexColor(neutral70),
                          ),
                          children: const [
                            TextSpan(
                              text:
                                  "Please enter the 4-digit code sent to your email ",
                            ),
                            TextSpan(
                              text: "adindazahra@gmail.com",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: " for verification.",
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    // Add OTP widget here
                    OtpTextField(
                      numberOfFields: 4,
                      contentPadding: const EdgeInsets.symmetric(vertical: 30),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 20),
                      fieldWidth: 65.0,
                      showFieldAsBox: true,
                      borderRadius: BorderRadius.circular(10),
                      borderColor: HexColor(mariner700),
                      focusedBorderColor: HexColor(mariner700),
                      handleControllers: (controllers) {
                        controls = controllers;
                      },
                      onCodeChanged: (String value) {
                        otp = '';
                        setState(() {
                          for (var element in controls) {
                            otp += element!.text;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            isLoading
                ? CircularProgressIndicator(
                    color: HexColor(mariner700),
                  )
                : BlueButton(
                    isDisabled: otp.length < 4,
                    title: "Verify",
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      final isVerified = await userApi.verifyOtp(otp);
                      setState(() {
                        isLoading = false;
                      });
                      if (isVerified.isVerified) {
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pop(context);
                        Navigator.pushNamed(context, RouteKey.main);
                      }
                    }),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn’t receive code? ",
                  style: TextStyle(
                    color: HexColor(neutral50),
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    "Resend (00:59)",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
