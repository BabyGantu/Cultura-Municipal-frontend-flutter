// ignore_for_file: avoid_print, unused_local_variable, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:goevent2/utils/media.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<DynamicPageData> dynamicPageDataList = [];

class Loream extends StatefulWidget {
  String? title;
  Loream(this.title, {Key? key}) : super(key: key);
  @override
  State<Loream> createState() => _LoreamState();
}

class _LoreamState extends State<Loream> {
  late ColorNotifire notifire;

  String? text;

  @override
  void initState() {
    super.initState();
    getdarkmodepreviousstate();

    getWebData();
  }

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    notifire.setIsDark = previusstate;
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);

    var sp;
    return Scaffold(
      backgroundColor: notifire.backgrounde,
      body: Column(
        children: [
          SizedBox(height: height / 20),
          Row(
            children: [
              SizedBox(width: width / 40),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: notifire.textcolor),
                    SizedBox(width: width / 80),
                    Text(
                      widget.title!,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Gilroy Medium',
                          color: notifire.textcolor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: height / 30),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width / 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              "TÉRMINOS Y CONDICIONES DE USO DE LA \"APP EVSON\"",
                              style: TextStyle(
                                  color: notifire.textcolor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: height / 50,
                                  fontFamily: 'Gilroy Normal')),
                          Text(
                              "Esta aplicación ha sido diseñada y administrada por Redescubramos Sonora A.C., así mismo, los módulos "
                              "que integran está aplicación han sido diseñados para integrar información de utilidad que pueda ser consultada "
                              "desde un dispositivo móvil, como lo es información relativa eventos del estado de Sonora.\n"
                              "\nAsí mismo, los usuarios de “APP EVSON” podrán inscribir sus eventos. Cualquier persona que desee hacer uso de los "
                              "servicios que ofrece esta aplicación móvil, podrá hacerlo sujetándose a los presentes \“Términos y Condiciones de Uso\” "
                              "así como a las políticas y principios que se describen en el presente documento.\n",
                              style: TextStyle(
                                  color: notifire.textcolor,
                                  fontSize: height / 50,
                                  fontFamily: 'Gilroy Normal')),
                          Text("I. OBJETO",
                              style: TextStyle(
                                  color: notifire.textcolor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: height / 50,
                                  fontFamily: 'Gilroy Normal')),
                          Text(
                              'Este documento describe los términos y condiciones generales de uso de la aplicación móvil en adelante '
                              '"APP EVSON", misma que es aplicación para dispositivos móviles que integra en una sola aplicación el acceso '
                              'a los distintos módulos por los que está integrada; a través de los cuales, diversos usuarios pondrán a '
                              'disposición eventos a los usuarios.\n',
                              style: TextStyle(
                                  color: notifire.textcolor,
                                  fontSize: height / 50,
                                  fontFamily: 'Gilroy Normal')),
                          Text("II. ACEPTACIÓN DE LOS TÉRMINOS",
                              style: TextStyle(
                                  color: notifire.textcolor,
                                  fontSize: height / 50,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Gilroy Normal')),
                          Text(
                              'El ingreso y utilización de la aplicación "APP EVSON" implica que usted ha leído, entendido y aceptado '
                              'los presentes “Términos y Condiciones de Uso”. Y esta aplicación requerirá la autorización expresa de los '
                              'usuarios para acceder a las funciones como GPS y almacenamiento para servicios solicitados en alguno de los '
                              'módulos de la aplicación.\n',
                              style: TextStyle(
                                  color: notifire.textcolor,
                                  fontSize: height / 50,
                                  fontFamily: 'Gilroy Normal')),
                          Text(
                              'III. RESPONSABILIDAD SOBRE EL USO DE LA APLICACIÓN "APP EVSON"',
                              style: TextStyle(
                                  color: notifire.textcolor,
                                  fontSize: height / 50,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Gilroy Normal')),
                          Text(
                              'Usted asume la responsabilidad de todas las acciones que ejecute, en la utilización y consulta de la "APP EVSON", mismas que se considera que usted realiza voluntariamente. Usted no utilizará, ni permitirá que otros usuarios utilicen esta aplicación móvil o cualquier servicio prestado a través de ella, de forma contraria a lo establecido en estos “Términos y Condiciones de Uso”, así como a las disposiciones legales aplicables a los servicios que ofrece la aplicación "APP EVSON". Es responsabilidad de usted todo acto que se realice en esta aplicación móvil, por medio de su “Nombre de Usuario” y “Contraseña”; asimismo, usted se responsabiliza del cuidado y custodia de los mismos, para que esta aplicación móvil únicamente sea utilizada para los fines para los cuales ha sido diseñada, por lo que cualquier mal uso que se realice en su nombre, se presumirá realizada por usted. Usted reconoce y acepta que Redescubramos Sonora A.C. queda liberado de toda responsabilidad por el mal uso que llegara a realizarse en alguno de los módulos de la "APP EVSON".',
                              style: TextStyle(
                                  color: notifire.textcolor,
                                  fontSize: height / 50,
                                  fontFamily: 'Gilroy Normal')),
                          Text(
                              '\nComo todo desarrollo tecnológico, la "APP EVSON" es falible y estará en proceso permanente de mejora; por lo que existe la posibilidad, aunque remota, de que ocurran fallas técnicas durante su uso; por lo que el Gobierno de la Ciudad de México no garantiza que la aplicación móvil esté libre de errores; por tal motivo, usted deslinda de toda la responsabilidad a Redescubramos Sonora A.C., respondiendo de todos los daños y perjuicios derivados de las circunstancias expuestas en este párrafo.',
                              style: TextStyle(
                                  color: notifire.textcolor,
                                  fontSize: height / 50,
                                  fontFamily: 'Gilroy Normal')),
                          Text(
                              '\nRedescubramos Sonora A.C. no asumirá ninguna responsabilidad por los inconvenientes que usted pudiera experimentar con el equipo de cómputo y accesorios —hardware y software— utilizados para conectarse a esta aplicación móvil; de igual manera, tampoco asumirá responsabilidad alguna por procedimientos que hayan quedado inconclusos, por razones ajenas a las funciones de la aplicación.',
                              style: TextStyle(
                                  color: notifire.textcolor,
                                  fontSize: height / 50,
                                  fontFamily: 'Gilroy Normal')),
                          Text(
                              '\nEn ningún caso Redescubramos Sonora A.C. será responsable por las consecuencias del uso indebido o fraudulento de la "APP EVSON", cualquiera que sea la causa del eventual daño.',
                              style: TextStyle(
                                  color: notifire.textcolor,
                                  fontSize: height / 50,
                                  fontFamily: 'Gilroy Normal')),
                          Text('\nIV. CAMBIOS Y ACTUALIZACIONES DEL SERVICIO',
                              style: TextStyle(
                                  color: notifire.textcolor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: height / 50,
                                  fontFamily: 'Gilroy Normal')),
                          Text(
                              'Redescubramos Sonora A.C, tiene pleno derecho de realizar modificaciones en los contenidos que se ofrecen, ya sean temporales o permanentes, en cualquier momento; por lo tanto, no es posible garantizar la disponibilidad ni la continuidad del funcionamiento de la "APP EVSON" en todo momento o durante el tiempo de actualización. Redescubramos Sonora A.C no asume responsabilidad alguna por cualquier falla que pudiera presentarse con el uso de esta aplicación, ya sean por cambios y actualizaciones, o por cualquiera otra causa.',
                              style: TextStyle(
                                  color: notifire.textcolor,
                                  fontSize: height / 50,
                                  fontFamily: 'Gilroy Normal')),
                          Text(
                              '\nRedescubramos Sonora A.C se reserva el derecho de modificar, restringir o suprimir todos o cualquiera de los atributos de los módulos de la "APP EVSON", en forma temporal o definitiva, sin que estas medidas puedan ser objeto de requerimiento alguno, ni de derecho a reclamar daños y perjuicios por parte de usted.',
                              style: TextStyle(
                                  color: notifire.textcolor,
                                  fontSize: height / 50,
                                  fontFamily: 'Gilroy Normal')),
                          Text(
                              '\nV. POLÍTICAS DE PRIVACIDAD Y PROTECCIÓN DE DATOS PERSONALES',
                              style: TextStyle(
                                  color: notifire.textcolor,
                                  fontSize: height / 50,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Gilroy Normal')),
                          Text(
                              'El tratamiento de sus datos personales se limitará al cumplimiento de la finalidad establecida en el aviso de privacidad de la aplicación. El tratamiento de sus datos personales se limitará al cumplimiento de la finalidad establecida en el aviso de privacidad de la aplicación y se realizará de conformidad con lo establecido en la Ley de Protección de Datos Personales en Posesión de Sujetos Obligados y en los Lineamientos Generales de Protección de Datos Personales en Posesión de Sujetos Obligados.',
                              style: TextStyle(
                                  color: notifire.textcolor,
                                  fontSize: height / 50,
                                  fontFamily: 'Gilroy Normal')),
                          Text(
                              '\nLos datos requeridos en la aplicación para el registro de usuarios de la aplicación son:',
                              style: TextStyle(
                                  color: notifire.textcolor,
                                  fontSize: height / 50,
                                  fontFamily: 'Gilroy Normal')),
                          Text(
                              '\nNombre, apellidos, correo electrónico, usuario y contraseña los cuales serán necesarios para para consultar la información de eventos para la ciudadanía integrada en los distintos módulos de la plataforma contará con un mecanismo de autenticación vinculado al correo electrónico proporcionado al momento de registrarse.',
                              style: TextStyle(
                                  color: notifire.textcolor,
                                  fontSize: height / 50,
                                  fontFamily: 'Gilroy Normal')),
                          Text('\nVI. POLÍTICA DE PROPIEDAD INTELECTUAL',
                              style: TextStyle(
                                  color: notifire.textcolor,
                                  fontSize: height / 50,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Gilroy Normal')),
                          Text(
                              'La "APP EVSON" es una obra protegida por las leyes mexicanas, internacionales y tratados en materia de propiedad intelectual. El uso de la "APP EVSON", no lo convierte a usted en titular de ninguno de los derechos de propiedad intelectual del mismo, ni del contenido o información a la que acceda. Queda prohibido utilizar el nombre, la marca o el logotipo de este, así como EL DE Redescubramos Sonora A.C. Asimismo, no se podrá eliminar, ocultar ni alterar los avisos legales que se muestran en la misma. Sin perjuicio de lo anterior, usted podrá imprimirlos, copiarlos o almacenarlos, siempre y cuando sea para uso estrictamente personal.',
                              style: TextStyle(
                                  color: notifire.textcolor,
                                  fontSize: height / 50,
                                  fontFamily: 'Gilroy Normal')),
                          Text('\nVII. CONTROVERSIAS Y JURISDICCIÓN APLICABLE.',
                              style: TextStyle(
                                  color: notifire.textcolor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: height / 50,
                                  fontFamily: 'Gilroy Normal')),
                          Text(
                              'Redescubramos Sonora A.C. se reserva el derecho de presentar acciones civiles o penales cuando se advierta el uso indebido de la información contenida en "APP EVSON", o por el incumplimiento de los presentes “TÉRMINOS Y CONDICIONES DE USO”. La relación entre “Redescubramos Sonora A.C.” y los “USUARIOS” se regirá por la legislación vigente en estado de Sonora, y la que sea aplicable en el ámbito federal. En caso de existir controversia legal, las partes se sujetarán a la jurisdicción de los tribunales del estado de Sonora, conforme a la materia que corresponda.',
                              style: TextStyle(
                                  color: notifire.textcolor,
                                  fontSize: height / 50,
                                  fontFamily: 'Gilroy Normal')),
                          Text('\nVIIIA. ACEPTACIÓN DE LOS TÉRMINOS.',
                              style: TextStyle(
                                  color: notifire.textcolor,
                                  fontSize: height / 50,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Gilroy Normal')),
                          Text(
                              'El ingreso y utilización de "APP EVSON" implica que ha leído y aceptado los presentes',
                              style: TextStyle(
                                  color: notifire.textcolor,
                                  fontSize: height / 50,
                                  fontFamily: 'Gilroy Normal')),
                          Text('\n“TÉRMINOS Y CONDICIONES DE USO”.\n',
                              style: TextStyle(
                                  color: notifire.textcolor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: height / 50,
                                  fontFamily: 'Gilroy Normal')),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getWebData() {
    Map<String, dynamic> data = {};

    dynamicPageDataList.clear();
    ApiWrapper.dataPost(Config.pagelist, data).then((value) {
      if ((value != null) &&
          (value.isNotEmpty) &&
          (value['ResponseCode'] == "200")) {
        List da = value['pagelist'];
        for (int i = 0; i < da.length; i++) {
          Map<String, dynamic> mapData = da[i];
          DynamicPageData a = DynamicPageData.fromJson(mapData);
          dynamicPageDataList.add(a);
        }

        for (int i = 0; i < dynamicPageDataList.length; i++) {
          if ((widget.title == dynamicPageDataList[i].title)) {
            text = dynamicPageDataList[i].description;
            setState(() {});
            return;
          } else {
            text = "";
          }
        }
      }
    });
  }
}

class DynamicPageData {
  DynamicPageData(this.title, this.description);

  String? title;
  String? description;

  DynamicPageData.fromJson(Map<String, dynamic> json) {
    title = json["title"];
    description = json["description"];
  }

  Map<String, dynamic> toJson() {
    return {"title": title, "description": description};
  }
}
