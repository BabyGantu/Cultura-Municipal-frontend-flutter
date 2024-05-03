import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'colornotifire.dart';
import 'ctextfield.dart';

const String municipiosJson = '''
{
  "municipios": [
    {
      "id": "1",
      "title": "Hermosillo"
    },
    {
      "id": "2",
      "title": "Cajeme"
    },
    {
      "id": "3",
      "title": "Nogales"
    },
    {
      "id": "4",
      "title": "San Luis Río Colorado"
    },
    {
      "id": "5",
      "title": "Guaymas"
    }
  ]
}
''';

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
  late String _selectedmunicipiosId;
  late List<Map<String, String>> _municipiosList;

  @override
  void initState() {
    super.initState();
    cargarMunicipios();
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

  void cargarMunicipios() {
    // Decodifica la cadena JSON y guarda los eventos en la lista eventosList
    Map<String, dynamic> municipiosData = json.decode(municipiosJson);
    _municipiosList = (municipiosData['municipios'] as List)
        .map<Map<String, String>>((categoria) =>
    Map<String, String>.from(categoria))
        .toList(); // Convierte a List<Map<String, String>>

    // Establecer el primer elemento como seleccionado por defecto
    _selectedmunicipiosId = _municipiosList.first['id']!;
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
          value: _selectedmunicipiosId,
          onChanged: (value) {
            setState(() {
              _selectedmunicipiosId = value!;
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
              value: categoria['id'],
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