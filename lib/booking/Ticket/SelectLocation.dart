import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/ctextfield.dart';

class SelectLocation extends StatefulWidget {
  const SelectLocation({Key? key}) : super(key: key);

  @override
  _SelectLocationState createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  late TextEditingController latController;
  late TextEditingController longController;


  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    notifire.setIsDark = previusstate;
    }

  @override
  void initState() {
    super.initState();
    getdarkmodepreviousstate();
    latController = TextEditingController();
    longController = TextEditingController();
  }

  @override
  void dispose() {
    latController.dispose();
    longController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
        body: OpenStreetMapSearchAndPick(
          buttonTextStyle:
          const TextStyle(fontSize: 18, fontStyle: FontStyle.normal),
          buttonColor: notifire.getbuttonscolor,
          locationPinText: "Location".tr,

          buttonText: 'Select Location'.tr,
          onPicked: (pickedData) {
            print(pickedData.latLong.latitude);
            print(pickedData.latLong.longitude);
            print(pickedData.address);
            print(pickedData.addressName);
            Navigator.pop(context, [pickedData.latLong.latitude, pickedData.latLong.longitude]);
          },
          //baseUri: "https://basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png",
        )
    );
  }
}
TileLayer get openStreetMapTileLater => TileLayer(
    urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png', //mapa blanco
    //urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',  //mapa negro
    //urlTemplate: 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png', //mapa feo
    //urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',  //mapa estandar
    userAgentPackageName: 'com.goevent'
);