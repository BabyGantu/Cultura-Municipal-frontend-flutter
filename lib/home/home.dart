// ignore_for_file: constant_identifier_names, non_constant_identifier_names, avoid_types_as_parameter_names, avoid_print, unused_local_variable, unused_import, unnecessary_null_comparison, prefer_final_fields, prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:goevent2/Controller/UserPreferences.dart';
import 'package:goevent2/home/Categoria.dart';

import '../Search/searchpage2.dart';
import '../utils/media.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;

import '../utils/colornotifire.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:goevent2/Api/Config.dart';
import 'package:provider/provider.dart';

import 'package:goevent2/home/seeall.dart';
import 'package:goevent2/spleshscreen.dart';
import 'package:goevent2/utils/color.dart';
import '../notification/notification.dart';
import 'package:geolocator/geolocator.dart';
import 'package:goevent2/utils/string.dart';
import 'package:like_button/like_button.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/utils/AppWidget.dart';
import 'package:goevent2/Search/SearchPage.dart';
import 'package:goevent2/home/EventDetails.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:goevent2/home/TrendingCatPage.dart';

import 'package:goevent2/Controller/AuthController.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';

const String categoriasJson = '''
{
  "categorias": [
    {
      "id": "1",
      "title": "Artes Escénicas",
      "image": "image/fire.png",
      "cover_img": "image/fire.png"
    },
    {
      "id": "2",
      "title": "Música y Conciertos",
      "image": "image/sport1.png",
      "cover_img": "image/discover.png"
    },
    {
      "id": "3",
      "title": "Festivales y Ferias",
      "image": "image/method.png",
      "cover_img": "image/discover.png"
    },
    {
      "id": "4",
      "title": "Deportes",
      "image": "image/american_express.png",
      "cover_img": "image/discover.png"
    },
    {
      "id": "5",
      "title": "Museos y Exposiciones",
      "image": "image/american_express.png",
      "cover_img": "image/discover.png"
    },
    {
      "id": "6",
      "title": "Cursos y Talleres",
      "image": "image/american_express.png",
      "cover_img": "image/discover.png"
    },
    {
      "id": "7",
      "title": "Infantiles",
      "image": "image/american_express.png",
      "cover_img": "image/discover.png"
    },
    {
      "id": "8",
      "title": "Cine",
      "image": "image/american_express.png",
      "cover_img": "image/discover.png"
    },
    {
      "id": "9",
      "title": "Congresos y Convenciones",
      "image": "image/american_express.png",
      "cover_img": "image/discover.png"
    },
    {
      "id": "10",
      "title": "Eventos Literarios",
      "image": "image/american_express.png",
      "cover_img": "image/discover.png"
    },
    {
      "id": "11",
      "title": "Recorridos",
      "image": "image/american_express.png",
      "cover_img": "image/discover.png"
    },
    {
      "id": "12",
      "title": "Pueblos originarios",
      "image": "image/american_express.png",
      "cover_img": "image/discover.png"
    }
  ]
}
''';

