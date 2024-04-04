// ignore_for_file: file_names, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';
import 'package:goevent2/home/EventDetails.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


const String eventsJson = '''
{
  "events": [
    {
      "event_id": "1",
      "cid": "1",
      "event_title": "Evento de arte 1",
      "event_img": "image/protection.png",
      "event_address": "Dirección del evento de arte",
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
      "event_id": "7",
      "cid": "3",
      "event_title": "Festival de cine 1",
      "event_img": "image/pay.png",
      "event_address": "Dirección de la obra de teatro",
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
      "event_id": "9",
      "cid": "3",
      "event_title": "Festival de cine 3",
      "event_img": "image/protection.png",
      "event_address": "Dirección del concierto de música",
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
      "IS_BOOKMARK": 0,
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


class TrndingPage extends StatefulWidget {
  final Map? catdata;
  const TrndingPage({Key? key, this.catdata}) : super(key: key);

  @override
  State<TrndingPage> createState() => _TrndingPageState();
}

class _TrndingPageState extends State<TrndingPage> {
  late ColorNotifire notifire;
  List categoryEvent = [];

  @override
  void initState() {
    getdarkmodepreviousstate();
    catEventListApi();
    super.initState();
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
/*
  catEventListApi() {
    var data = {"uid": uID, "cid": widget.catdata!["id"]};
    ApiWrapper.dataPost(Config.catEvent, data).then((val) {
      setState(() {});
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          categoryEvent = val["SearchData"];
        } else {}
      }
    });
  }

 */

  void catEventListApi() {
    // Decodificar el JSON eventsJson como un objeto JSON
    Map<String, dynamic> decodedJson = json.decode(eventsJson);

    // Acceder a la lista de eventos dentro del objeto JSON
    List<dynamic> events = decodedJson['events'];

    // Filtrar los eventos basados en la categoría
    String categoryId = widget.catdata!['id'].toString();
    List filteredEvents = events.where((event) => event['cid'] == categoryId).toList();

    // Actualizar la lista de eventos de la categoría
    setState(() {
      categoryEvent = filteredEvents;
    });
  }


  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.backgrounde,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: Get.height * 0.06,
              width: Get.width,
              /*
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.catdata!["cover_img"]),
                  fit: BoxFit.fill,
                ),
              ),

               */

              child: Row(
                children: [
                  SizedBox(width: Get.width / 20),
                  GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back,
                          color: notifire.getdarkscolor)),
                  SizedBox(width: Get.width / 80),
                  Text(
                    widget.catdata!["title"],
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Gilroy Medium',
                        color: notifire.getdarkscolor),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    categoryEvent.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: categoryEvent.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, i) {
                              return events(categoryEvent, i);
                            },
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: Get.height * 0.40),
                              Text("Event List Not Found!".tr,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Gilroy Medium',
                                      color: notifire.textcolor)),
                            ],
                          )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget events(user, i) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => EventsDetails(eid: user[i]["event_id"]),
                duration: Duration.zero);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(color: Colors.grey.shade200)),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: Get.height / 5.5,
                        width: Get.width,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Colors.transparent),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                user[i]["event_img"],
                                fit: BoxFit.cover,
                                height: Get.height / 3.5,
                                width: Get.width,
                              ),
                            ),

                            Column(
                              children: [
                                SizedBox(height: Get.height / 70),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Get.height * 0.015),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          user[i]["event_title"],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: notifire.getdarkscolor,
                              fontSize: 15,
                              fontFamily: 'Gilroy Medium',
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: Get.height * 0.015),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset("image/location.png",
                                height: Get.height / 50),
                            SizedBox(width: Get.width * 0.01),
                            Ink(
                              width: Get.width * 0.77,
                              child: Text(
                                user[i]["event_address"],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Gilroy Medium',
                                    fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Get.height * 0.015),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 6),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                user[i]["sponsore_list"] != null
                                    ? CircleAvatar(
                                        radius: 16.0,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: NetworkImage(
                                            Config.base_url +
                                                user[i]["sponsore_list"]
                                                    ["sponsore_img"]),
                                      )
                                    : const Image(
                                        image: AssetImage("image/user.png"),
                                        height: 28),
                                const SizedBox(width: 10),
                                // Text(
                                //   " + 20 Going",
                                //   style: TextStyle(
                                //       color: const Color(0xff5d56f3),
                                //       fontSize: 11 ,
                                //       fontFamily: 'Gilroy Bold'),
                                // ),
                              ],
                            ),
                            const Spacer(),
                            LikeButton(
                              onTap: (val) {
                                return onLikeButtonTapped(
                                    val, user[i]["event_id"]);
                              },
                              likeBuilder: (bool isLiked) {
                                return user[i]["IS_BOOKMARK"] != 0
                                    ? const Icon(Icons.favorite,
                                        color: Color(0xffF0635A), size: 24)
                                    : const Icon(Icons.favorite_border,
                                        color: Colors.grey, size: 24);
                              },
                            ),
                          ],
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
    );
  }

  Future<bool> onLikeButtonTapped(isLiked, eid) async {
    var data = {"eid": eid, "uid": uID};
    ApiWrapper.dataPost(Config.ebookmark, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          catEventListApi();
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
    return !isLiked;
  }
}
