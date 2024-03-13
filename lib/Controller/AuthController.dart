// ignore_for_file: file_names, unused_local_variable, avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/Bottombar.dart';
import 'package:goevent2/home/home.dart';
import 'package:goevent2/utils/AppWidget.dart';
import '../agent_chat_screen/auth_service.dart';
import 'package:http/http.dart' as http;

import '../login_signup/ForgetPass.dart';
import '../login_signup/Login.dart';
import '../login_signup/verification.dart';


const String endpoin = 'http://10.0.2.2:8000';

class AuthController extends GetxController {
  // UserData? userData;
  var countryCode = [];

  String? uID;

  //! user CountryCode
  cCodeApi() {
    countryCode.add(['+52','+65','+56','+23','+63']);
    /**ApiWrapper.dataGet(Config.cCode).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          val["CountryCode"].forEach((e) {
            countryCode.add(e['ccode']);
          });
          update();
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });**/
  }

  //! user Login Api
  userLogin(String? email, password) {
    var data = {"mobile": email, "password": password};
    log(data.toString(), name: "Login Api : ");
    ApiWrapper.dataPost(Config.loginuser, data).then((val) {
      log(val.toString(), name: "Login Api : ");
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          save("FirstUser", true);
          save("UserLogin", val["UserLogin"]);
          print(val["UserLogin"]);
          AuthService().singInAndStoreData(email: val["UserLogin"]["email"], uid: val["UserLogin"]["id"], proPicPath: val["UserLogin"]["pro_pic"]);
          Get.to(() => const Bottombar(), duration: Duration.zero);
          update();
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }


  Future<void> registrarUsuario(String email, String name, String apellido, String celular,String password) async {
    final Uri url = Uri.parse('$endpoin/api/registro/');
    final response = await http.post(
      url,
      body: {
        'email': email,
        'nombre': name,
        'apellido': apellido,
        'celular': celular,
        'password': password
      },
    );

    if (response.statusCode == 201) {
      // Extracción del token del cuerpo de la respuesta
      final Map<String, dynamic> responseData = json.decode(response.body);
      final email = responseData['email'];
      final nombre = responseData['nombre'];
      final id = responseData['id'];
      print('--------------------------------------------------------------------------------------------------');
      print('el id es: ${id}');
      print('el email es: ${email}');
      print('el nombre es: ${nombre}');
      print('--------------------------------------------------------------------------------------------------');
      String idStrin = id.toString();
      Get.to(() => Verification(verID: idStrin, email: email, isReset: false));
      return id;
    } else {
      // Si la solicitud falla, imprime el mensaje de error
      print('Error: ${response.reasonPhrase}');
      return null;
    }
  }

  Future<bool?> reenviarCodigo(String id) async {
    final Uri url = Uri.parse('$endpoin/api/reenviar_codigo/');
    final response = await http.post(
      url,
      body: {
        'id': id
      },
    );

    if (response.statusCode == 200) {
      // Extracción del token del cuerpo de la respuesta
      final Map<String, dynamic> responseData = json.decode(response.body);
      final message = responseData['message'];
      print('--------------------------------------------------------------------------------------------------');
      print('mensaje: ${message}');
      print('--------------------------------------------------------------------------------------------------');
      return true;
    } else {
      // Si la solicitud falla, imprime el mensaje de error
      print('Error: ${response.reasonPhrase}');
      return false;
    }
  }


  Future<bool?> verificarCodigo(String codigo_verificacion, String usuario_id, bool isReseet) async {
    final Uri url = Uri.parse('$endpoin/api/verificar_codigo/');
    print('--------------------------------------------------------------------------------------------------');
    print('el codigo_verificacion recibido es: ${codigo_verificacion}');
    print('el email usuario_id es: ${usuario_id}');
    print('--------------------------------------------------------------------------------------------------');
    final response = await http.post(
      url,
      body: {
        'codigo_verificacion': codigo_verificacion,
        'usuario_id': usuario_id,
      },
    );

    if (response.statusCode == 200) {
      // Extracción del token del cuerpo de la respuesta
      final Map<String, dynamic> responseData = json.decode(response.body);
      final id = responseData['id'];
      final verificado = responseData['verificado'];
      final email = responseData['email'];
      print('--------------------------------------------------------------------------------------------------');
      print('el id es: ${id}');
      print('el email es: ${email}');
      print('Verificado: ${verificado}');
      print('--------------------------------------------------------------------------------------------------');
      if(!isReseet)
        Get.to(() => Login());
      else
        Get.to(() => PasswordsetPage(email: email));
      return true;
    } else {
      // Si la solicitud falla, imprime el mensaje de error
      print('Error: ${response.reasonPhrase}');
      return false;
    }
  }



  Future<void> iniciarSesion(String email, String password) async {
    final Uri url = Uri.parse('$endpoin/api/inicio_sesion/');
    final response = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      // Extracción del token del cuerpo de la respuesta
      final Map<String, dynamic> responseData = json.decode(response.body);
      final token = responseData['token'];
      final nombre = responseData['nombre'];
      final id = responseData['id'];
      print('el token resivido es: ${token}');
      save("FirstUser", true);
      save("UserLogin", nombre);
      print(nombre);
      Get.to(() => const Bottombar(), duration: Duration.zero);
      update();
      return token;
    } else {
      // Si la solicitud falla, imprime el mensaje de error
      print('Error: ${response.reasonPhrase}');
      return null;
    }
  }


  Future<bool> userExists(String email) async {
    final Uri url = Uri.parse('$endpoin/api/user_exists_reset_password/');
    final response = await http.post(
      url,
      body: {
        'email': email,
      },
    );

    if (response.statusCode == 200) {
      // Extracción del token del cuerpo de la respuesta
      final Map<String, dynamic> responseData = json.decode(response.body);
      final id = responseData['id'];
      print('--------------------------------------------------------------------------------------------------');
      print('el id es: ${id}');
      print('--------------------------------------------------------------------------------------------------');
      String idStrin = id.toString();
      Get.to(() => Verification(verID: idStrin, email: email, isReset: true));
      return true;
    } else {
      // Si la solicitud falla, imprime el mensaje de error
      print('Errorrrr: ${response.reasonPhrase}');
      return false;
    }
  }


  //! user Register Api
  userRegister() {
    var name = getData.read("User")["UserName"];
    var email = getData.read("User")["UserEmail"];
    var mobile = getData.read("User")["Usernumber"];
    var ccode = getData.read("User")["Ccode"];
    var password = getData.read("User")["FPassword"];
    var rcode = getData.read("User")["ReferralCode"];

    var data = {
      "name": name,
      "email": email,
      "mobile": mobile,
      "ccode": ccode,
      "password": password,
      "refercode": rcode
    };

    ApiWrapper.dataPost(Config.reguser, data).then((val) {
      print('++++++++++++++++++++---------------*****+++$val');
      if ((val != null) && (val.isNotEmpty)) {
        log(val.toString(), name: "Api Register data::");
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          save("UserLogin", val["UserLogin"]);
          AuthService().singUpAndStore(email: val["UserLogin"]["email"], uid: val["UserLogin"]["id"], proPicPath: val["UserLogin"]["pro_pic"]);
          Get.to(() => const Bottombar(), duration: Duration.zero);
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
          update();
        } else{
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }
}