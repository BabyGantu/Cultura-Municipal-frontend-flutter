// ignore_for_file: file_names, prefer_typing_uninitialized_variables, non_constant_identifier_names, unused_label, prefer_final_fields, unused_local_variable, curly_braces_in_flow_control_structures, prefer_const_constructors, avoid_print

import 'dart:convert';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';
import 'package:goevent2/Controller/UserPreferences.dart';
import 'package:goevent2/home/Categoria.dart';
import 'package:goevent2/home/Evento.dart';
import 'package:goevent2/home/Gallery_View.dart';
import 'package:goevent2/utils/AppWidget.dart';
import 'package:goevent2/utils/media.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/colornotifire.dart';
import 'package:http/http.dart' as http;



const String sponsoreJson = '''
{
  "Event_sponsore": [
    {
      "sponsore_id": "1",
      "sponsore_img": "image/protection.png",
      "sponsore_title": "Nombre"
    }
  ]
}
''';

const String event_galleryJson = '''
{
  "Event_gallery": [
    {
      "img": "image/protection.png"
    },
    {
      "img": "image/onbonding1.png"
    },
    {
      "img": "image/onbonding3.png"
    },
    {
      "img": "image/p10.png"
    },
    {
      "img": "image/paco2.png"
    }
  ]
}
''';

class EventsDetails extends StatefulWidget {
  final String? eid;
  final Evento evento;
  const EventsDetails({Key? key, this.eid, required this.evento})
      : super(key: key);

  @override
  _EventsDetailsState createState() => _EventsDetailsState();
}

class _EventsDetailsState extends State<EventsDetails> {
  // final event = Get.put(HomeController());

  late ColorNotifire notifire;
  PackageInfo? packageInfo;
  String? appName;
  String? packageName;
  var eventData;
  String code = "0";
  List event_gallery = [];
  List<dynamic> event_sponsore = [];
  List<dynamic> eventosDetails = [];
  List<Categoria> categoriasList = [];
  bool isloading = false;
  List<dynamic> esFavoritos = [];

  String? token;
  String? userId;
  String? fechaExpiracion;
  

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    notifire.setIsDark = previusstate;
  }

  Future<void> cargarCategoria(int id) async {
    CategoriaService service = CategoriaService();
    try {
      Categoria categoria = await service.obtenerDetallesCategoria(id);
      setState(() {
        categoriasList.add(categoria);
      });
    } catch (e) {
      print('Error al cargar la categoría: $e');
    }
}

Future<void> cargarEventosFavoritosPorId() async {
    EventosService service = EventosService();
    token = await UserPreferences.getToken();
    userId = await UserPreferences.getUserId();
    fechaExpiracion = await UserPreferences.getFechaExpiracion();
    //status = await UserPreferences.getStatus();

    print('El id es: ${userId}');

    if (userId == null) {
      print(
          'El id de usuario es null, no se pueden cargar los eventos favoritos');

      return;
    }

    int? userIdInt = int.tryParse(userId!);
    if (userIdInt == null) {
      print('Error: El id de usuario no es un número válido');

      return;
    }

    try {
      List<dynamic> eventos = await service.obtenerFavoritos(userIdInt);
      print('Eventos favoritos: $eventos');
      setState(() {
        esFavoritos = eventos;
      });
    } catch (e) {
      setState(() {});
      print('Error al cargar los eventos favoritos: $e');
    }
  }

