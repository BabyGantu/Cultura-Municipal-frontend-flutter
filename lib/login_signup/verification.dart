// ignore_for_file: avoid_print, unused_catch_clause

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Controller/AuthController.dart';
import 'package:goevent2/login_signup/login.dart';
import 'package:goevent2/utils/itextfield.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/botton.dart';
import '../utils/colornotifire.dart';
import '../utils/media.dart';

final login = Get.put(AuthController());

class Verification extends StatefulWidget {
  final String? type;
  final String? email;
  final int verID;
  final bool isReset;
  const Verification(
      {Key? key,
      required this.verID,
      this.email,
      this.type,
      required this.isReset})
      : super(key: key);

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  //final auth = FirebaseAuth.instance;
  final otpController = TextEditingController();
  OtpFieldController OtpController = OtpFieldController();
  final x = Get.put(AuthController());

  bool resendotp = false;
  String otpPin = " ";

  late ColorNotifire notifire;
  int vID = 0;

  Timer? _timer;
  int _start = 20;

  final fpassword = TextEditingController();
  final spassword = TextEditingController();

  bool _obscureText = true;
  bool _obscureText1 = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggle2() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
  }

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    notifire.setIsDark = previusstate;
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            resendotp = true;
            timer.cancel();
          });
        } else {
          setState(() {});
          _start--;
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getdarkmodepreviousstate();
    startTimer();
    vID = widget.verID;
  }

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }

  Future<void> verifyOTP(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    int id = widget.verID!;
    // Llama a verificarCodigo y espera a que se complete
    print('___________________________________');
    print(otpController.text);
    print(id);
    print('___________________________________');

    if (widget.isReset) {
      Map<String, dynamic> result =
          await login.upDatePassword(id, fpassword.text, otpController.text);

      if (result['success']) {
        Get.to(() => const Login());
      } else {
        ApiWrapper.showToastMessage(
            "No se pudo actualizar la contraseña. Inténtalo de nuevo.");
      }
    } else {
      Map<String, dynamic> result =
          await login.validarCode(id, otpController.text);
      if (result['success']) {
        Get.to(() => const Login());
      }
    }
  }

  Future<void> reenviarCodigo(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    int id = widget.verID;
    // Llama a verificarCodigo y espera a que se complete
    bool? reenvioDeCodigo = await login.reSendCode(id);
  }

  /*void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      final authCredential =
          await auth.signInWithCredential(phoneAuthCredential);

      if (authCredential.user != null) {
        if (widget.type == "Reset") {
          Get.to(() => PasswordsetPage(number: widget.number));
        } else {
          x.userRegister();
        }
        ApiWrapper.showToastMessage("Auth Completed!");
      } else {
        ApiWrapper.showToastMessage("Auth Failed!");
      }
    } on FirebaseAuthException catch (e) {
      ApiWrapper.showToastMessage("Auth Failed! ");
      print(e);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.backgrounde,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: height / 20),
            Row(
              children: [
                SizedBox(width: width / 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back, color: notifire.getwhitecolor),
                ),
              ],
            ),
            SizedBox(height: height / 100),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Check email".tr,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Gilroy Medium',
                        color: notifire.getwhitecolor),
                  ),
                ),
              ],
            ),
            SizedBox(height: height / 100),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hemos enviado un código de verificación".tr,
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Gilroy Medium',
                            color: notifire.getwhitecolor),
                      ),
                      SizedBox(height: height / 400),
                      Text(
                        "a ${widget.email ?? ""}",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Gilroy Medium',
                            color: notifire.getwhitecolor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: height / 30),
            animatedBorders(),
            SizedBox(height: height / 30),
            SizedBox(height: height / 100),
            Visibility(
              visible: widget.isReset,
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "Change Password".tr,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Gilroy Medium',
                              color: notifire.getwhitecolor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height / 100),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Por favor, ingrese su nueva contraseña".tr,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Gilroy Medium',
                                  color: notifire.getwhitecolor),
                            ),
                            SizedBox(height: height / 400),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height / 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Customtextfild2.textField(
                      fpassword,
                      _obscureText,
                      "New Password".tr,
                      Colors.grey,
                      notifire.getwhitecolor,
                      "image/Lock.png",
                      GestureDetector(
                          onTap: () {
                            _toggle();
                          },
                          child: _obscureText
                              ? Image.asset("image/Hide.png", height: 22)
                              : Image.asset("image/Show.png", height: 22)),
                      context: context,
                    ),
                  ),
                  SizedBox(height: Get.height * 0.02),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Customtextfild2.textField(
                      spassword,
                      _obscureText1,
                      "Confirm Password".tr,
                      Colors.grey,
                      notifire.getwhitecolor,
                      "image/Lock.png",
                      GestureDetector(
                          onTap: () {
                            _toggle2();
                          },
                          child: _obscureText1
                              ? Image.asset("image/Hide.png", height: 22)
                              : Image.asset("image/Show.png", height: 22)),
                      context: context,
                    ),
                  ),
                  SizedBox(height: height / 20),
                ],
              ),
            ),
            SizedBox(height: height / 30),
            GestureDetector(
              onTap: () {
                if (fpassword.text.isNotEmpty &&
                    spassword.text.isNotEmpty &&
                    otpController.text.isNotEmpty || !widget.isReset) {
                  print((fpassword.text == spassword.text));
                  if (fpassword.text == spassword.text || !widget.isReset) {
                    verifyOTP(context);
                  } else {
                    ApiWrapper.showToastMessage("Password does not match");
                  }
                } else {
                  ApiWrapper.showToastMessage(
                      "Please complete the required fields!");
                }
              },
              child: SizedBox(
                height: 45,
                child: Custombutton.button1(
                  notifire.getbuttonscolor,
                  "Verify".tr,
                  SizedBox(width: width / 5),
                  SizedBox(width: width / 7),
                ),
              ),
            ),
            SizedBox(height: height / 30),
            resendotp
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          otpController.clear();
                          reenviarCodigo(context);
                        },
                        child: Text(
                          "Resend code".tr,
                          style: TextStyle(
                              color: notifire.getwhitecolor,
                              fontSize: 12,
                              fontFamily: 'Gilroy Bold'),
                        ),
                      )
                    ],
                  )
                : SizedBox(
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Re-send code in ",
                        style: TextStyle(
                            color: notifire.getwhitecolor,
                            fontSize: 12,
                            fontFamily: 'Gilroy Medium'),
                      ),
                      Text(
                        durationToString(_start).toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: notifire.textcolor),
                      ),
                    ],
                  )),
          ],
        ),
      ),
    );
  }

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(20),
    ),
  );
  Widget animatedBorders() {
    return Container(
      color: notifire.backgrounde,
      height: Get.height * 0.06,
      width: Get.width * 0.90,
      child: Pinput(
        length: 6,
        controller: otpController,
        onSubmitted: (val) {},
        // onSubmit: (val) {},
        onChanged: (val) {},
        // textStyle: TextStyle(
        //     color: Colors.black,
        //     fontWeight: FontWeight.w500,
        //     fontFamily: 'Gilroy_Bold',
        //     fontSize: height / 40),
        // fieldsCount: 6,
        // eachFieldWidth: Get.width * 0.13,
        showCursor: false,

        defaultPinTheme: PinTheme(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.grey, width: 2)),
        ),
        focusedPinTheme: defaultPinTheme.copyDecorationWith(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey.shade200)),
        submittedPinTheme: defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration?.copyWith(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.grey)),
        ),

        // submittedFieldDecoration: BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.circular(10.0),
        //     border: Border.all(color: Colors.grey)
        // ),
        // selectedFieldDecoration: BoxDecoration(
        //     color: Colors.grey.shade200,
        //     borderRadius: BorderRadius.circular(10.0),
        //     border: Border.all(color: Colors.grey.shade200)),
        // disabledDecoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2), color: Colors.grey),
        // followingFieldDecoration: BoxDecoration(
        //   backgroundBlendMode: BlendMode.color,
        //   border: Border.all(color: notifire.bordercolore),
        //   color: Colors.grey,
        //   borderRadius: BorderRadius.circular(10.0),
        // ),
      ),
    );
  }

  // Widget animatedBorders() {
  //   return Container(
  //     color: notifire.backgrounde,
  //     height: Get.height * 0.06,
  //     width: Get.width * 0.90,
  //     child: OTPTextField(
  //       otpFieldStyle: OtpFieldStyle(
  //         enabledBorderColor: Colors.grey.withOpacity(0.4),
  //       ),
  //       controller: OtpController,
  //       length: 6,
  //       width: MediaQuery.of(context).size.width,
  //       textFieldAlignment: MainAxisAlignment.spaceAround,
  //       fieldWidth: 45,
  //       fieldStyle: FieldStyle.box,
  //       outlineBorderRadius: 5,
  //       contentPadding: const EdgeInsets.all(15),
  //       style:  TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold),
  //       onChanged: (pin) {
  //       },
  //       onCompleted: (pin) {
  //         setState(() {
  //           smscode = pin;
  //         });
  //       },
  //     ),
  //   );
  // }

  /*Future<void> verifyPhone(String number) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      timeout: const Duration(seconds: 30),
      verificationCompleted: (PhoneAuthCredential credential) {
        ApiWrapper.showToastMessage("Auth Completed!");
      },
      verificationFailed: (FirebaseAuthException e) {
        ApiWrapper.showToastMessage("Auth Failed!");
      },
      codeSent: (String verificationId, int? resendToken) {
        ApiWrapper.showToastMessage("OTP Sent!");
        vID = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        ApiWrapper.showToastMessage("Timeout!");
      },
    );
  }*/
}
