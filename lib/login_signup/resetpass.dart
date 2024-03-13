// ignore_for_file: unnecessary_brace_in_string_interps, deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
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
  String? _selectedCountryCode = "";

  bool isLoading = false;

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  @override
  void initState() {
    super.initState();
    //_selectedCountryCode = x.countryCode.first;
    getdarkmodepreviousstate();
  }

  String? vID = "";

  verifyEmail(String email) async {
    bool? exist = await login.userExists(email);
    if (!exist) {
    ApiWrapper.showToastMessage("Usuario no encontrado");
    }
  }
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
                  child: Icon(Icons.arrow_back,
                      color: notifire.getwhitecolor),
                ),
              ],
            ),
            SizedBox(height: height / 100),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Restablecer contraseña".tr,
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
                        "Por favor, Ingrese su correo electrónico para".tr,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Gilroy Medium',
                            color: notifire.getwhitecolor),
                      ),
                      SizedBox(height: height / 400),
                      Text(
                        "restablecer su contraseña".tr,
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
                    const SizedBox(width: 8,),
                    Expanded(
                     child: Customtextfild.textField(controller: email, name1: "Email".tr, labelclr: Colors.grey, textcolor: notifire.getwhitecolor, prefixIcon: Image.asset("image/Message.png", scale: 3.5,color: notifire.textcolor), context: context,),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: height / 20),
            !isLoading
                ? GestureDetector(
                    onTap: () {
                      if (email.text.isNotEmpty) {
                        verifyEmail(email.text);
                      } else {
                        ApiWrapper.showToastMessage(
                            "¡Se requiere el correo electrónico!");
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