bool esEventoFavorito(int idEvento) {
    for (var favorito in esFavoritos) {
      if (favorito['id_event'] == idEvento) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    //walletrefar();
    getPackage();
    eventDetailApi();
    getdarkmodepreviousstate();
    cargarEventosFavoritosPorId();
  }

  void getPackage() async {
    //! App details get
    packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo!.appName;
    packageName = packageInfo!.packageName;
  }

  void eventDetailApi() async {
    // URL de tu API
    String apiUrl = 'http://10.0.2.2:8000/eventdata/eventos/${widget.eid}/';

    try {
      // Realiza una solicitud GET a la API
      http.Response response = await http.get(Uri.parse(apiUrl));

      // Verifica si la solicitud fue exitosa (código de estado 200)
      if (response.statusCode == 200) {
        // Decodifica la respuesta JSON con codificación UTF-8
        var jsonResponse = utf8.decode(response.bodyBytes);

        // Decodifica la cadena JSON y guarda el evento en el mapa
        Map<String, dynamic> eventData = json.decode(jsonResponse);

        setState(() {
          // Guarda los datos del evento en el estado
          this.eventData = eventData;
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
/*
  cargarUpcomingEvent() {
    Map<String, dynamic> eventosDetailsData = json.decode(eventsJson);
    if (widget.eid != null) {
      eventosDetailsData["EventData"] = eventosDetailsData["EventData"]
          .where((evento) => evento["event_id"] == widget.eid)
          .toList();
      print("Eventos encontrados:");
      print(eventosDetailsData["EventData"]);
    }
    setState(() {
      eventosDetails = eventosDetailsData["EventData"];
    });

    Map<String, dynamic> SponsoreData = json.decode(sponsoreJson);
    setState(() {
      event_sponsore = SponsoreData["Event_sponsore"];
    });

    Map<String, dynamic> event_galleryData = json.decode(event_galleryJson);
    setState(() {
      event_gallery = event_galleryData["Event_gallery"];
    });

    int userCount = 0;
    isloading = true;

    setState(() {});
    if ((eventosDetails != null) && (eventosDetails.isNotEmpty)) {
      eventosDetailsData["EventData"].forEach((e) {
        eventData = e;
      });
      //event_gallery = val["Event_gallery"];
      //event_sponsore = val["Event_sponsore"];
      /*
          eventData["member_list"]!.forEach((e) {
            _images.add(Config.base_url + e);
          });
           */
      for (var i = 0; i < eventosDetails.length; i++)
        userCount =
            int.parse(eventosDetails[i]["total_member_list"].toString()) > 3
                ? 3
                : int.parse(eventosDetails[i]["total_member_list"].toString());
      for (var i = 0; i < userCount; i++) {
        _images.add(Config.userImage);
      }
      isloading = false;
    }
  }
*/
/*
  eventDetailApi() {
    int userCount = 0;
    isloading = true;


    var data = {"eid": widget.eid, "uid": uID};
    ApiWrapper.dataPost(Config.eventdataApi, data).then((val) {
      setState(() {});
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          val["EventData"].forEach((e) {
            eventData = e;
          });
          event_gallery = val["Event_gallery"];
          event_sponsore = val["Event_sponsore"];
          eventData["member_list"]!.forEach((e) {
            _images.add(Config.base_url + e);
          });
          for(var i = 0; i < val["EventData"].length; i++)
            userCount = int.parse(val["EventData"][i]["total_member_list"].toString()) >
                        3
                    ? 3
                    : int.parse(
                        val["EventData"][i]["total_member_list"].toString());
          for (var i = 0; i < userCount; i++) {
            _images.add(Config.userImage);
          }
          isloading = false;
        } else {
          isloading = false;
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }

 */

  //! ----- LikeButtonTapped -----
  Future<bool> onLikeButtonTapped(isLiked, eid) async {
    var data = {"eid": eid, "uid": uID};
    ApiWrapper.dataPost(Config.ebookmark, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          eventDetailApi();
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
    return !isLiked;
  }

  void abrirMapa(double latitud, double longitud) async {
    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitud,$longitud';
    final String appleMapsUrl = 'https://maps.apple.com/?q=$latitud,$longitud';

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else if (await canLaunch(appleMapsUrl)) {
      await launch(appleMapsUrl);
    } else {
      throw 'No se pudo abrir el mapa.';
    }
  }

  List<String> _images = [];

  @override
  Widget build(BuildContext context) {
    String formatDate(String dateStr) {
      DateTime date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date);
    }

    String formatTime(String timeStr) {
      DateTime time = DateTime.parse(timeStr);
      return DateFormat('HH:mm').format(time);
    }

    notifire = Provider.of<ColorNotifire>(context, listen: true);
    cargarCategoria(widget.evento.idCategoria);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: notifire.backgrounde,
      //! ------ Buy Ticket button -----!//
      appBar: !isloading
          ? AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              title: Row(
                children: [
                  Text(
                    "Event Details".tr,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Gilroy Medium',
                        color: Colors.white),
                  ),
                  Spacer(),
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
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: LikeButton(
                          onTap: (val) {
                            return onLikeButtonTapped(val, widget.eid);
                          },
                          likeBuilder: (bool isLiked) {
                            return Icon(
                              esEventoFavorito(widget.evento.id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: esEventoFavorito(widget.evento.id)
                                  ? const Color(0xffF0635A)
                                  : Colors.grey,
                              size: 22,
                            );
                          },
                        ),
                      ),
                    ),
                    ),
                  ),
                ],
              ),
            )
          : null,

      /*
      floatingActionButton: SizedBox(
        height: 45,
        width: 410,

        child: !isloading

            ? FloatingActionButton(
                onPressed: () {
                  Get.to(() => Ticket(eid: eventData["event_id"]),
                      duration: Duration.zero);
                },

                child: Custombutton.button1(

                  notifire.getbuttonscolor,
                  "BUY TICKET".tr + " ${mainData["currency"]}",
                  //"BUY TICKET".tr + " ${mainData["currency"]}" + "${eventData != null ? eventData["ticket_price"] : ""}",
                  SizedBox(width: width / 15),
                  SizedBox(width: width / 15),
                ),
              )
            : const SizedBox(),
      ),

       */
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: !isloading
          ? CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: MySliverAppBar(
                      expandedHeight: 200.0,
                      eventData: eventData,
                      images: _images,
                      share: share,
                      evento: widget.evento),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // Stack(
                      //   children: [
                      //     SizedBox(height: Get.height * 0.01),
                      //     CarouselSlider(
                      //       options: CarouselOptions(height: height / 4),
                      //       items: eventData != null
                      //           ? eventData["event_cover_img"].map<Widget>((i) {
                      //         return Builder(
                      //           builder: (BuildContext context) {
                      //             return Container(
                      //               width: Get.width,
                      //               decoration: const BoxDecoration(
                      //                   color: Colors.transparent),
                      //               child: FadeInImage.assetNetwork(
                      //                   fadeInCurve: Curves.easeInCirc,
                      //                   placeholder: "image/skeleton.gif",
                      //                   fit: BoxFit.cover,
                      //                   image: Config.base_url + i),
                      //             );
                      //           },
                      //         );
                      //       }).toList()
                      //           : [].map<Widget>((i) {
                      //         return Builder(
                      //           builder: (BuildContext context) {
                      //             return Container(
                      //                 width: 100,
                      //                 margin: const EdgeInsets.symmetric(
                      //                     horizontal: 1),
                      //                 decoration: const BoxDecoration(
                      //                     color: Colors.transparent),
                      //                 child: Image.network(Config.base_url + i,
                      //                     fit: BoxFit.fill));
                      //           },
                      //         );
                      //       }).toList(),
                      //       // ),
                      //     ),
                      //     Column(
                      //       children: [
                      //         SizedBox(height: height / 20),
                      //         SizedBox(height: height / 6),
                      //         Center(
                      //           child: SizedBox(
                      //             width: width / 1.4,
                      //             height: height / 14,
                      //             child: Card(
                      //               color: notifire.getprimerycolor,
                      //               // color: Colors.black,
                      //               shape: RoundedRectangleBorder(
                      //                   borderRadius: BorderRadius.circular(25.0)),
                      //               child: Row(
                      //                 mainAxisAlignment: eventData["total_member_list"] != "0" ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                      //                 children: [
                      //                   SizedBox(width: Get.width * 0.01),
                      //                   eventData["total_member_list"] != "0"
                      //                       ? FlutterImageStack(
                      //                       totalCount: 0,
                      //                       itemRadius: 30,
                      //                       itemCount: 3,
                      //                       itemBorderWidth: 1.5,
                      //                       imageList: _images)
                      //                       : const SizedBox(),
                      //                   SizedBox(width: Get.width * 0.01),
                      //                   eventData["total_member_list"] != "0"
                      //                       ? Builder(
                      //                       builder: (context) {
                      //                         print("+++++***********-------${Config.userImage}");
                      //                         return Text(
                      //                           "${eventData["total_member_list"]} + Going",
                      //                           style: TextStyle(
                      //                               color: const Color(0xff5d56f3),
                      //                               fontSize: 12,
                      //                               fontFamily: 'Gilroy Bold'),
                      //                         );
                      //                       }
                      //                   )
                      //                       : const SizedBox(),
                      //                   eventData["total_member_list"] != "0"
                      //                       ? SizedBox(width: width / 14)
                      //                       : const SizedBox(),
                      //                   InkWell(
                      //                     onTap: share,
                      //                     child: Container(
                      //                       height: height / 29,
                      //                       width: width / 6,
                      //                       decoration: BoxDecoration(
                      //                           color: const Color(0xff5669ff),
                      //                           borderRadius: BorderRadius.circular(6)),
                      //                       child: Center(
                      //                         child: Text("Invite".tr,
                      //                             style: TextStyle(
                      //                                 color: Colors.white,
                      //                                 fontSize: 10,
                      //                                 fontFamily: 'Gilroy Bold')),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                   const SizedBox(width: 6),
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),
                      SizedBox(height: 40),
                      //! -------international-------
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: SizedBox(
                              width: Get.width * 0.90,
                              child: Text(
                                widget.evento.tituloEvento ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Gilroy Medium',
                                    color: notifire.textcolor),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Wrap(
                              spacing: 2.0, // Space between items horizontally
                              runSpacing: 2.0, // Space between items vertically
                              children: [
                                concert("image/date.png", 'Categoria',
                                    '${categoriasList[0].nombre}'),
                                concert("image/date.png", 'Publico objetivo',
                                    '${widget.evento.idPublicoObjetivo}'),
                                concert("image/date.png", 'Fecha',
                                    '${widget.evento.fechaInicio} a ${widget.evento.fechaFin}'),
                                concert("image/date.png", 'Hora',
                                    '${widget.evento.horaInicio} a ${widget.evento.horaFin}'),
                                GestureDetector(
                                  onTap: () {
                                    abrirMapa(widget.evento.latitud,
                                        widget.evento.longitud);
                                  },
                                  child: concert(
                                      "image/direction.png",
                                      widget.evento.tituloDireccion,
                                      widget.evento.direccionEvento),
                                ),
                                concert("image/date.png", 'Precio',
                                    widget.evento.precio),
                                concert("image/date.png", 'Organizador',
                                    widget.evento.organizador),
                                widget.evento.telefono.isNotEmpty
                                    ? concert("image/date.png", 'Telefono',
                                        widget.evento.telefono)
                                    : Container(), // No mostrar nada si está vacío

                                widget.evento.correo.isNotEmpty
                                    ? concert(
                                        "image/date.png",
                                        'Correo electronico',
                                        widget.evento.correo)
                                    : Container(), // No mostrar nada si está vacío
                                SizedBox(width: height / 60),
                                Padding(
                                  padding: EdgeInsets.only(left: 50),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    abrirMapa(widget.evento.latitud,
                                        widget.evento.longitud);
                                  },
                                  icon: Icon(Icons.map,
                                      color: Colors.white), // Icono de mapa
                                  label: Text('Ir al mapa'), // Texto del botón
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors
                                        .blueAccent, // Color del fondo del botón
                                    onPrimary:
                                        Colors.white, // Color del texto e icono
                                    textStyle: TextStyle(
                                        fontSize: 16), // Tamaño del texto
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12), // Espaciado del botón
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //! -------- Event_sponsore List ------
/*
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: event_sponsore.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (ctx, i) {
                            return sponserList(event_sponsore, i);
                          },
                        ),
*/
                          SizedBox(height: height / 50),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Row(
                              children: [
                                Text("About Event".tr,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Gilroy Medium',
                                        color: notifire.textcolor)),
                              ],
                            ),
                          ),
                          SizedBox(height: height / 40),
                          //! About Event
                          Ink(
                            width: Get.width * 0.97,
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: HtmlWidget(
                                  widget.evento.descripcion ?? "",
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: notifire.textcolor,
                                      fontSize: 12,
                                      fontFamily: 'Gilroy Medium'),
                                )),
                          ),
                          event_gallery.isNotEmpty
                              ? SizedBox(height: height / 50)
                              : const SizedBox(),
                          event_gallery.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Gallery".tr,
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Gilroy Medium',
                                              color: notifire.textcolor)),
                                      InkWell(
                                        onTap: () {
                                          Get.to(() => GalleryView(
                                                list: event_gallery,
                                              ));
                                          setState(() {});
                                        },
                                        child: Row(
                                          children: [
                                            Text("View All".tr,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: 'Gilroy Medium',
                                                    color: const Color(
                                                        0xff747688))),
                                            const Icon(
                                                Icons.keyboard_arrow_right,
                                                color: Color(0xff747688))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                          event_gallery.isNotEmpty
                              ? SizedBox(height: height / 40)
                              : const SizedBox(),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Ink(
                              height: Get.height * 0.14,
                              width: Get.width,
                              child: ListView.builder(
                                itemCount: event_gallery.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (ctx, i) {
                                  return galeryEvent(event_gallery, i);
                                },
                              ),
                            ),
                          ),
                          event_gallery.isNotEmpty
                              ? SizedBox(height: Get.height * 0.10)
                              : const SizedBox(),
                        ],
                      ),
                      SizedBox(height: 90),
                    ],
                  ),
                ),
              ],
            )
          : isLoadingCircular(),
    );
  }

  galeryEvent(gEvent, i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        width: Get.width * 0.28,
        decoration: BoxDecoration(
            // border: Border.all(color: Colors.grey.shade400, width: 1),
            borderRadius: BorderRadius.circular(14),
            image: DecorationImage(
                image: AssetImage(gEvent[i]["img"]), fit: BoxFit.cover)),
      ),
    );
  }
