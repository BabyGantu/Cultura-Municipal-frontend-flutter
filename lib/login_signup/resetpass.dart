// ignore_for_file: unnecessary_brace_in_string_interps, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Controller/AuthController.dart';
import 'package:goevent2/login_signup/verification.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/botton.dart';
import '../utils/colornotifire.dart';
import '../utils/ctextfield.dart';
import '../utils/media.dart';

class Resetpassword extends StatefulWidget {
  const Resetpassword({Key? key}) : super(key: key);

  @override
  _ResetpasswordState createState() => _ResetpasswordState();
}

class _ResetpasswordState extends State<Resetpassword> {
  late ColorNotifire notifire;
  final email = TextEditingController();
  final x = Get.put(AuthController());
  final String _selectedCountryCode = "";

  bool isLoading = false;

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    notifire.setIsDark = previusstate;
  }

  @override
  void initState() {
    super.initState();
    //_selectedCountryCode = x.countryCode.first;
    getdarkmodepreviousstate();
  }

  String? vID = "";

  

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
                    "Restore password".tr,
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
                        "Please enter your email to ".tr,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Gilroy Medium',
                            color: notifire.getwhitecolor),
                      ),
                      SizedBox(height: height / 400),
                      Text(
                        "reset your password".tr,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Gilroy Medium',
                            color: notifire.getwhitecolor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: height / 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Ink(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Customtextfild.textField(
                        controller: email,
                        name1: "Email".tr,
                        labelclr: Colors.grey,
                        textcolor: notifire.getwhitecolor,
                        prefixIcon: Image.asset("image/Message.png",
                            scale: 3.5, color: notifire.textcolor),
                        context: context,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: height / 20),
            !isLoading
                ? GestureDetector(
                    onTap: () async {
                      if (email.text.isNotEmpty) {
                        Map<String, dynamic> result =
                            await login.resetPassword(email.text);
                        if (result['success']) {
                          Get.to(() => Verification(
                              verID: result['verID'],
                              email: email.text,
                              isReset: true));
                        } else {
                          ApiWrapper.showToastMessage(
                              "The email could not be sent. Try again.".tr);
                        }
                      } else {
                        ApiWrapper.showToastMessage(
                            "Email is required!".tr);
                      }
                    },
                    child: SizedBox(
                      height: 45,
                      child: Custombutton.button1(
                        notifire.getbuttonscolor,
                        "Enviar".tr,
                        SizedBox(width: width / 3.5),
                        SizedBox(width: width / 7),
                      ),
                    ),
                  )
                : CircularProgressIndicator(color: notifire.getbuttonscolor),
          ],
        ),
      ),
    );
  }
}
