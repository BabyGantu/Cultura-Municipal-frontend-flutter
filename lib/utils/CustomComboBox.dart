import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'colornotifire.dart';
import 'ctextfield.dart';

const String categoriasJson = '''
{
  "categorias": [
    {
      "id": "1",
      "title": "Artes Escénicas",
      "image": "image/fire.png",
      "cover_img": "image/fire.png"
    },
    {
      "id": "2",
      "title": "Música y Conciertos",
      "image": "image/sport1.png",
      "cover_img": "image/discover.png"
    },
    {
      "id": "3",
      "title": "Festivales y Ferias",
      "image": "image/method.png",
      "cover_img": "image/discover.png"
    },
    {
      "id": "4",
      "title": "Deportes",
      "image": "image/american_express.png",
      "cover_img": "image/discover.png"
    },
    {
      "id": "5",
      "title": "Museos y Exposiciones",
      "image": "image/american_express.png",
      "cover_img": "image/discover.png"
    },
    {
      "id": "6",
      "title": "Cursos y Talleres",
      "image": "image/american_express.png",
      "cover_img": "image/discover.png"
    },
    {
      "id": "7",
      "title": "Infantiles",
      "image": "image/american_express.png",
      "cover_img": "image/discover.png"
    },
    {
      "id": "8",
      "title": "Cine",
      "image": "image/american_express.png",
      "cover_img": "image/discover.png"
    },
    {
      "id": "9",
      "title": "Congresos y Convenciones",
      "image": "image/american_express.png",
      "cover_img": "image/discover.png"
    },
    {
      "id": "10",
      "title": "Eventos Literarios",
      "image": "image/american_express.png",
      "cover_img": "image/discover.png"
    },
    {
      "id": "11",
      "title": "Recorridos",
      "image": "image/american_express.png",
      "cover_img": "image/discover.png"
    }
  ]
}
''';

class CustomComboBox extends StatefulWidget {
  final Function(String)? onChanged;
  final Color labelColor;
  final Color textColor;

  const CustomComboBox({
    Key? key,
    this.onChanged,
    required this.labelColor,
    required this.textColor,
  }) : super(key: key);

  @override
  _CustomComboBoxState createState() => _CustomComboBoxState();
}

class _CustomComboBoxState extends State<CustomComboBox> {
  late String _selectedCategoriaId;
  late List<Map<String, String>> _categoriasList;

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
    Map<String, dynamic> categoriasData = json.decode(categoriasJson);
    _categoriasList = (categoriasData['categorias'] as List)
        .map<Map<String, String>>((categoria) =>
    Map<String, String>.from(categoria))
        .toList(); // Convierte a List<Map<String, String>>

    // Establecer el primer elemento como seleccionado por defecto
    _selectedCategoriaId = _categoriasList.first['id']!;
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Category list",
          style: TextStyle(
            color: widget.labelColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        DropdownButtonFormField<String>(
          value: _selectedCategoriaId,
          onChanged: (value) {
            setState(() {
              _selectedCategoriaId = value!;
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            });
          },
          dropdownColor: notifire.getcardcolor,
          decoration: const InputDecoration(
            filled: true,
            //fillColor: notifire.getcardcolor,
          ),
          items: _categoriasList
              .map<DropdownMenuItem<String>>((categoria) {
            return DropdownMenuItem<String>(
              value: categoria['id'],
              child: Row(
                children: [
                  Image.asset(
                    categoria['image']!,
                    width: 24,
                    height: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    categoria['title']!,
                    style: TextStyle(color: widget.textColor),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}


