// ignore_for_file: file_names, avoid_print, prefer_const_constructors, prefer_is_empty, prefer_collection_literals

import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';
import 'package:goevent2/home/EventDetails.dart';
import 'package:goevent2/spleshscreen.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:goevent2/utils/media.dart';
import 'package:latlong2/latlong.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_map/flutter_map.dart';


const String eventosJson = '''
{
  "eventos": [
    {
      "id": "1",
      "latitud": 27.495248234833745,
      "longitud": -109.9470934931631,
      "imagen": "image/event.png",
      "fecha": "2024-03-20",
      "titulo": "Concierto en el Parque",
      "direccion": "Calle Principal #123, Ciudad, País"
    },
    {
      "id": "2",
      "latitud": 27.483391313852678,
      "longitud": -109.92820066731134,
      "imagen": "image/p10.png",
      "fecha": "2024-04-10",
      "titulo": "Festival de Arte",
      "direccion": "Avenida Central #456, Ciudad, País"
    },
    {
      "id": "3",
      "latitud": 27.47062003073426,
      "longitud": -109.92950991433156,
      "imagen": "image/logo.png",
      "fecha": "2024-05-15",
      "titulo": "Carrera 5k Solidaria",
      "direccion": "Plaza de la Constitución, Ciudad, País"
    },
    {
      "id": "4",
      "latitud": 27.496513339729418,
      "longitud": -109.96466535485848,
      "imagen": "image/protection.png",
      "fecha": "2024-05-15",
      "titulo": "Trote 10k Marrano",
      "direccion": "Plaza de la Constitución, Ciudad, País"
    }
  ]
}
''';




//! Done
class SearchPage extends StatefulWidget {
  final String? type;
  const SearchPage({Key? key, this.type}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late ColorNotifire notifire;

  List eventAllList = [];
  bool isLoading = false;
  bool isTapped = false;
  List<dynamic> eventosList = []; // Lista para almacenar los eventos
  List<bool> isMarkerTappedList = []; // Lista para mantener el estado de cada marcador
  dynamic selectedConference;






/*
  final MapController controller = MapController.customLayer(
    initPosition: GeoPoint(
      latitude: 47.4358055,
      longitude: 8.4737324,
    ),
    customTile: CustomTile(
      sourceName: "opentopomap",
      tileExtension: ".png",
      minZoomLevel: 2,
      maxZoomLevel: 19,
      urlsServers: [
        TileURLs(
          url: "https://tile.opentopomap.org/",
          subdomains: [],
        )
      ],
      tileSize: 256,

    ),
  );

  final MapController _mapController = MapController(
    initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
  );

 */




  @override
  void initState() {
    super.initState();
    //controller.dispose();
    //_mapController.dispose();
    eventSearchApi("a");
    cargarEventos();
    getdarkmodepreviousstate();
  }

  void cargarEventos() {
    // Decodifica la cadena JSON y guarda los eventos en la lista eventosList
    Map<String, dynamic> eventosData = json.decode(eventosJson);
    setState(() {
      eventosList = eventosData['eventos'];
      // Inicializa la lista de estados de los marcadores con `false` para indicar que ningún marcador está seleccionado inicialmente
      isMarkerTappedList = List.generate(eventosList.length, (index) => false);
    });
  }

  // Método para cambiar el estado de selección de un marcador
  void toggleMarkerSelection(int index) {
    setState(() {
      // Cambia el estado de selección del marcador en el índice dado
      isMarkerTappedList[index] = !isMarkerTappedList[index];
      // Si se selecciona este marcador, deselecciona todos los demás
      if (isMarkerTappedList[index]) {
        isMarkerTappedList = List.generate(isMarkerTappedList.length, (idx) => idx == index);
      }
    });
  }

  // Función para mostrar la conferencia seleccionada
  Widget showSelectedConference() {
    if (selectedConference != null) {
      return conference(selectedConference);
    } else {
      return Container(); // En caso de que no haya conferencia seleccionada
    }
  }

  eventSearchApi(String? val) {
    isLoading = true;
    setState(() {});
    var data = {"title": val, "uid": uID};
    print(data);
    ApiWrapper.dataPost(Config.eventSearch, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          eventAllList = val["SearchData"];
          //getmarkers();
          isLoading = false;
          setState(() {});
          log(val.toString(), name: " Event Search Api :: ");
        } else {
          isLoading = false;
          setState(() {});
          // ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 0), () => setState(() {}));
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
        backgroundColor: notifire.backgrounde,
        body: Column(
          children: [
            Container(
              height: Get.height * 0.15,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: notifire.gettopcolor,
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 08),
                child: Column(
                  children: [
                    SizedBox(height: Get.height * 0.05),
                    Padding(
                      padding: EdgeInsets.only(left: Get.width * 0.04),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.type == "0"
                              ? InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: const Icon(Icons.arrow_back,
                                      color: Colors.white, size: 26),
                                )
                              : const SizedBox(),
                          Text(
                            "Buscar evento".tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Gilroy Medium',
                            ),
                          ),
                          const SizedBox()
                        ],
                      ),
                    ),
                    SizedBox(height: Get.height * 0.008),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Image.asset("image/search.png", height: height / 30),
                          SizedBox(width: width / 90),
                          Container(
                              width: 1,
                              height: height / 40,
                              color: Colors.grey),
                          SizedBox(width: width / 90),
                          //! ------ Search TextField -------
                          Container(
                            color: Colors.transparent,
                            height: height / 20,
                            width: width / 1.7,
                            child: TextField(
                              onChanged: (val) {
                                val.length != 0
                                    ? eventSearchApi(val)
                                    : eventSearchApi("a");
                              },
                              style: TextStyle(
                                  fontFamily: 'Gilroy Medium',
                                  color: Colors.white,
                                  fontSize: 15),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: "Buscar...".tr,
                                hintStyle: TextStyle(
                                    fontFamily: 'Gilroy Medium',
                                    color: const Color(0xffd2d2db),
                                    fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //SizedBox(height: Get.height * 0.0001),
            Expanded(
              child:
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  content(),
                  showSelectedConference(),
                ],
              )
            ),


          ],
        )
        //content(),
        );
  }

