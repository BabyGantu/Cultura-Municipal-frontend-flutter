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
    notifire.setIsDark = previusstate;
    }



  

  void cargarTargetAudienceApi() async {
    // URL de tu API
    String apiUrl = 'http://216.225.205.93:3000/api/publico-objetivo';

    // Realiza una solicitud GET a la API
    http.Response response = await http.get(Uri.parse(apiUrl));

    // Verifica si la solicitud fue exitosa (código de estado 200)
    if (response.statusCode == 200) {
      // Decodifica la respuesta JSON con codificación UTF-8
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      print('todo bien');

      // Asegúrate de que jsonResponse es un mapa y contiene la clave 'categorias'
      if (jsonResponse is Map && jsonResponse['publicosObjetivos'] is List) {
        setState(() {
          _audienceList = jsonResponse['publicosObjetivos'];
          print(_audienceList);
          if (_audienceList.isNotEmpty) {
        _selectedAudienceId = _audienceList.first['id'];
        // Haz algo con la ID seleccionada...
      }
        });
      } else {
        print('Error: La respuesta no contiene una lista de publico.');
      }
    } else {
      // Si la solicitud no fue exitosa, muestra un mensaje de error
      print('Error al cargar publico: ${response.statusCode}');
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
              child: SizedBox(
                width: 300, // Ancho fijo
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        categoria['nombre']!,
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


