import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'colornotifire.dart';
import 'ctextfield.dart';

const String audienceJson = '''
{
  "categorias": [
    {
      "id": "1",
      "title": "Público en general",
      "image": "image/fire.png",
      "cover_img": "image/fire.png"
    },
    {
      "id": "2",
      "title": "Niños",
      "image": "image/sport1.png",
      "cover_img": "image/discover.png"
    },
    {
      "id": "3",
      "title": "Jóvenes",
      "image": "image/method.png",
      "cover_img": "image/discover.png"
    },
    {
      "id": "4",
      "title": "Adultos",
      "image": "image/american_express.png",
      "cover_img": "image/discover.png"
    },
    {
      "id": "5",
      "title": "Adultos mayores",
      "image": "image/american_express.png",
      "cover_img": "image/discover.png"
    },
    {
      "id": "6",
      "title": "Personas con necesidades especiales (neurodiversas o discapacidad)",
      "image": "image/american_express.png",
      "cover_img": "image/discover.png"
    }
  ]
}
''';

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
  late String _selectedAudienceId;
  late List<Map<String, String>> _audienceList;

  @override
  void initState() {
    super.initState();
    cargarCategorias();
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

  void cargarCategorias() {
    // Decodifica la cadena JSON y guarda los eventos en la lista eventosList
    Map<String, dynamic> categoriasData = json.decode(audienceJson);
    _audienceList = (categoriasData['categorias'] as List)
        .map<Map<String, String>>((categoria) =>
    Map<String, String>.from(categoria))
        .toList(); // Convierte a List<Map<String, String>>

    // Establecer el primer elemento como seleccionado por defecto
    _selectedAudienceId = _audienceList.first['id']!;
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Target audience",
          style: TextStyle(
            color: widget.labelColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        DropdownButtonFormField<String>(
          value: _selectedAudienceId,
          onChanged: (value) {
            setState(() {
              _selectedAudienceId = value!;
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