  Widget content() {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(latD, longD),
        initialZoom: 12,
        interactionOptions:
            const InteractionOptions(flags: ~InteractiveFlag.doubleTapZoom),
      ),
      children: [
        openStreetMapTileLater,

        MarkerLayer(
          markers: List.generate(eventosList.length, (index) {
            return Marker(
              point: LatLng(eventosList[index]['latitud'], eventosList[index]['longitud']),
              width: isMarkerTappedList[index] ? 70 : 50, // Ancho según si se ha tocado o no
              height: isMarkerTappedList[index] ? 70 : 50, // Altura según si se ha tocado o no
              child: GestureDetector(
                onTap: () {
                  toggleMarkerSelection(index); // Cambia el estado de selección del marcador en el índice dado
                  setState(() {
                    selectedConference = eventosList[index];
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 900), // Duración de la animación
                  width: isMarkerTappedList[index] ? 70 : 50, // Ancho final después de la animación
                  height: isMarkerTappedList[index] ? 70 : 50, // Altura final después de la animación
                  child: Image.asset('image/Pin.png'),
                ),
              ),
            );
          }),
        ),

      ],

    );
  }


  Widget conference(dynamic selectedEvent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          Future.delayed(Duration(seconds: 1), () {
            // Aquí puedes navegar a una nueva pantalla pasando los datos del evento seleccionado
            // En este ejemplo, simplemente imprimo los datos del evento seleccionado en la consola
            print("Evento seleccionado: ${selectedEvent['id']}, ${selectedEvent['titulo']}, ${selectedEvent['direccion']}");
          });
        },
        child: Container(
          width: width, // Ancho del contenedor
          height: height / 5, // Altura del contenedor (puedes ajustarlo según tus necesidades)
          margin: EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: notifire.containercolore,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: notifire.bordercolore),

          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 6, bottom: 5, top: 10),
            child: Row(
              children: [
                Container(
                  width: width / 5,
                  height: height / 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Image.asset(
                      selectedEvent["imagen"], // Ruta de la imagen en tus activos
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedEvent["fecha"],
                        style: TextStyle(
                          fontFamily: 'Gilroy Medium',
                          color: const Color(0xff4A43EC),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        selectedEvent["titulo"],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Gilroy Medium',
                          color: notifire.textcolor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Image.asset("image/location.png", height: 20),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              selectedEvent["direccion"],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Gilroy Medium',
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }









  PageController pageController = PageController();
  updateMapPosition({int? index}) {
    pageController.animateToPage(index ?? 0,
        duration: Duration(seconds: 1), curve: Curves.decelerate);
    setState(() {});
  }
}

TileLayer get openStreetMapTileLater => TileLayer(
      urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png', //mapa blanco
      //urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',  //mapa negro
      //urlTemplate: 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png', //mapa feo
      //urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',  //mapa estandar
      userAgentPackageName: 'com.goevent'
    );