const String eventsJson = '''
{
  "events": [
    {
      "event_id": "1",
      "cid": "1",
      "event_title": "Evento de arte 1",
      "event_img": "image/protection.png",
      "event_address": "Calle Principal #123, Ciudad, País",
      "event_sdate": "20-04-2024",
      "IS_BOOKMARK": 1,
      "member_list": ["image/p2.png", "image/p1.png", "image/p3.png"],
      "total_member_list": 20,
      "cover_img": "image/verve.png", 
      "sponsore_list": {
        "sponsore_img": "image/p1.png",
        "sponsore_img": "image/p2.png"
      }
    },
    {
      "event_id": "2",
      "cid": "1",
      "event_title": "Evento de arte 2",
      "event_img": "image/event.png",
      "event_address": "Dirección del concierto de música",
      "event_sdate": "25-04-2024",
      "IS_BOOKMARK": 0,
      "member_list": ["image/p1.png", "image/p4.png", "image/p2.png"],
      "total_member_list": 15,
      "cover_img": "image/verve.png", 
      "sponsore_list": {
        "sponsore_img": "image/p2.png",
        "sponsore_img": "image/p1.png",
        "sponsore_img": "image/p3.png",
        "sponsore_img": "image/p4.png"
      }
    },
    {
      "event_id": "3",
      "cid": "1",
      "event_title": "Evento de arte 3",
      "event_img": "image/p10.png",
      "event_address": "Dirección del festival de cine",
      "event_sdate": "30-04-2024",
      "IS_BOOKMARK": 1,
      "member_list": ["image/p1.png", "image/p4.png", "image/p2.png"],
      "total_member_list": 30,
      "cover_img": "image/verve.png", 
      "sponsore_list": {
        "sponsore_img": "image/p3.png",
        "sponsore_img": "image/p4.png",
        "sponsore_img": "image/p1.png"
      }
    },
    {
      "event_id": "4",
      "cid": "2",
      "event_title": "Concierto de música 1",
      "event_img": "image/pay.png",
      "event_address": "Dirección de la obra de teatro",
      "event_sdate": "22-04-2024",
      "IS_BOOKMARK": 0,
      "member_list": ["image/p4.png", "image/p3.png", "image/p1.png"],
      "total_member_list": 10,
      "cover_img": "image/verve.png", 
      "sponsore_list": {
        "sponsore_img": "image/p4.png",
        "sponsore_img": "image/p2.png",
        "sponsore_img": "image/p1.png",
        "sponsore_img": "image/p3.png",
        "sponsore_img": "image/p1.png"
      }
    },
    {
      "event_id": "5",
      "cid": "2",
      "event_title": "Concierto de música 2",
      "event_img": "image/event.png",
      "event_address": "Dirección del concierto de música",
      "event_sdate": "28-04-2024",
      "IS_BOOKMARK": 0,
      "member_list": ["image/p1.png", "image/p4.png", "image/p2.png"],
      "total_member_list": 15,
      "cover_img": "image/verve.png", 
      "sponsore_list": {
        "sponsore_img": "image/p2.png",
        "sponsore_img": "image/p1.png",
        "sponsore_img": "image/p3.png",
        "sponsore_img": "image/p4.png"
      }
    },
    {
      "event_id": "6",
      "cid": "2",
      "event_title": "Concierto de música 3",
      "event_img": "image/protection.png",
      "event_address": "Dirección del concierto de música",
      "event_sdate": "02-05-2024",
      "IS_BOOKMARK": 1,
      "member_list": ["image/p1.png", "image/p2.png", "image/p3.png"],
      "total_member_list": 12,
      "cover_img": "image/verve.png", 
      "sponsore_list": {
        "sponsore_img": "image/p2.png",
        "sponsore_img": "image/p1.png",
        "sponsore_img": "image/p3.png",
        "sponsore_img": "image/p4.png"
      }
    },
    {
      "event_id": "7",
      "cid": "3",
      "event_title": "Festival de cine 1",
      "event_img": "image/pay.png",
      "event_address": "Dirección de la obra de teatro",
      "event_sdate": "18-04-2024",
      "IS_BOOKMARK": 0,
      "member_list": ["image/p4.png", "image/p3.png", "image/p1.png"],
      "total_member_list": 10,
      "cover_img": "image/verve.png", 
      "sponsore_list": {
        "sponsore_img": "image/p4.png",
        "sponsore_img": "image/p2.png",
        "sponsore_img": "image/p1.png",
        "sponsore_img": "image/p3.png",
        "sponsore_img": "image/p1.png"
      }
    },
    {
      "event_id": "8",
      "cid": "3",
      "event_title": "Festival de cine 2",
      "event_img": "image/event.png",
      "event_address": "Dirección del concierto de música",
      "event_sdate": "16-04-2024",
      "IS_BOOKMARK": 1,
      "member_list": ["image/p1.png", "image/p4.png", "image/p2.png"],
      "total_member_list": 15,
      "cover_img": "image/verve.png", 
      "sponsore_list": {
        "sponsore_img": "image/p2.png",
        "sponsore_img": "image/p1.png",
        "sponsore_img": "image/p3.png",
        "sponsore_img": "image/p4.png"
      }
    },
    {
      "event_id": "9",
      "cid": "3",
      "event_title": "Festival de cine 3",
      "event_img": "image/protection.png",
      "event_address": "Dirección del concierto de música",
      "event_sdate": "24-04-2024",
      "IS_BOOKMARK": 0,
      "member_list": ["image/p1.png", "image/p2.png", "image/p3.png"],
      "total_member_list": 12,
      "cover_img": "image/verve.png", 
      "sponsore_list": {
        "sponsore_img": "image/p2.png",
        "sponsore_img": "image/p1.png",
        "sponsore_img": "image/p3.png",
        "sponsore_img": "image/p4.png"
      }
    },
    {
      "event_id": "10",
      "cid": "4",
      "event_title": "Obra de teatro 1",
      "event_img": "image/protection.png",
      "event_address": "Dirección de la obra de teatro",
      "event_sdate": "27-04-2024",
      "IS_BOOKMARK": 0,
      "member_list": ["image/p2.png", "image/p1.png", "image/p3.png"],
      "total_member_list": 20,
      "cover_img": "image/verve.png", 
      "sponsore_list": {
        "sponsore_img": "image/p1.png",
        "sponsore_img": "image/p2.png"
      }
    },
    {
      "event_id": "11",
      "cid": "4",
      "event_title": "Obra de teatro 2",
      "event_img": "image/event.png",
      "event_address": "Dirección del concierto de música",
      "event_sdate": "29-04-2024",
      "IS_BOOKMARK": 0,
      "member_list": ["image/p1.png", "image/p4.png", "image/p2.png"],
      "total_member_list": 15,
      "cover_img": "image/verve.png", 
      "sponsore_list": {
        "sponsore_img": "image/p2.png",
        "sponsore_img": "image/p1.png",
        "sponsore_img": "image/p3.png",
        "sponsore_img": "image/p4.png"
      }
    },
    {
      "event_id": "12",
      "cid": "4",
      "event_title": "Obra de teatro 3",
      "event_img": "image/p10.png",
      "event_address": "Dirección del festival de cine",
      "event_sdate": "01-05-2024",
      "IS_BOOKMARK": 1,
      "member_list": ["image/p1.png", "image/p4.png", "image/p2.png"],
      "total_member_list": 30,
      "cover_img": "image/verve.png", 
      "sponsore_list": {
        "sponsore_img": "image/p3.png",
        "sponsore_img": "image/p4.png",
        "sponsore_img": "image/p1.png"
      }
    }
  ]
}
''';

final getData = GetStorage();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final x = Get.put(AuthController());
  //final hData = Get.put(HomeController());
  late ColorNotifire notifire;
  PackageInfo? packageInfo;
  String? appName;
  String? packageName;
  bool isChecked = false;
  String code = "0";
  //List<dynamic> categoriasList = [];
  List<Categoria> categoriasList = [];
  List<dynamic> trendingEvent = [];
  List<dynamic> upcomingEvent = [];
  List<dynamic> nearbyEvent = [];
  List<dynamic> thisMonthEvent = [];

  String? token;
  String? userId;
  String? fechaExpiracion;

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");

    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  Future<void> _loadUserData() async {
    token = await UserPreferences.getToken();
    userId = await UserPreferences.getUserId();
    fechaExpiracion = await UserPreferences.getFechaExpiracion();
    setState(
        () {}); // Actualiza la interfaz de usuario con los datos recuperados
  }

