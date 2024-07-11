// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/login_signup/verification.dart';
import 'package:goevent2/utils/botton.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:goevent2/utils/itextfield.dart';
import 'package:goevent2/utils/media.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordsetPage extends StatefulWidget {
  final String? verID;
  const PasswordsetPage({Key? key, this.verID}) : super(key: key);

  @override
  _PasswordsetPageState createState() => _PasswordsetPageState();
}

class _PasswordsetPageState extends State<PasswordsetPage> {
  late ColorNotifire notifire;
  //final auth = FirebaseAuth.instance;

  final fpassword = TextEditingController();
  final spassword = TextEditingController();
  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    notifire.setIsDark = previusstate;
    }

  @override
  void initState() {
    super.initState();
    getdarkmodepreviousstate();
  }

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
                  child: Container(
                      color: notifire.getprimerycolor,
                      child: Icon(Icons.arrow_back,
                          color: notifire.getwhitecolor)),
                ),
              ],
            ),
            SizedBox(height: height / 100),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Cambiar Contraseña".tr,
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
                      Text(
                        "con la que ahora iniciará sesión.".tr,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Customtextfild2.textField(
                fpassword,
                _obscureText,
                "Nueva contraseña".tr,
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
                "Confirmar contraseña".tr,
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
            GestureDetector(
              onTap: () {
                if (fpassword.text.isNotEmpty && spassword.text.isNotEmpty) {
                  print((fpassword.text == spassword.text));
                  if (fpassword.text == spassword.text) {
                    forgetpass(context);
                  } else {
                    ApiWrapper.showToastMessage("Contraseña no coincide");
                  }
                } else {
                  ApiWrapper.showToastMessage("¡Por favor, complete los campos requeridos!");
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
            ),
          ],
        ),
      ),
    );
  }

  //! user Login Api
  Future<void> forgetpass(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    String id = widget.verID!;
    // Llama a verificarCodigo y espera a que se complete
    print('___________________________________');
    print(id);
    print(fpassword.text);
    print(spassword.text);
    print('___________________________________');
    bool? codigoVerificado = await login.updatePassword(id, fpassword.text);

    // Verifica el resultado devuelto por verificarCodigo
    if (codigoVerificado == true) {
      // Si el código fue verificado con éxito, navega a la pantalla Login
      //Get.to(() => Login());
      ApiWrapper.showToastMessage("Contraseña actualizada exitosamente.");
    } else {
      // Si ocurrió un error o el código no fue verificado, puedes manejarlo aquí
      ApiWrapper.showToastMessage("Algo salio mal");
    }
  }
}
