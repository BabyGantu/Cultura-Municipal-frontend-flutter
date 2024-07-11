import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class Categoria {
  final int id;
  final String nombre;
  final String imagen;
  final bool statusActive;

  Categoria({
    required this.id,
    required this.nombre,
    required this.imagen,
    required this.statusActive,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'],
      nombre: json['nombre'],
      imagen: json['imagen'],
      statusActive: json['status_active'],
    );
  }
}

class CategoriaService {
  Future<List<Categoria>> cargarCategoriasApi() async {
    String apiUrl = 'http://216.225.205.93:3000/api/categorias';

    try {
      http.Response response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(utf8.decode(response.bodyBytes));

        if (jsonResponse is Map && jsonResponse['categorias'] is List) {
          List<dynamic> categoriasJson = jsonResponse['categorias'];

          List<Categoria> tempCategoriasList = [];

          for (var categoriaJson in categoriasJson) {
            int id = categoriaJson['id'];

            // Obtener detalles de la categoría individual
            Categoria categoria = await obtenerDetallesCategoria(id);
            tempCategoriasList.add(categoria);
          }

          return tempCategoriasList;
        } else {
          throw Exception('La respuesta no contiene una lista de categorías.');
        }
      } else {
        throw Exception('Error al cargar categorías: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al realizar la solicitud: $e');
    }
  }

  Future<Categoria> obtenerDetallesCategoria(int id) async {
    String apiUrl = 'http://216.225.205.93:3000/api/categorias/$id';

    http.Response response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      if (jsonResponse['rta'] == true) {
        var categoriaJson = jsonResponse['categoria'];
        return Categoria.fromJson(categoriaJson);
      } else {
        throw Exception('Error al obtener detalles de la categoría.');
      }
    } else {
      throw Exception('Error al obtener detalles de la categoría: ${response.statusCode}');
    }
  }
}