/*
  void cargarCategorias() {
    // Decodifica la cadena JSON y guarda los eventos en la lista eventosList
    Map<String, dynamic> categoriasData = json.decode(categoriasJson);
    setState(() {
      categoriasList = categoriasData['categorias'];
      // Inicializa la lista de estados de los marcadores con `false` para indicar que ningún marcador está seleccionado inicialmente
    });
  }
*/
  void cargarCategoriasApi() async {
    // URL de tu API
    String apiUrl = 'http://216.225.205.93:3000/api/categorias';

    // Realiza una solicitud GET a la API
    http.Response response = await http.get(Uri.parse(apiUrl));

    // Verifica si la solicitud fue exitosa (código de estado 200)
    if (response.statusCode == 200) {
      // Decodifica la respuesta JSON con codificación UTF-8
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      print('todo bien');

      // Asegúrate de que jsonResponse es un mapa y contiene la clave 'categorias'
      if (jsonResponse is Map && jsonResponse['categorias'] is List) {
        setState(() {
          categoriasList = jsonResponse['categorias'];
          print(categoriasList);
        });
      } else {
        print('Error: La respuesta no contiene una lista de categorías.');
      }
    } else {
      // Si la solicitud no fue exitosa, muestra un mensaje de error
      print('Error al cargar categorías: ${response.statusCode}');
    }
  }

  void cargartrendingEvent() {
    // Decodifica la cadena JSON y guarda los eventos en la lista eventosList
    Map<String, dynamic> trendingEventData = json.decode(eventsJson);
    setState(() {
      trendingEvent = trendingEventData['events'];
    });
  }

  /*
  void cargarUpcomingEvent() {
    // Decodifica la cadena JSON y guarda los eventos en la lista eventosList
    Map<String, dynamic> upcomingEventData = json.decode(eventsJson);
    setState(() {
      upcomingEvent = upcomingEventData['events'];
    });
  }
  */
  void cargarUpcomingEvent() async {
    // URL de tu API
    String apiUrl = 'http://10.0.2.2:8000/eventdata/eventos/';

    try {
      // Realiza una solicitud GET a la API
      http.Response response = await http.get(Uri.parse(apiUrl));

      // Verifica si la solicitud fue exitosa (código de estado 200)
      if (response.statusCode == 200) {
        // Decodifica la respuesta JSON con codificación UTF-8
        var jsonResponse = utf8.decode(response.bodyBytes);

        // Decodifica la cadena JSON y guarda los eventos en la lista
        List<dynamic> upcomingEventData = json.decode(jsonResponse);

        setState(() {
          upcomingEvent = upcomingEventData;
        });
      } else {
        // Si la solicitud no fue exitosa, muestra un mensaje de error
        print('Error al cargar eventos: ${response.statusCode}');
      }
    } catch (e) {
      // Captura y muestra cualquier error ocurrido durante la solicitud
      print('Error al cargar eventos: $e');
    }
  }

  void cargarThisMonthEvent() {
    // Decodifica la cadena JSON y guarda los eventos en la lista eventosList
    Map<String, dynamic> thisMonthEventData = json.decode(eventsJson);
    setState(() {
      thisMonthEvent = thisMonthEventData['events'];
    });
  }

  void cargarNearbyEvent() {
    // Decodifica la cadena JSON y guarda los eventos en la lista eventosList
    Map<String, dynamic> nearbyEventData = json.decode(eventsJson);
    setState(() {
      nearbyEvent = nearbyEventData['events'];
    });
  }

  Future<void> enviarCategoria(String nombre, String imagePath) async {
    try {
      // Cargar la imagen desde los assets y convertirla a base64
      ByteData bytes = await rootBundle.load(imagePath);
      String base64Image = base64Encode(bytes.buffer.asUint8List());

      // Preparar los datos para enviar
      Map<String, dynamic> data = {
        'nombre': nombre,
        'imagen': 'data:image/png;base64,$base64Image',
        'status_active': true,
      };

      // Convertir los datos a JSON
      String body = jsonEncode(data);

      // Token fijo
      String token =
          r'$2b$10$AwcnSzFM7yBmtmjRm1mA7.IHuZuxNZWYSsniy7swR/XXrcaTRJ.Ni'; // Reemplaza esto con tu token

      // Realizar la solicitud POST con el token en los encabezados
      final Uri url = Uri.parse('http://216.225.205.93:3000/api/categorias');
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      // Procesar la respuesta
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseData = json.decode(response.body);
        bool rta = responseData['rta'];
        if (rta) {
          print('Categoria creada correctamente: ${responseData['message']}');
          // Aquí puedes manejar la respuesta exitosa según sea necesario
        } else {
          print('Error al crear la categoría: ${responseData['message']}');
        }
      } else {
        print('Error de red: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error al enviar la categoría: $e');
    }
  }

  Future<void> cargarCategorias() async {
    CategoriaService service = CategoriaService();
    try {
      List<Categoria> categorias = await service.cargarCategoriasApi();
      setState(() {
        categoriasList = categorias;
      });

      // Imprimir los datos de las categorías cargadas
      for (var categoria in categoriasList) {
        print(
            'ID: ${categoria.id}, Nombre: ${categoria.nombre}, Imagen: ${categoria.imagen}, Activo: ${categoria.statusActive}');
      }
    } catch (e) {
      print('Error al cargar categorías: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    //walletrefar();
    getdarkmodepreviousstate();
    getUserLocation();
    //getPackage();
    /*getData.read("UserLogin") != null
        ? hData.homeDataApi(getData.read("UserLogin")["id"], lat, long)
        : null;*/
    cargarCategorias();
    //cargarCategoriasApi();
    cargartrendingEvent();
    cargarUpcomingEvent();
    cargarThisMonthEvent();
    cargarNearbyEvent();
    _loadUserData();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    OneSignal.initialize(Config.oneSignel);

    OneSignal.Notifications.addPermissionObserver((changes) {
      print("Accepted OSPermissionStateChanges : $changes");
    });
/*
    print("--------------__uID : ${getData.read("UserLogin")["id"]}");
    await OneSignal.User.addTagWithKey(
        "storeid", getData.read("UserLogin")["id"]);
        */
  }

  void getPackage() async {
    //! App details get
    packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo!.appName;
    packageName = packageInfo!.packageName;
  }

  getUserLocation() async {
    Position position = await getLatLong();

    lat = position.longitude.toString();
    long = position.latitude.toString();

    latD = position.latitude;
    longD = position.longitude;
    print('la latitud es:$latD');
    print('la longitud es:$longD');
    setState(() {});
  }

  Future<Position> getLatLong() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  //! ----- LikeButtonTapped -----
  Future<bool> onLikeButtonTapped(isLiked, eid) async {
    var data = {"eid": eid, "uid": uID};
    ApiWrapper.dataPost(Config.ebookmark, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          //hData.homeDataReffressApi(getData.read("UserLogin")["id"], lat, long);
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 0), () {
      setState(() {});
    });
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
        backgroundColor: notifire.backgrounde,
        body: Column(
          children: [
            //! ------ Home AppBar ------
            homeAppbar(),
            SizedBox(height: height / 60),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //! --------- categoriesList ---------
                    Text('Token: $token'),
                    Text('fecha Expiracion: $fechaExpiracion'),
                    Text('User ID: $userId'),
                    ElevatedButton(
                      onPressed: () {
                        enviarCategoria('Musica', 'image/fire.png');
                      },
                      child: Text('Upload Image'),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: SizedBox(
                        height: Get.height * 0.05,
                        child: ListView.builder(
                          itemCount: categoriasList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (ctx, i) {
                            return treding(categoriasList,
                                i); // Llama a la función treding con categoriasList
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.03),

                    //! ---------- upcoming Events --------

                    //upcomingEvent.isNotEmpty?
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Text("Upcoming Events".tr,
                              style: TextStyle(
                                  fontFamily: 'Gilroy Bold',
                                  color: notifire.textcolor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Get.to(
                                  () => All(
                                      title: "Upcoming Events".tr,
                                      eventList: upcomingEvent),
                                  duration: Duration.zero);
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Text("See All".tr,
                                      style: TextStyle(
                                          fontFamily: 'Gilroy Medium',
                                          color: const Color(0xff747688),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400)),
                                  const Icon(Icons.arrow_forward_ios_rounded,
                                      size: 14, color: Color(0xff747688)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //: const SizedBox(),

                    SizedBox(height: height / 60),

                    //! ----------- Upcoming Events List -------------
                    Ink(
                      //height: Get.height * 0.01,
                      height: Get.height * 0.37,
                      child: ListView.builder(
                        itemCount: min(upcomingEvent.length, 10),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, i) {
                          return events(upcomingEvent[i], i);
                        },
                      ),
                    ),
                    SizedBox(height: height / 60),
                    //! -------- This Month Event  --------
                    //thisMonthEvent.isNotEmpty?
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Text("Event This Month".tr,
                              style: TextStyle(
                                  fontFamily: 'Gilroy Bold',
                                  color: notifire.textcolor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Get.to(
                                  () => All(
                                      title: "Event This Month".tr,
                                      eventList: thisMonthEvent),
                                  duration: Duration.zero);
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Text("See All".tr,
                                      style: TextStyle(
                                          fontFamily: 'Gilroy Medium',
                                          color: const Color(0xff747688),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400)),
                                  const Icon(Icons.arrow_forward_ios_rounded,
                                      size: 14, color: Color(0xff747688)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //: const SizedBox(),
                    //! monthly event Listview   --------
                    ListView.builder(
                      itemCount: min(thisMonthEvent.length, 3),
                      padding: const EdgeInsets.only(top: 8),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, i) {
                        return monthly(thisMonthEvent, i);
                      },
                    ),
                    SizedBox(height: Get.height * 0.03),

                    SizedBox(height: height / 60),
                    //! -------- Nearby You Listview  --------
                    //nearbyEvent.isNotEmpty?
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Text(
                            "Nearby You".tr,
                            style: TextStyle(
                                fontFamily: 'Gilroy Bold',
                                color: notifire.textcolor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Get.to(
                                  () => All(
                                      title: "Nearby You".tr,
                                      eventList: nearbyEvent),
                                  duration: Duration.zero);
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Text("See All".tr,
                                      style: TextStyle(
                                          fontFamily: 'Gilroy Medium',
                                          color: const Color(0xff747688),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400)),
                                  const Icon(Icons.arrow_forward_ios_rounded,
                                      size: 14, color: Color(0xff747688)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //: const SizedBox(),
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: min(nearbyEvent.length, 3),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, i) {
                        return conference(nearbyEvent, i);
                      },
                    ),
                    SizedBox(height: Get.height * 0.03),

                    //! --------- trndingList ---------
                    //trendingEvent.isNotEmpty?
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Text("Trending Events".tr,
                              style: TextStyle(
                                  fontFamily: 'Gilroy Bold',
                                  color: notifire.textcolor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Get.to(
                                  () => All(
                                      title: "Trending Events".tr,
                                      eventList: trendingEvent),
                                  duration: Duration.zero);
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Text("See All".tr,
                                      style: TextStyle(
                                          fontFamily: 'Gilroy Medium',
                                          color: const Color(0xff747688),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400)),
                                  const Icon(Icons.arrow_forward_ios_rounded,
                                      size: 14, color: Color(0xff747688)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //: const SizedBox(),
                    SizedBox(height: Get.height * 0.03),
                    //! --------- trndingList ---------
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: SizedBox(
                        height: Get.height * 0.28,
                        child: ListView.builder(
                          itemCount: min(trendingEvent.length, 6),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (ctx, i) {
                            return tredingEvents(trendingEvent, i);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.03),

                    SizedBox(height: height / 60),

                    //! --------- invite share -----------
                    InkWell(
                      onTap: share,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: notifire.isDark
                                  ? notifire.containercolore
                                  : Color(0xffd6feff),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          height: height / 6,
                          width: double.infinity,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Invite your friends".tr,
                                      // .trPluralParams(),
                                      style: TextStyle(
                                          fontFamily: 'Gilroy Medium',
                                          color: notifire.textcolor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(height: Get.height * 0.01),
                                    /*
                                    Text(
                                      "Get \$20 for ticket".tr,
                                      style: TextStyle(
                                          fontFamily: 'Gilroy Medium',
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                     */
                                    SizedBox(height: Get.height * 0.01),
                                    GestureDetector(
                                      child: Container(
                                        height: height / 30,
                                        width: width / 6,
                                        decoration: BoxDecoration(
                                            color: notifire.getbluecolor,
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: Center(
                                          child: Text(
                                            "INVITE".tr,
                                            style: TextStyle(
                                                fontFamily: 'Gilroy Medium',
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Image.asset("image/invite.png",
                                  height: height / 6),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height / 60),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Widget treding(List<Categoria> catList, int i) {
    Uint8List decodedbytes = base64.decode(catList[i].imagen);
    return InkWell(
      onTap: () {
        //Get.to(() => TrndingPage(catdata: catList[i]));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Container(
          decoration: BoxDecoration(
            color: notifire.backgrounde,
            border: Border.all(color: notifire.bordercolore, width: 0.5),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 4, right: 8, bottom: 10),
            child: Row(
              children: [
                Image.memory(
                        base64Decode(catList[i].imagen.split(',')[1]),
                        height: 30,
                      ),
                     
                SizedBox(width: Get.width * 0.02),
                Text(
                  catList[i].nombre,
                  style: TextStyle(
                    fontFamily: 'Gilroy Medium',
                    color: notifire.textcolor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

/*
  treding(catList, i) {
    return InkWell(
      onTap: () {
        Get.to(() => TrndingPage(catdata: catList[i]));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Container(
          decoration: BoxDecoration(
              color: notifire.getprimerycolor,
              border: Border.all(color: notifire.bordercolore, width: 0.5),
              borderRadius: BorderRadius.circular(25)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4, right: 8),
            child: Row(
              children: [
                Image(
                    image:
                        NetworkImage(Config.base_url + catList[i]["cat_img"]),
                    height: 30),
                SizedBox(width: Get.width * 0.02),
                Text(catList[i]["title"],
                    style: TextStyle(
                        fontFamily: 'Gilroy Medium',
                        color: notifire.textcolor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }

 */

  /*
  imgloading() {
    return Container(
      height: Get.height * 0.20,
      width: Get.width * 0.62,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
              image: AssetImage("image/skeleton.gif"), fit: BoxFit.fill)),
    );
  }

   */

  tredingEvents(tEvent, i) {
    return InkWell(
      onTap: () {
        Get.to(() => EventsDetails(eid: tEvent[i]["event_id"]),
            duration: Duration.zero);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SizedBox(
          width: Get.width * 0.60,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: SizedBox(
                  height: Get.height * 0.20,
                  width: Get.width * 0.62,
                  child: Image.asset(
                    tEvent[i]["event_img"], // Ruta de la imagen en assets
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: Get.width * 0.02,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100 / 2),
                  child: BackdropFilter(
                    blendMode: BlendMode.srcIn,
                    filter: ImageFilter.blur(
                      sigmaX: 10, // mess with this to update blur
                      sigmaY: 10,
                    ),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: LikeButton(
                          onTap: (val) {
                            return onLikeButtonTapped(
                                val, tEvent[i]["event_id"]);
                          },
                          likeBuilder: (bool isLiked) {
                            return tEvent[i]["IS_BOOKMARK"] != 0
                                ? const Icon(Icons.favorite,
                                    color: Color(0xffF0635A), size: 22)
                                : const Icon(Icons.favorite_border,
                                    color: Color(0xffF0635A), size: 22);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: Get.height * 0.15,
                  width: Get.width * 0.58,
                  decoration: BoxDecoration(
                    color: notifire.getprimerycolor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: notifire.bordercolore),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: Get.height * 0.01),
                        Ink(
                          width: Get.width * 0.50,
                          child: Text(
                            tEvent[i]["event_title"],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Gilroy Medium',
                              color: notifire.textcolor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: Get.height * 0.006),
                        Expanded(
                          child: Row(
                            children: [
                              Image.asset("image/location.png",
                                  height: height / 50),
                              SizedBox(width: Get.width * 0.01),
                              Ink(
                                width: Get.width * 0.45,
                                child: Text(
                                  tEvent[i]["event_address"],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Gilroy Medium',
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //SizedBox(height: Get.height * 0.001),
                        Expanded(
                          child: Row(
                            children: [
                              tEvent[i]["sponsore_list"] != null
                                  ? CircleAvatar(
                                      radius: 16.0,
                                      backgroundImage: AssetImage(tEvent[i]
                                          ["sponsore_list"]["sponsore_img"]),
                                      backgroundColor: Colors.transparent,
                                    )
                                  : const SizedBox(),
                              SizedBox(width: Get.width * 0.01),
                              Text(
                                "Organizer".tr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Gilroy Medium',
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),

                              //Spacer(),
                              /*
                            Container(
                              height: Get.height * 0.04,
                              width: Get.width * 0.20,
                              decoration: BoxDecoration(
                                color: buttonColor.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "Join".tr,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Gilroy Bold',
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            */
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  homeAppbar() {
    return Container(
      decoration: BoxDecoration(
          color: notifire.homecontainercolore,
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(30),
              bottomLeft: Radius.circular(30))),
      height: Get.height * 0.18,
      child: Column(
        children: [
          SizedBox(height: Get.height * 0.055),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Container(
                  height: Get.height * 0.06,
                  color: Colors.transparent,
                  child: Padding(
                      padding: const EdgeInsets.all(7),
                      child: Image.asset("image/logo.png")),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Current Location".tr,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Gilroy Medium',
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        getData.read("CurentAdd") ?? "",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Gilroy Medium',
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    //! ------ Notification Page -----
                    Get.to(() => const Note(), duration: Duration.zero);
                  },
                  child: Image.asset("image/bell.png", height: height / 20),
                ),
              ],
            ),
          ),
          SizedBox(height: Get.height * 0.015),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: InkWell(
              onTap: () {
                Get.to(() => const SearchPage2());
              },
              child: Row(
                children: [
                  Image.asset("image/search.png", height: height / 30),
                  SizedBox(width: width / 90),
                  Container(width: 1, height: height / 40, color: Colors.grey),
                  SizedBox(width: width / 90),
                  //! ------ Search TextField -------
                  Text(
                    "Search...".tr,
                    style: TextStyle(
                        fontFamily: 'Gilroy Medium',
                        color: const Color(0xffd2d2db),
                        fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _mImages = [];

  Widget monthly(mEvent, i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GestureDetector(
        onTap: () {
          Get.to(() => EventsDetails(eid: mEvent[i]["event_id"]),
              duration: Duration.zero);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
              color: notifire.containercolore,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: notifire.bordercolore)),
          height: height / 7,
          width: width,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 6, bottom: 5, top: 5),
            child: Row(children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: SizedBox(
                  width: width / 5,
                  height: height / 8,
                  child: Image.asset(
                    mEvent[i]["event_img"],
                    fit: BoxFit.cover,
                  ),
                ),
                /*
                child: SizedBox(
                  width: width / 5,
                  height: height / 8,
                  child: FadeInImage.assetNetwork(
                      fadeInCurve: Curves.easeInCirc,
                      placeholder: "image/skeleton.gif",
                      fit: BoxFit.cover,
                      image: Config.base_url + nearby[i]["event_img"]),
                ),
                 */
              ),
              Column(children: [
                SizedBox(height: height / 500),
                Row(
                  children: [
                    SizedBox(width: width / 50),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: Get.width * 0.35,
                                child: Text(
                                  mEvent[i]["event_sdate"],
                                  style: const TextStyle(
                                      fontFamily: 'Gilroy Medium',
                                      color: Color(0xff4A43EC),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(width: width * 0.21),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100 / 2),
                                child: BackdropFilter(
                                  blendMode: BlendMode.srcIn,
                                  filter: ImageFilter.blur(
                                    sigmaX: 10, // mess with this to update blur
                                    sigmaY: 10,
                                  ),
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor:
                                        Colors.grey.withOpacity(0.2),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 3),
                                      child: LikeButton(
                                        onTap: (val) {
                                          return onLikeButtonTapped(
                                              val, mEvent[i]["event_id"]);
                                        },
                                        likeBuilder: (bool isLiked) {
                                          return mEvent[i]["IS_BOOKMARK"] != 0
                                              ? const Icon(Icons.favorite,
                                                  color: Color(0xffF0635A),
                                                  size: 22)
                                              : const Icon(
                                                  Icons.favorite_border,
                                                  color: Color(0xffF0635A),
                                                  size: 22);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: Get.width * 0.55,
                            child: Text(mEvent[i]["event_title"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'Gilroy Medium',
                                    color: notifire.textcolor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          ),
                          SizedBox(height: height / 300),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "image/location.png",
                                  height: height / 50,
                                ),
                                SizedBox(width: Get.width * 0.01),
                                SizedBox(
                                  width: Get.width * 0.56,
                                  child: Text(
                                    mEvent[i]["event_address"],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'Gilroy Medium',
                                        color: Colors.grey,
                                        fontSize: 10),
                                  ),
                                ),
                              ]),
                        ]),
                  ],
                ),
              ])
            ]),
          ),
        ),
      ),
    );
  }

  Widget rights(se, name1, name, img, txtcolor, ce) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(img, height: height / 15),
        SizedBox(width: width / 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name1,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Gilroy Bold',
                  color: txtcolor),
            ),
            Text(
              name,
              style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'Gilroy Normal',
                  color: Colors.grey),
            ),
          ],
        ),
        se,
        ce
      ],
    );
  }

  Widget conference(nearby, i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GestureDetector(
        onTap: () {
          Get.to(() => EventsDetails(eid: nearby[i]["event_id"]),
              duration: Duration.zero);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
              color: notifire.containercolore,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: notifire.bordercolore)),
          height: height / 7,
          width: width,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 6, bottom: 5, top: 5),
            child: Row(children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: SizedBox(
                  width: width / 5,
                  height: height / 8,
                  child: Image.asset(
                    nearby[i]["event_img"],
                    fit: BoxFit.cover,
                  ),
                ),
                /*
                child: SizedBox(
                  width: width / 5,
                  height: height / 8,
                  child: FadeInImage.assetNetwork(
                      fadeInCurve: Curves.easeInCirc,
                      placeholder: "image/skeleton.gif",
                      fit: BoxFit.cover,
                      image: Config.base_url + nearby[i]["event_img"]),
                ),
                 */
              ),
              Column(children: [
                SizedBox(height: height / 500),
                Row(
                  children: [
                    SizedBox(width: width / 50),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: Get.width * 0.35,
                                child: Text(
                                  nearby[i]["event_sdate"],
                                  style: const TextStyle(
                                      fontFamily: 'Gilroy Medium',
                                      color: Color(0xff4A43EC),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(width: width * 0.21),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100 / 2),
                                child: BackdropFilter(
                                  blendMode: BlendMode.srcIn,
                                  filter: ImageFilter.blur(
                                    sigmaX: 10, // mess with this to update blur
                                    sigmaY: 10,
                                  ),
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor:
                                        Colors.grey.withOpacity(0.2),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 3),
                                      child: LikeButton(
                                        onTap: (val) {
                                          return onLikeButtonTapped(
                                              val, nearby[i]["event_id"]);
                                        },
                                        likeBuilder: (bool isLiked) {
                                          return nearby[i]["IS_BOOKMARK"] != 0
                                              ? const Icon(Icons.favorite,
                                                  color: Color(0xffF0635A),
                                                  size: 22)
                                              : const Icon(
                                                  Icons.favorite_border,
                                                  color: Color(0xffF0635A),
                                                  size: 22);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: Get.width * 0.55,
                            child: Text(nearby[i]["event_title"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'Gilroy Medium',
                                    color: notifire.textcolor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          ),
                          SizedBox(height: height / 300),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "image/location.png",
                                  height: height / 50,
                                ),
                                SizedBox(width: Get.width * 0.01),
                                SizedBox(
                                  width: Get.width * 0.56,
                                  child: Text(
                                    nearby[i]["event_address"],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'Gilroy Medium',
                                        color: Colors.grey,
                                        fontSize: 10),
                                  ),
                                ),
                              ]),
                        ]),
                  ],
                ),
              ])
            ]),
          ),
        ),
      ),
    );
  }

  List<String> upMember = [];
  Widget events(upEvent, i) {
    /*
    upMember.clear();
    upEvent["member_list"].forEach((e) {
      upMember.add(Config.base_url + e);
    });

    int membercount = int.parse(upEvent["total_member_list"].toString()) > 3
        ? 3
        : int.parse(upEvent["total_member_list"].toString());
        */
    /*
    for (var i = 0; i < membercount; i++) {
      upMember.add(Config.userImage);
    }

     */
    return Stack(children: [
      InkWell(
        onTap: () {
          Get.to(() => EventsDetails(eid: upEvent["id"].toString()),
              duration: Duration.zero);
        },
        child: Container(
          color: Colors.transparent,
          width: width / 1.55,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: notifire.bordercolore),
                  borderRadius: BorderRadius.circular(17)),
              child: Stack(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: height / 5.5,
                      width: width / 1.7,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Stack(
                        children: [
                          //! Event Image
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),

                            /*
                            child: SizedBox(
                              height: Get.height * 0.20,
                              width: Get.width * 0.62,
                              child: FadeInImage.assetNetwork(
                                  fadeInCurve: Curves.easeInCirc,
                                  placeholder: "image/skeleton.gif",
                                  fit: BoxFit.cover,
                                  image:
                                  Config.base_url + upEvent["event_img"]),
                            ),

                             */
                            child: SizedBox(
                              height: Get.height * 0.20,
                              width: Get.width * 0.62,
                              child: Image.network(
                                upEvent["event_img"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          Column(
                            children: [
                              SizedBox(height: height / 70),
                              Row(
                                children: [
                                  SizedBox(width: width / 70),
                                  const Spacer(),
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(100 / 2),
                                    child: BackdropFilter(
                                      blendMode: BlendMode.srcIn,
                                      filter: ImageFilter.blur(
                                        sigmaX:
                                            10, // mess with this to update blur
                                        sigmaY: 10,
                                      ),
                                      child: CircleAvatar(
                                        radius: 18,
                                        backgroundColor: Colors.transparent,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 3),
                                          child: LikeButton(
                                            onTap: (val) {
                                              return onLikeButtonTapped(
                                                  val, upEvent["id"]);
                                            },
                                            likeBuilder: (bool isLiked) {
                                              return upEvent["is_bookmark"] != 0
                                                  ? const Icon(Icons.favorite,
                                                      color: Color(0xffF0635A),
                                                      size: 22)
                                                  : const Icon(
                                                      Icons.favorite_border,
                                                      color: Color(0xffF0635A),
                                                      size: 22);
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: width / 50),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height / 50),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      width: Get.width,
                      child: Text(
                        upEvent["event_title"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'Gilroy Medium',
                            color: notifire.textcolor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    /*
                    SizedBox(height: height / 140),
                    upEvent["total_member_list"] != "0"
                        ? Row(
                            children: [
                              (upEvent["total_member_list"] != "0" &&
                                      upMember.isNotEmpty)
                                  ? FlutterImageStack(
                                      totalCount: 0,
                                      itemRadius: 30,
                                      itemBorderWidth: 1.5,
                                      imageList: upMember)
                                  : const Image(
                                      image: AssetImage("image/user.png"),
                                      height: 28),
                              SizedBox(width: Get.width * 0.01),
                              Text(
                                "${upEvent["total_member_list"]} + Going",
                                style: TextStyle(
                                    color: const Color(0xff5d56f3),
                                    fontSize: 11,
                                    fontFamily: 'Gilroy Bold'),
                              ),
                            ],
                          )
                        : const SizedBox(),
                        */
                    SizedBox(height: height / 80),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Row(
                        children: [
                          Image.asset("image/location.png",
                              height: height / 50),
                          SizedBox(width: Get.width * 0.01),
                          SizedBox(
                            width: Get.width * 0.49,
                            child: Text(
                              upEvent["event_address"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: 'Gilroy Medium',
                                  color: Colors.grey,
                                  fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: height / 6),
                    Row(children: [
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                            color: notifire.getprimerycolor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        height: height / 30,
                        width: Get.width / 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: Get.width / 4,
                              child: Center(
                                child: Text(
                                  upEvent["start_date"],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: const Color(0xffF0635A),
                                      fontSize: 11,
                                      fontFamily: 'Gilroy ExtraBold',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    ]);
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Evson App',
        text:
            '¡Descubre todo lo que la cultura local tiene para ofrecer con la aplicación oficial de Evson! Descárgala ahora y únete a nosotros para celebrar la riqueza y diversidad cultural de nuestra comunidad.',
        linkUrl: 'https://play.google.com/store/apps/details?id=$packageName',
        chooserTitle: 'Compartir Evson');
  }

/*
  walletrefar() async {
    var data = {"uid": uID};

    ApiWrapper.dataPost(Config.refardata, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          setState(() {});
          code = val["code"];
        } else {
          setState(() {});
        }
      }
    });
  }
  */

/*
  tredingEvents(tEvent, i) {
    return InkWell(
      onTap: () {
        //Get.to(() => EventsDetails(eid: tEvent[i]["event_id"]), duration: Duration.zero);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SizedBox(
          width: Get.width * 0.60,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: SizedBox(
                  height: Get.height * 0.20,
                  width: Get.width * 0.62,
                  child: FadeInImage.assetNetwork(
                      fadeInCurve: Curves.easeInCirc,
                      placeholder: "image/skeleton.gif",
                      fit: BoxFit.cover,
                      image: Config.base_url + tEvent[i]["event_img"]),
                ),
              ),
              Positioned(
                top: 8,
                right: Get.width * 0.02,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100/2),
                  child: BackdropFilter(
                    blendMode: BlendMode.srcIn,
                    filter: ImageFilter.blur(
                      sigmaX: 10, // mess with this to update blur
                      sigmaY: 10,
                    ),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: LikeButton(
                          onTap: (val) {
                            return onLikeButtonTapped(val, tEvent[i]["event_id"]);
                          },
                          likeBuilder: (bool isLiked) {
                            return tEvent[i]["IS_BOOKMARK"] != 0
                                ? const Icon(Icons.favorite,
                                color: Color(0xffF0635A), size: 22)
                                : const Icon(Icons.favorite_border,
                                color: Color(0xffF0635A), size: 22);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: Get.height * 0.12,
                    width: Get.width * 0.56,
                    decoration: BoxDecoration(
                        color: notifire.getprimerycolor,
                        borderRadius: BorderRadius.circular(16)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          border: Border.all(color: notifire.bordercolore),
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: Get.height * 0.01),
                          Ink(
                            width: Get.width * 0.50,
                            child: Text(tEvent[i]["event_title"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'Gilroy Medium',
                                    color: notifire.textcolor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600)),
                          ),
                          SizedBox(height: Get.height * 0.006),
                          Row(
                            children: [
                              Image.asset("image/location.png",
                                  height: height / 50),
                              SizedBox(width: Get.width * 0.01),
                              Ink(
                                width: Get.width * 0.45,
                                child: Text(tEvent[i]["event_address"],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'Gilroy Medium',
                                        color: Colors.grey,
                                        fontSize: 14)),
                              ),
                            ],
                          ),
                          SizedBox(height: Get.height * 0.008),
                          Row(
                            children: [
                              tEvent[i]["sponsore_list"] != null
                                  ? CircleAvatar(
                                radius: 16.0,
                                backgroundImage: NetworkImage(
                                    Config.base_url +
                                        tEvent[i]["sponsore_list"]
                                        ["sponsore_img"]),
                                backgroundColor: Colors.transparent,
                              )
                                  : const SizedBox(),
                              SizedBox(width: Get.width * 0.01),
                              Text(
                                "Sponser".tr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'Gilroy Medium',
                                    color: Colors.grey,
                                    fontSize: 14),
                              ),
                              const Spacer(),
                              Container(
                                height: Get.height * 0.04,
                                width: Get.width * 0.20,
                                decoration: BoxDecoration(
                                    color: buttonColor.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    "Join".tr,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'Gilroy Bold',
                                        color: Colors.white,
                                        fontSize: 14),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

 */
}

/*
              child: SingleChildScrollView(
                child: !hData.isLoading
                    ? Column(
                        children: [
                          SizedBox(height: height / 60),
                          //! ----- trending Event List ------
                          SizedBox(height: height / 80),
                          hData.catlist.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: SizedBox(
                                    height: Get.height * 0.05,
                                    child: ListView.builder(
                                      itemCount: hData.homeDataList["Catlist"].length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (ctx, i) {
                                        var catlist = hData.homeDataList["Catlist"];
                                        return treding(catlist, i);
                                      },
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          SizedBox(height: Get.height * 0.03),
                          hData.trendingEvent.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Row(
                                    children: [
                                      Text("Trending Events".tr,style: TextStyle(fontFamily: 'Gilroy Bold', color: notifire.textcolor, fontSize: 16, fontWeight: FontWeight.w600)),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(
                                              () => All(title: "Trending Events".tr, eventList: hData.trendingEvent), duration: Duration.zero);
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Row(
                                            children: [
                                              Text("See All".tr,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Gilroy Medium',
                                                      color: const Color(
                                                          0xff747688),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400)),
                                              const Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  size: 14,
                                                  color: Color(0xff747688)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                          SizedBox(height: Get.height * 0.03),
                          //! --------- trndingList ---------
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: SizedBox(
                              height: Get.height * 0.28,
                              child: ListView.builder(
                                itemCount: hData.trendingEvent.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (ctx, i) {
                                  return tredingEvents(hData.trendingEvent, i);
                                },
                              ),
                            ),
                          ),

                          SizedBox(height: height / 60),
                          //! ---------- upcoming Events --------

                          hData.upcomingEvent.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Row(
                                    children: [
                                      Text("Upcoming Events".tr,
                                          style: TextStyle(
                                              fontFamily: 'Gilroy Bold',
                                              color: notifire.textcolor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600)),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(
                                              () => All(
                                                  title: "Upcoming Events".tr,
                                                  eventList:
                                                      hData.upcomingEvent),
                                              duration: Duration.zero);
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Row(
                                            children: [
                                              Text("See All".tr,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Gilroy Medium',
                                                      color: const Color(
                                                          0xff747688),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              const Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  size: 14,
                                                  color: Color(0xff747688)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),

                          SizedBox(height: height / 60),

                          //! ----------- Upcoming Events List -------------
                          Ink(
                            height: Get.height * 0.37,
                            child: ListView.builder(
                              itemCount: hData.upcomingEvent.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (ctx, i) {
                                return events(hData.upcomingEvent[i], i);
                              },
                            ),
                          ),

                          SizedBox(height: height / 60),
                          //! --------- invite share -----------
                          InkWell(
                            onTap: share,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: notifire.isDark ? notifire.containercolore : Color(0xffd6feff),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                height: height / 6,
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Invite your friends".tr,
                                            // .trPluralParams(),
                                            style: TextStyle(
                                                fontFamily: 'Gilroy Medium',
                                                color: notifire.textcolor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          SizedBox(height: Get.height * 0.01),
                                          Text(
                                            "Get \$20 for ticket".tr,
                                            style: TextStyle(
                                                fontFamily: 'Gilroy Medium',
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(height: Get.height * 0.01),
                                          GestureDetector(
                                            child: Container(
                                              height: height / 30,
                                              width: width / 6,
                                              decoration: BoxDecoration(
                                                  color: notifire.getbluecolor,
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              child: Center(
                                                child: Text(
                                                  "INVITE".tr,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Gilroy Medium',
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Image.asset("image/invite.png",
                                        height: height / 6),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: height / 60),
                          //! -------- Nearby You Listview  --------
                          hData.nearbyEvent.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Nearby You".tr,
                                        style: TextStyle(
                                            fontFamily: 'Gilroy Bold',
                                            color: notifire.textcolor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(
                                              () => All(
                                                  title: "Nearby You".tr,
                                                  eventList: hData.nearbyEvent),
                                              duration: Duration.zero);
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Row(
                                            children: [
                                              Text("See All".tr,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Gilroy Medium',
                                                      color: const Color(
                                                          0xff747688),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              const Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  size: 14,
                                                  color: Color(0xff747688)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: hData.nearbyEvent.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, i) {
                              return conference(hData.nearbyEvent, i);
                            },
                          ),
                          hData.thisMonthEvent.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Row(
                                    children: [
                                      Text("Event This Month".tr,
                                          style: TextStyle(
                                              fontFamily: 'Gilroy Bold',
                                              color: notifire.getdarkscolor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600)),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(
                                              () => All(
                                                  title: "Event This Month".tr,
                                                  eventList:
                                                      hData.thisMonthEvent),
                                              duration: Duration.zero);
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Row(
                                            children: [
                                              Text("See All".tr,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Gilroy Medium',
                                                      color: const Color(
                                                          0xff747688),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              const Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  size: 14,
                                                  color: Color(0xff747688)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                          //! monthly event
                          ListView.builder(
                            itemCount: hData.thisMonthEvent.length,
                            padding: const EdgeInsets.only(top: 8),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, i) {
                              return monthly(hData.thisMonthEvent, i);
                            },
                          ),
                        ],
                      )
                    : isLoadingCircular(),
              ),

 */
