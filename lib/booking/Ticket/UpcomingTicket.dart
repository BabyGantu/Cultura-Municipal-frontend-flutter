// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables, file_names, prefer_const_constructors

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';
import 'package:goevent2/booking/Ticket/TicketDetails.dart';
import 'package:goevent2/utils/AppWidget.dart';
import 'package:goevent2/utils/CustomImageGallery.dart';
import 'package:goevent2/utils/color.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:goevent2/utils/media.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/CustomComboBox.dart';
import '../../utils/CustomDatePickerTextField.dart';
import '../../utils/CustomImagePicker.dart';
import '../../utils/CustomTimePickerTextField.dart';
import '../../utils/CustomPriceInput.dart';
import '../../utils/MunicipiosComboBox.dart';
import '../../utils/TargetAudienceComboBox.dart';
import 'SelectLocation.dart';

import '../../Controller/AuthController.dart';
import '../../profile/loream.dart';
import '../../utils/botton.dart';
import '../../utils/ctextfield.dart';
import '../../utils/itextfield.dart';

// Done
class UpcomingTicket extends StatefulWidget {
  const UpcomingTicket({Key? key}) : super(key: key);

  @override
  _UpcomingTicketState createState() => _UpcomingTicketState();
}

class _UpcomingTicketState extends State<UpcomingTicket> {
  var selectedRadioTile;
  final note = TextEditingController();
  String? rejectmsg = '';
  List orderdata = [];
  List event_gallery = [];
  List<dynamic> event_sponsore = [];
  bool isLoading = false;

  bool verificar = false;

  late ColorNotifire notifire;
  final event_title = TextEditingController();

  final cid = TextEditingController();
  final event_img = TextEditingController();
  final event_cover_img = TextEditingController();

  final event_address_title = TextEditingController();

  final event_address = TextEditingController();

  late TextEditingController end_dateController;

  late String end_date;

  late TextEditingController start_dateController;
  late String start_date;

  final start_time = TextEditingController();
  final end_time = TextEditingController();
  final event_about = TextEditingController();
  final event_about_short = TextEditingController();
  final price = TextEditingController();
  final lat = TextEditingController();
  final long = TextEditingController();
  final target_audience = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();

