import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'colornotifire.dart';
import 'ctextfield.dart';
import 'package:http/http.dart' as http;



class MunicipiosComboBox extends StatefulWidget {
  final Function(String)? onChanged;
  final Color labelColor;
  final Color textColor;

  const MunicipiosComboBox({
    Key? key,
    this.onChanged,
    required this.labelColor,
    required this.textColor,
  }) : super(key: key);

  @override
  _MunicipiosBoxState createState() => _MunicipiosBoxState();
}

class _MunicipiosBoxState extends State<MunicipiosComboBox> {
  late int _selectedmunicipiosId = 1;
  List<dynamic> _municipiosList = [];

  @override
  void initState() {
    super.initState();
    cargarMunicipiosApi();
    getdarkmodepreviousstate();
  }


  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    notifire.setIsDark = previusstate;
    }

 

  

  void cargarMunicipiosApi() async {
    // URL de tu API
    String apiUrl = 'http://216.225.205.93:3000/api/municipios';

    // Realiza una solicitud GET a la API
    http.Response response = await http.get(Uri.parse(apiUrl));

    // Verifica si la solicitud fue exitosa (código de estado 200)
    if (response.statusCode == 200) {
      // Decodifica la respuesta JSON con codificación UTF-8
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      print('todo bien');

      // Asegúrate de que jsonResponse es un mapa y contiene la clave 'categorias'
      if (jsonResponse is Map && jsonResponse['municipios'] is List) {
        setState(() {
          _municipiosList = jsonResponse['municipios'];
          print(_municipiosList);
          if (_municipiosList.isNotEmpty) {
        _selectedmunicipiosId = _municipiosList.first['id'];
        // Haz algo con la ID seleccionada...
      }
        });
      } else {
        print('Error: La respuesta no contiene una lista de Municipios.');
      }
    } else {
      // Si la solicitud no fue exitosa, muestra un mensaje de error
      print('Error al cargar Municipios: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Municipality".tr,
          style: TextStyle(
            color: widget.labelColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        DropdownButtonFormField<String>(
          value: _selectedmunicipiosId.toString(),
          onChanged: (value) {
            setState(() {
              _selectedmunicipiosId = value! as int;
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
          items: _municipiosList
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