/*
  galeryEvent(gEvent, i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        width: Get.width * 0.28,
        decoration: BoxDecoration(
            // border: Border.all(color: Colors.grey.shade400, width: 1),
            borderRadius: BorderRadius.circular(14),
            image: DecorationImage(
                image: NetworkImage(Config.base_url + gEvent[i]),
                fit: BoxFit.cover)),
      ),
    );
  }

 */

  Widget concert(img, name1, name2) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(children: [
        Container(
            height: height / 15,
            width: width / 7,
            decoration: BoxDecoration(
                color: notifire.getcardcolor,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Padding(
                padding: const EdgeInsets.all(8), child: Image.asset(img))),
        SizedBox(width: width / 40),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name1,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Gilroy Medium',
                  color: notifire.textcolor)),
          SizedBox(height: height / 300),
          Ink(
            width: Get.width * 0.705,
            child: Text(name2,
                maxLines: 2,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Gilroy Medium',
                    color: Colors.grey)),
          ),
        ])
      ]),
    );
  }

  // sponserList(eventSponsore, i) {
  //   print(eventSponsore[i]);
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
  //     child: GestureDetector(
  //       onTap: () {
  //         // Get.to(() => const Organize());
  //       },
  //       child: Container(
  //         color: Colors.transparent,
  //         child: Row(
  //           children: [
  //             Padding(
  //               padding: EdgeInsets.only(left: Get.width * 0.025),
  //               child: Container(
  //                 height: Get.height * 0.05,
  //                 width: Get.width * 0.11,
  //                 decoration: BoxDecoration(
  //                     color: notifire.getcardcolor,
  //                     borderRadius: const BorderRadius.all(Radius.circular(50)),
  //                     image: DecorationImage(
  //                         image: NetworkImage(Config.base_url +
  //                             eventSponsore[i]["sponsore_img"]),
  //                         fit: BoxFit.fill)),
  //               ),
  //             ),
  //             // SizedBox(width: width / 38),
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Ink(
  //                   width: Get.width * 0.70,
  //                   child: Text(eventSponsore[i]["sponsore_title"],
  //                       maxLines: 1,
  //                       overflow: TextOverflow.ellipsis,
  //                       style: TextStyle(
  //                           fontSize: 15,
  //                           fontWeight: FontWeight.w500,
  //                           fontFamily: 'Gilroy Medium',
  //                           color: notifire.getdarkscolor)),
  //                 ),
  //                 SizedBox(height: height / 300),
  //                 Text("Organizer",
  //                     style: TextStyle(
  //                         fontSize: 10,
  //                         fontWeight: FontWeight.w500,
  //                         fontFamily: 'Gilroy Medium',
  //                         color: Colors.grey)),
  //               ],
  //             ),
  //             InkWell(
  //                 onTap: () {
  //                   print(eventSponsore[i]);
  //                   Get.to(ChatPage(resiverUserId: "1", resiverUseremail: 'admin', proPic: eventSponsore[i]["sponsore_img"]));
  //                 },
  //                 child: Icon(Icons.chat)),
  //             const Spacer(),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  sponserList(eventSponsore, i) {
    print(eventSponsore[i]);
    return ListTile(
      onTap: () {
        print(eventSponsore[i]);
        //Get.to(ChatPage(resiverUserId: "1", resiverUseremail: 'admin', proPic: eventSponsore[i]["sponsore_img"]));
      },
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            color: notifire.getcardcolor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            image: DecorationImage(
                image: AssetImage(eventSponsore[i]["sponsore_img"]),
                fit: BoxFit.fill)
            //image: DecorationImage(image: NetworkImage(Config.base_url + eventSponsore[i]["sponsore_img"]), fit: BoxFit.fill)
            ),
        // child: Image(image: NetworkImage(Config.base_url + eventSponsore[i]["sponsore_img"])),
      ),
      title: Transform.translate(
        offset: Offset(-10, 0),
        child: Text(eventSponsore[i]["sponsore_title"],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: 'Gilroy Medium',
                color: notifire.textcolor)),
      ),
      subtitle: Transform.translate(
        offset: Offset(-10, 0),
        child: Text("Organizer",
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                fontFamily: 'Gilroy Medium',
                color: Colors.grey)),
      ),
      trailing: Container(
          height: height / 29,
          width: width / 6,
          // padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xffEAEDFF),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
              child: Text('Details'.tr,
                  style: TextStyle(color: Color(0xff5669FF), fontSize: 10)))),
    );
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: '$appName',
        text:
            'Hey! Now use our app to share with your family or friends. User will get wallet amount on your 1st successful transaction. Enter my referral code $code & Enjoy your shopping !!!',
        linkUrl: 'https://play.google.com/store/apps/details?id=$packageName',
        chooserTitle: '$appName');
  }

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
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  var eventData;
  var share;
  var images;
  final Evento evento;

  MySliverAppBar(
      {required this.expandedHeight,
      required this.eventData,
      required this.images,
      required this.share,
      required this.evento});
  late ColorNotifire notifire;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);

    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        CarouselSlider(
          options: CarouselOptions(height: height / 4),
          items: evento.imagenPortadaEvento != null
              ? [
                  Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: Get.width,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Image.network(
                          'http://216.225.205.93:3000${evento.imagenPortadaEvento}',
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  )
                ]
              : [
                  Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: Get.width,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: const Center(
                          child: Text(
                            'No Image Available',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  )
                ],
        ),
        // Puedes agregar más widgets aquí como la barra de detalles del evento, botones, etc.
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