  final Event_sponsore = TextEditingController();
  final Event_gallery = TextEditingController();

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
    ticketStatusApi();
    getdarkmodepreviousstate();
    start_dateController = TextEditingController();
    start_date = ''; // Inicializa la fecha vacía
    end_dateController = TextEditingController();
    end_date = '';
    bool verificar = false; // Inicializa la fecha vacía
  }

  @override
  void dispose() {
    start_dateController.dispose();
    end_dateController.dispose();
    super.dispose();
  }

  ticketStatusApi() {
    setState(() {
      isLoading = true;
    });
    var data = {"uid": uID, "status": "Booked"};
    print("Api Call type price: :$data");
    ApiWrapper.dataPost(Config.ticketStatus, data).then((val) {
      print("Api Call type price: :$val");

      setState(() {});
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          setState(() {});
          print(val);
          orderdata = val["order_data"];
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            orderdata = [];
            isLoading = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.backgrounde,
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 40),
                CustomComboBox(
                  labelColor: Colors.grey,
                  textColor: notifire.getwhitecolor,
                  onChanged: (value) {
                    cid.text = value;
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 40),
                TargetAudienceComboBox(
                  labelColor: Colors.grey,
                  textColor: notifire.getwhitecolor,
                  onChanged: (value) {
                    target_audience.text = value;
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 40),
                Customtextfild.textField(
                  controller: event_title,
                  name1: "Event title".tr,
                  labelclr: Colors.grey,
                  textcolor: notifire.getwhitecolor,
                  prefixIcon: Image.asset(
                    "image/evento.png",
                    scale: 3.5,
                  ),
                  context: context,
                ),

                buildEmptyFieldWarning(event_title, verificar),

                SizedBox(height: MediaQuery.of(context).size.height / 40),
                CustomImagePicker(
                  imagePaths: [],
                  name: "Event Image".tr, // Lista de rutas de imágenes, puedes inicializarla con las imágenes existentes
                  labelclr:
                      Colors.grey, // Color del texto del título y del borde
                  textcolor: notifire
                      .getwhitecolor, // Color del texto dentro de la galería
                  iconImagePath:
                      "image/imagen_icon.png", // Ruta de la imagen del icono de la galería
                  context: context, // Contexto de la aplicación
                ),

                SizedBox(height: MediaQuery.of(context).size.height / 60),
                CustomImagePicker(
                  imagePaths: [],
                  name: "Event Cover".tr, // Lista de rutas de imágenes, puedes inicializarla con las imágenes existentes
                  labelclr:
                      Colors.grey, // Color del texto del título y del borde
                  textcolor: notifire
                      .getwhitecolor, // Color del texto dentro de la galería
                  iconImagePath:
                      "image/imagen_icon.png", // Ruta de la imagen del icono de la galería
                  context: context, // Contexto de la aplicación
                ),

                SizedBox(height: MediaQuery.of(context).size.height / 60),
                CustomDatePickerTextField(
                  controller: start_dateController,
                  name1: "Start date".tr,
                  labelclr: Colors.grey,
                  textcolor: notifire.getwhitecolor,
                  iconImagePath: 'image/Calendar.png',
                  onChanged: (value) {
                    setState(() {
                      start_dateController.text = value;
                    });
                  },
                ),
                buildEmptyFieldWarning(start_dateController, verificar),

                SizedBox(height: MediaQuery.of(context).size.height / 40),
                CustomDatePickerTextField(
                  controller: end_dateController,
                  name1: "End date".tr,
                  labelclr: Colors.grey,
                  textcolor: notifire.getwhitecolor,
                  iconImagePath: 'image/Calendar.png',
                  onChanged: (value) {
                    setState(() {
                      end_dateController.text = value;
                    });
                  },
                ),
                buildEmptyFieldWarning(end_dateController, verificar),
                SizedBox(height: MediaQuery.of(context).size.height / 40),
                CustomTimePickerTextField(
                  controller: start_time,
                  name1: "Start Time".tr,
                  labelclr: Colors.grey,
                  textcolor: notifire.getwhitecolor,
                  iconImagePath: "image/time.png",
                  onChanged: (value) {
                    setState(() {
                      start_time.text = value;
                    });
                  },
                ),
                buildEmptyFieldWarning(start_time, verificar),

                SizedBox(height: MediaQuery.of(context).size.height / 40),
                CustomTimePickerTextField(
                  controller: end_time,
                  name1: "End Time".tr,
                  labelclr: Colors.grey,
                  textcolor: notifire.getwhitecolor,
                  iconImagePath: "image/time.png",
                  onChanged: (value) {
                    setState(() {
                      end_time.text = value;
                    });
                  },
                ),
                buildEmptyFieldWarning(end_time, verificar),
                SizedBox(height: MediaQuery.of(context).size.height / 40),
                CustomPriceInput(
                  controller: price,
                  name: "Price".tr,
                  labelclr: Colors.grey,
                  textcolor: notifire.getwhitecolor,
                  iconImagePath: "image/dolar.png",
                  context: context,
                ),
                buildEmptyFieldWarning(price, verificar),
                SizedBox(height: MediaQuery.of(context).size.height / 40),

                CustomShortTextArea.textArea(
                  controller: event_about_short,
                  name1: "Short description".tr,
                  labelclr: Colors.grey,
                  textcolor: notifire.getwhitecolor,
                  prefixIcon: Image.asset(
                    "image/descripcion.png",
                    scale: 3.5,
                    //color: notifire.textcolor
                  ),
                  context: context,
                ),
                buildEmptyFieldWarning(event_about_short, verificar),
                SizedBox(
                    height: MediaQuery.of(context).size.height /
                        40), // Ajustar altura según necesidad
                CustomTextArea.textArea(
                  controller: event_about,
                  name1: "Description".tr,
                  labelclr: Colors.grey,
                  textcolor: notifire.getwhitecolor,
                  prefixIcon: Image.asset(
                    "image/descripcion.png",
                    scale: 3.5,
                    //color: notifire.textcolor
                  ),
                  context: context,
                ),
                buildEmptyFieldWarning(event_about, verificar),
                SizedBox(
                    height: MediaQuery.of(context).size.height /
                        40), // Ajustar altura según necesidad

                CustomImageGallery(
                  imagePaths: [], // Lista de rutas de imágenes, puedes inicializarla con las imágenes existentes
                  labelclr:
                      Colors.grey, // Color del texto del título y del borde
                  textcolor: notifire
                      .getwhitecolor, // Color del texto dentro de la galería
                  iconImagePath:
                      "image/galeria.png", // Ruta de la imagen del icono de la galería
                  context: context, // Contexto de la aplicación
                ),

                SizedBox(
                    height: MediaQuery.of(context).size.height /
                        40), // Ajustar altura según necesidad
                Customtextfild.textField(
                  controller: Event_sponsore,
                  name1: "Organizer".tr,
                  labelclr: Colors.grey,
                  textcolor: notifire.getwhitecolor,
                  prefixIcon: Image.asset(
                    "image/organizer.png",
                    scale: 3.5,
                    //color: notifire.textcolor
                  ),
                  context: context,
                ),
                buildEmptyFieldWarning(Event_sponsore, verificar),
                SizedBox(height: MediaQuery.of(context).size.height / 40),
                Customtextfild.textField(
                  controller: phone,
                  name1: "Phone (optional)".tr,
                  keyboardType: TextInputType.phone,
                  labelclr: Colors.grey,
                  textcolor: notifire.getwhitecolor,
                  prefixIcon: Image.asset(
                    "image/llamada.png",
                    scale: 3.5,
                    //color: notifire.textcolor
                  ),
                  context: context,
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 40),
                Customtextfild.textField(
                  controller: email,
                  name1: "Email (optional)".tr,
                  keyboardType: TextInputType.emailAddress,
                  labelclr: Colors.grey,
                  textcolor: notifire.getwhitecolor,
                  prefixIcon: Image.asset(
                    "image/email.png",
                    scale: 3.5,
                    //color: notifire.textcolor
                  ),
                  context: context,
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 40),

                Customtextfild.textField(
                  controller: event_address_title,
                  name1: "Event address title, (Example: Plaza Lázaro Cárdenas)"
                      .tr
                      .tr,
                  labelclr: Colors.grey,
                  textcolor: notifire.getwhitecolor,
                  prefixIcon: Image.asset(
                    "image/direction.png",
                    scale: 3.5,
                    //color: notifire.textcolor
                  ),
                  context: context,
                ),
                buildEmptyFieldWarning(event_address_title, verificar),
                SizedBox(
                    height: MediaQuery.of(context).size.height /
                        40), // Ajustar altura según necesidad
                Customtextfild.textField(
                  controller: event_address,
                  name1: "Event address".tr,
                  keyboardType: TextInputType.streetAddress,
                  labelclr: Colors.grey,
                  textcolor: notifire.getwhitecolor,
                  prefixIcon: Image.asset(
                    "image/direction.png",
                    scale: 3.5,
                    //color: notifire.textcolor
                  ),
                  context: context,
                ),
                buildEmptyFieldWarning(event_address, verificar),
                SizedBox(height: MediaQuery.of(context).size.height / 40),

                MunicipiosComboBox(
                  labelColor: Colors.grey,
                  textColor: notifire.getwhitecolor,
                  onChanged: (value) {
                    cid.text = value;
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 40),

                GestureDetector(
                  onTap: () async {
                    List<double>? location =
                        await Get.to(() => SelectLocation());
                    if (location != null) {
                      lat.text = location[0].toString();
                      long.text = location[1].toString();
                    }
                  },
                  child: SizedBox(
                    height: 30,
                    width: 200,
                    child: Custombutton.button2(
                      notifire.getbuttonscolor,
                      "Select location".tr,
                      SizedBox(width: width / 4),
                      SizedBox(width: width / 5),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 100),
                Customtextfild.textField(
                    controller: lat,
                    name1: "Latitude".tr,
                    labelclr: Colors.grey,
                    textcolor: notifire.getwhitecolor,
                    prefixIcon: Image.asset("image/direction.png",
                        scale: 3.5, color: notifire.textcolor),
                    readOnly: true,
                    context: context,
                    keyboardType: TextInputType.none),
                buildEmptyFieldWarning(lat, verificar),
                SizedBox(height: MediaQuery.of(context).size.height / 40),
                Customtextfild.textField(
                    controller: long,
                    name1: "Longitude".tr,
                    labelclr: Colors.grey,
                    textcolor: notifire.getwhitecolor,
                    prefixIcon: Image.asset("image/direction.png",
                        scale: 3.5, color: notifire.textcolor),
                    readOnly: true,
                    context: context,
                    keyboardType: TextInputType.none),
                buildEmptyFieldWarning(long, verificar),
                SizedBox(height: MediaQuery.of(context).size.height / 40),

                Center(
                  child: RichText(
                    text: TextSpan(
                        text: "By continuing, ".tr,
                        style: TextStyle(
                            color: notifire.getwhitecolor, fontSize: 12),
                        children: <TextSpan>[
                          TextSpan(text: "You agree to GoEvent's \n".tr),
                          TextSpan(
                              text: 'Terms of Use '.tr,
                              style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 2.5),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(() => Loream("Terms & Conditions".tr));
                                }),
                          const TextSpan(text: "and "),
                          TextSpan(
                              text: 'Privacy Policy.'.tr,
                              style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 2.5),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(() => Loream("Terms & Conditions".tr));
                                }),
                        ]),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 40),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      verificar = true;
                      // Actualizar el estado según si el campo está vacío o no
                      //isTitleEmpty = isFieldEmpty(event_title);
                    });
                    checkAllFieldsAndRegisterEvent(context);
                    //authSignUp();

                    print('el titulo del evento es: ${event_title.text}');
                    print('el cid es: ${cid.text}');
                    print('el event_img es: ${event_img.text}');
                    print('el event_cover_img es: ${event_cover_img.text}');
                    print(
                        'el event_address_title es: ${event_address_title.text}');
                    print('el event_address es: ${event_address.text}');
                    print('el start_date es: ${start_dateController.text}');
                    print('el end_date es: ${end_dateController.text}');
                    print('el start_time es: ${start_time.text}');
                    print('el end_time es: ${end_time.text}');
                    print(
                        'el event_about_short  es: ${event_about_short.text}');
                    print('el event_about es: ${event_about.text}');
                    print('el price es: ${price.text}');
                    print('el lat es: ${lat.text}');
                    print('el long es: ${long.text}');
                  },
                  child: SizedBox(
                    height: 45,
                    child: Custombutton.button1(
                      notifire.getbuttonscolor,
                      "Register event".tr,
                      SizedBox(width: width / 4),
                      SizedBox(width: width / 5),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  // Función para verificar si un campo de texto está vacío
  bool isFieldEmpty(TextEditingController controller) {
    return controller.text.isEmpty;
  }

  void checkAllFieldsAndRegisterEvent(BuildContext context) {
    if (event_title.text.isNotEmpty &&
        event_address_title.text.isNotEmpty &&
        event_address.text.isNotEmpty &&
        end_dateController.text.isNotEmpty &&
        start_dateController.text.isNotEmpty &&
        end_time.text.isNotEmpty &&
        start_time.text.isNotEmpty &&
        event_about.text.isNotEmpty &&
        event_about_short.text.isNotEmpty &&
        price.text.isNotEmpty &&
        lat.text.isNotEmpty &&
        long.text.isNotEmpty &&
        Event_sponsore.text.isNotEmpty) {
      print("----------------------TODO FINO-----------------------------");
      print('Categoria: ${cid.text}');
      print('Publico objetivo: ${target_audience.text}');
      print('Titulo del evento: ${event_title.text}');
      print('Imagen evento: ${event_title}');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields'.tr),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Visibility buildEmptyFieldWarning(
    TextEditingController controller,
    bool condition,
  ) {
    return Visibility(
      visible: condition && controller.text.isEmpty,
      child: Text(
        "Please enter this field".tr,
        style: TextStyle(
          color: Colors.red,
          fontSize: 12.0,
        ),
      ),
    );
  }

  Widget bookticket(user, i) {
    return InkWell(
      onTap: () {
        Get.to(() => TicketDetailPage(eID: user[i]["ticket_id"]));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
            border: Border.all(color: notifire.bordercolore),
            borderRadius: BorderRadius.circular(15),
            color: notifire.containercolore),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: height / 7,
                  width: width * 0.32,
                  decoration: const BoxDecoration(
                      // color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: FadeInImage.assetNetwork(
                            fadeInCurve: Curves.easeInCirc,
                            placeholder: "image/skeleton.gif",
                            fit: BoxFit.cover,
                            width: width,
                            height: height,
                            image: Config.base_url + user[i]["event_img"]),
                      ),
                      SizedBox(height: height / 70),
                    ],
                  ),
                ),
                SizedBox(
                  height: height / 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Ink(
                        width: Get.width * 0.54,
                        child: Text(user[i]["event_title"],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: notifire.textcolor,
                                fontSize: 16,
                                fontFamily: 'Gilroy Medium',
                                fontWeight: FontWeight.w600)),
                      ),
                      Ink(
                        width: Get.width * 0.54,
                        child: Text(user[i]["event_sdate"],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: darktextColor,
                              fontSize: 12,
                              fontFamily: 'Gilroy Medium',
                            )),
                      ),
                      Row(
                        children: [
                          Image.asset("image/location.png",
                              height: height / 40),
                          SizedBox(width: Get.width * 0.01),
                          Ink(
                            width: Get.width * 0.46,
                            child: Text(
                              user[i]["event_address"],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Gilroy Medium',
                                  fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: Get.height * 0.015),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ticketbutton(
                  title: "Cancel Booking".tr,
                  bgColor: notifire.getprimerycolor,
                  titleColor: buttonColor,
                  ontap: () {
                    ticketCancell(user[i]["ticket_id"]);
                  },
                ),
                ticketbutton(
                  title: "View E-Ticket".tr,
                  bgColor: buttonColor,
                  titleColor: Colors.white,
                  ontap: () {
                    Get.to(() => TicketDetailPage(eID: user[i]["ticket_id"]));
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  ticketbutton({Function()? ontap, String? title, Color? bgColor, titleColor}) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: Get.height * 0.04,
        width: Get.width * 0.40,
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: (BorderRadius.circular(18)),
            border: Border.all(color: buttonColor, width: 1)),
        child: Center(
          child: Text(title!,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: titleColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  fontFamily: 'Gilroy Medium')),
        ),
      ),
    );
  }

  ticketCancell(ticketid) {
    showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: notifire.containercolore,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: Get.height * 0.02),
                    Container(
                        height: 6,
                        width: 80,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(25))),
                    SizedBox(height: Get.height * 0.02),
                    Text(
                      "Cancel Booking".tr,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Gilroy Bold',
                          color: const Color(0xffF0635A)),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    Text(
                      "Please select the reason for cancellation:".tr,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Gilroy Medium',
                          color: notifire.textcolor),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    ListView.builder(
                      itemCount: cancelList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, i) {
                        return Theme(
                          data: ThemeData(
                              unselectedWidgetColor: notifire.textcolor),
                          child: RadioListTile(
                            dense: true,
                            value: i,
                            activeColor: buttonColor,

                            // tileColor: notifire.textcolor,
                            selected: true,
                            groupValue: selectedRadioTile,
                            title: Text(
                              cancelList[i]["title"],
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Gilroy Medium',
                                  color: notifire.textcolor),
                            ),
                            onChanged: (val) {
                              setState(() {});
                              selectedRadioTile = val;
                              rejectmsg = cancelList[i]["title"];
                            },
                          ),
                        );
                      },
                    ),
                    rejectmsg == "Others"
                        ? SizedBox(
                            height: 50,
                            width: Get.width * 0.85,
                            child: TextField(
                              controller: note,
                              decoration: InputDecoration(
                                  isDense: true,
                                  enabledBorder: myinputborder(
                                      borderColor: notifire.gettextcolor),
                                  focusedBorder: myinputborder(
                                      borderColor: notifire.gettextcolor),
                                  hintText: 'Enter reason'.tr,
                                  hintStyle: TextStyle(
                                      fontFamily: 'Gilroy Medium',
                                      fontSize: height / 55,
                                      color: Colors.grey)),
                            ),
                          )
                        : const SizedBox(),
                    SizedBox(height: Get.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: Get.width * 0.35,
                          height: Get.height * 0.05,
                          child: ticketbutton(
                            title: "Cancel".tr,
                            bgColor: buttonColor,
                            titleColor: Colors.white,
                            ontap: () {
                              Get.back();
                            },
                          ),
                        ),
                        SizedBox(
                          width: Get.width * 0.35,
                          height: Get.height * 0.05,
                          child: ticketbutton(
                            title: "Confirm".tr,
                            bgColor: buttonColor,
                            titleColor: Colors.white,
                            ontap: () {
                              cancelticketApi(ticketid);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.04),
                  ],
                ),
              ),
            );
          });
        });
  }

  List cancelList = [
    {"id": 1, "title": "I have another event, so it collides"},
    {"id": 2, "title": "Imsick. can't come"},
    {"id": 3, "title": "have an urgent need"},
    {"id": 4, "title": "have ne transportation to come"},
    {"id": 5, "title": "thave no friends to come"},
    {"id": 6, "title": "want to book another event"},
    {"id": 7, "title": "just want to cancel"},
    {"id": 8, "title": "Others"},
  ];

  cancelticketApi(ticketid) {
    var addMsg = rejectmsg == "Other" ? note.text : rejectmsg;
    var data = {"uid": uID, "tid": ticketid, "cancle_comment": addMsg};
    print("Api Call type price: :$data");
    ApiWrapper.dataPost(Config.ticketCancel, data).then((val) {
      print("Api Call type price: :$val");

      setState(() {});
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          setState(() {});
          ticketStatusApi();
          Get.back();
        } else {
          setState(() {});
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }
}
