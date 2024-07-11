import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'colornotifire.dart';
import 'ctextfield.dart';
import 'package:http/http.dart' as http;

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
  late dynamic _selectedCategoriaId = '';
  List<dynamic> _categoriasList = [];

  @override
  void initState() {
    super.initState();
    cargarCategoriasApi();
    getdarkmodepreviousstate();
  }

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    notifire.setIsDark = previusstate;
    }

/*
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
  */

  

  

  void cargarCategoriasApi() async {
    // URL de tu API
    String apiUrl = 'http://216.225.205.93:3000/api/categorias';

    // Realiza una solicitud GET a la API
    http.Response response = await http.get(Uri.parse(apiUrl));

    // Verifica si la solicitud fue exitosa (código de estado 200)
    if (response.statusCode == 200) {
      // Decodifica la respuesta JSON con codificación UTF-8
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      print('todo bien');

      // Asegúrate de que jsonResponse es un mapa y contiene la clave 'categorias'
      if (jsonResponse is Map && jsonResponse['categorias'] is List) {
        setState(() {
          _categoriasList = jsonResponse['categorias'];
          print(_categoriasList);
          if (_categoriasList.isNotEmpty) {
        _selectedCategoriaId = _categoriasList.first['id'];
        // Haz algo con la ID seleccionada...
      }
        });
      } else {
        print('Error: La respuesta no contiene una lista de categorías.');
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
          "Category list".tr,
          style: TextStyle(
            color: widget.labelColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        DropdownButtonFormField<String>(
          value: _selectedCategoriaId.toString(),
          onChanged: (value) {
            setState(() {
              _selectedCategoriaId = value;
              if (widget.onChanged != null) {
                widget.onChanged!(value!);
              }
            });
          },
          dropdownColor: notifire.getcardcolor,
          decoration: const InputDecoration(
              //filled: true,
              //fillColor: notifire.getcardcolor,
              ),
          items: _categoriasList.map<DropdownMenuItem<String>>((categoria) {
            return DropdownMenuItem<String>(
                value: categoria['id'].toString(),
                child: SizedBox(
                  width: 300, // Ancho fijo
                  child: Row(
                    children: [
                      /*
                      Image(
                        image:NetworkImage(
                          categoria['image']!,
                        
                        ),
                        width: 24,
                        height: 24,
                        
                      ),
*/
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          categoria['nombre']!,
                          style: TextStyle(color: widget.textColor),
                          overflow: TextOverflow
                              .visible, // Permite que el texto siga abajo si no cabe en una sola línea
                          maxLines: null, // Permite múltiples líneas
                        ),
                      ),
                    ],
                  ),
                ));
          }).toList(),
        ),
      ],
    );
  }
}
