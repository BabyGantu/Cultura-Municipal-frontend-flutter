import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'colornotifire.dart';
import 'ctextfield.dart';
import 'package:http/http.dart' as http;



class TargetAudienceComboBox extends StatefulWidget {
  final Function(String)? onChanged;
  final Color labelColor;
  final Color textColor;

  const TargetAudienceComboBox({
    Key? key,
    this.onChanged,
    required this.labelColor,
    required this.textColor,
  }) : super(key: key);

  @override
  _TargetAudienceBoxState createState() => _TargetAudienceBoxState();
}

class _TargetAudienceBoxState extends State<TargetAudienceComboBox> {
  late int _selectedAudienceId = 1;
  List<dynamic> _audienceList = [];

  @override
  void initState() {
    super.initState();
    cargarTargetAudienceApi();
    getdarkmodepreviousstate();
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



  void cargarTargetAudienceApi() async {
    // URL de tu API
    String apiUrl = 'http://10.0.2.2:8000/eventdata/target/';

    // Realiza una solicitud GET a la API
    http.Response response = await http.get(Uri.parse(apiUrl));

    // Verifica si la solicitud fue exitosa (código de estado 200)
    if (response.statusCode == 200) {
      // Decodifica la respuesta JSON con codificación UTF-8
      var jsonResponse = utf8.decode(response.bodyBytes);

      // Guarda las categorías en la lista
      setState(() {
        _audienceList = json.decode(jsonResponse);
      });
      if (_audienceList.isNotEmpty) {
        _selectedAudienceId = _audienceList.first['id']! as int;
        // Haz algo con la ID seleccionada...
      }
    } else {
      // Si la solicitud no fue exitosa, muestra un mensaje de error
      print('Error al cargar categorías: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Target audience".tr,
          style: TextStyle(
            color: widget.labelColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        DropdownButtonFormField<String>(
          value: _selectedAudienceId.toString(),
          onChanged: (value) {
            setState(() {
              _selectedAudienceId = value! as int;
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            });
          },
          dropdownColor: notifire.getcardcolor,
          decoration: const InputDecoration(
            //filled: true,
            //fillColor: notifire.getcardcolor,
          ),
          items: _audienceList
              .map<DropdownMenuItem<String>>((categoria) {
            return DropdownMenuItem<String>(
              value: categoria['id'].toString(),
              child: Container(
                width: 300, // Ancho fijo
                child: Row(
                  children: [
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        categoria['title']!,
                        style: TextStyle(color: widget.textColor),
                        overflow: TextOverflow.visible, // Permite que el texto siga abajo si no cabe en una sola línea
                        maxLines: null, // Permite múltiples líneas
                      ),
                    ),
                  ],
                ),
              )

            );
          }).toList(),
        ),
      ],
    );
  }
}


