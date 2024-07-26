// ignore_for_file: prefer_final_fields, prefer_const_constructors

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';
import 'package:goevent2/home/EventDetails.dart';
import 'package:goevent2/home/Evento.dart';
import 'package:like_button/like_button.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/colornotifire.dart';
import '../utils/media.dart';

class All extends StatefulWidget {
  final String? title;
  final List<Evento> eventList;
  const All({Key? key, this.title, required this.eventList}) : super(key: key);

  @override
  _AllState createState() => _AllState();
}

class _AllState extends State<All> {
  List<String> _images = [];

  final hData = Get.put(HomeController());

  bool selected = false;

  late ColorNotifire notifire;

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

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.backgrounde,
      body: Column(
        children: [
          SizedBox(height: height / 16),
          //! -------- AppBar --------
          Row(
            children: [
              SizedBox(width: width / 20),
              GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back, color: notifire.textcolor)),
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
          SizedBox(height: height / 50),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: widget.eventList!.length,
              shrinkWrap: true,
              itemBuilder: (ctx, i) {
                return events(widget.eventList[i], i);
              },
            ),
          ),

          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget events(Evento evento, i) {
    /*
    _images.clear();
    user[i]["member_list"].forEach((e) {
      _images.add(Config.base_url + e);
    });
    int mEventcount = int.parse(user[i]["total_member_list"].toString()) > 3
        ? 3
        : int.parse(user[i]["total_member_list"].toString());
    for (var i = 0; i < mEventcount; i++) {
      _images.add(Config.userImage);
    }

     */


    String base64ImageEvento = evento.imagenEvento.split(',').last;
    String base64PortadaEvento = evento.imagenPortadaEvento.split(',').last;
    //String base64Image = catList[i].imagen.split(',').last;

    // Decodificar la cadena base64 en bytes
    Uint8List imageEventoBytes = base64Decode(base64ImageEvento);
    Uint8List portadaImageBytes = base64Decode(base64PortadaEvento);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              //Get.to(() => EventsDetails(eid: evento.id), duration: Duration.zero);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: notifire.containercolore,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(color: notifire.bordercolore),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: height / 5.5,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Colors.transparent,
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                child: SizedBox(
                                  height: height / 3.5,
                                  width: width,
                                  child: evento.imagenEvento != null
                                    ? Image.memory(
                                        imageEventoBytes,
                                        fit: BoxFit.cover,
                                        
                                      )
                                    : Container(
                                        color: Colors.grey[200], // Color de marcador de posición
                                        child: Icon(Icons.image, color: Colors.grey), // Icono de marcador de posición
                                      ),
                                ),
                              ),
                              SizedBox(height: height / 70),
                            ],
                          ),
                        ),
                        SizedBox(height: height / 60),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            evento.tituloEvento,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: notifire.textcolor,
                              fontSize: 15,
                              fontFamily: 'Gilroy Medium',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: height / 60),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset("image/location.png", height: height / 40),
                              const SizedBox(width: 2),
                              Ink(
                                width: Get.width * 0.77,
                                child: Text(
                                  evento.direccionEvento,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Gilroy Medium',
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: height / 70),
                        
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                          child: Row(
/*
                            children: [
                              Spacer(),
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 3),
                                  child: LikeButton(
                                    onTap: (val) {
                                      return onLikeButtonTapped(val, evento[i]["id"]);
                                    },
                                    likeBuilder: (bool isLiked) {
                                      return user[i]["is_bookmark"] != 0
                                          ? const Icon(Icons.favorite, color: Color(0xffF0635A), size: 22)
                                          : const Icon(Icons.favorite_border, color: Color(0xffF0635A), size: 22);
                                    },
                                  ),
                                ),
                              ),
                            ],
*/
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Future<bool> onLikeButtonTapped(isLiked, eid) async {
    var data = {"eid": eid, "uid": uID};
    ApiWrapper.dataPost(Config.ebookmark, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          // bookMarkListApi();
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
    return !isLiked;
  }
}
