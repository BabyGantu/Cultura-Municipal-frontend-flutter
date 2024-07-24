import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Evento {
  final int id;
  final String tituloEvento;
  final String imagenEvento; // Puede ser null
  final String imagenPortadaEvento; // Puede ser null
  final String fechaInicio;
  final String fechaFin;
  final String horaInicio;
  final String horaFin;
  final String precio;
  final String descripcionBreve;
  final String descripcion;
  final String? galeriaImagen1; // Puede ser null
  final String? galeriaImagen2; // Puede ser null
  //final String? galeriaImagen3; // Puede ser null
  final String organizador;
  final String telefono;
  final String correo;
  final String tituloDireccion;
  final String direccionEvento;
  final double latitud;
  final double longitud;
  final int idUsuario;
  final int idMunicipio;
  final int idCategoria;
  final int idPublicoObjetivo;
  final int statusEvent;
  final bool statusActive;

  Evento({
    required this.id,
    required this.tituloEvento,
    required this.imagenEvento,
    required this.imagenPortadaEvento,
    required this.fechaInicio,
    required this.fechaFin,
    required this.horaInicio,
    required this.horaFin,
    required this.precio,
    required this.descripcionBreve,
    required this.descripcion,
    this.galeriaImagen1,
    this.galeriaImagen2,
    //this.galeriaImagen3,
    required this.organizador,
    required this.telefono,
    required this.correo,
    required this.tituloDireccion,
    required this.direccionEvento,
    required this.latitud,
    required this.longitud,
    required this.idUsuario,
    required this.idMunicipio,
    required this.idCategoria,
    required this.idPublicoObjetivo,
    required this.statusEvent,
    required this.statusActive,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'] ?? 0, // Valor predeterminado si es null
      tituloEvento: json['titulo_evento'] ?? '',
      imagenEvento: json['imagen_evento'], // Puede ser null
      imagenPortadaEvento: json['imagen_portada_evento'], // Puede ser null
      fechaInicio: json['fecha_inicio'] ?? '',
      fechaFin: json['fecha_fin'] ?? '',
      horaInicio: json['hora_inicio'] ?? '',
      horaFin: json['hora_fin'] ?? '',
      precio: json['precio'] ?? '',
      descripcionBreve: json['descripcion_breve'] ?? '',
      descripcion: json['descripcion'] ?? '',
      galeriaImagen1: json['galeria_imagen_1'], // Puede ser null
      galeriaImagen2: json['galeria_imagen_2'], // Puede ser null
      //galeriaImagen3: json['galeria_imagen_3'], // Puede ser null
      organizador: json['organizador'] ?? '',
      telefono: json['telefono'] ?? '',
      correo: json['correo'] ?? '',
      tituloDireccion: json['titulo_direccion'] ?? '',
      direccionEvento: json['direccion_evento'] ?? '',
      latitud: json['latitud'] != null ? double.tryParse(json['latitud']) ?? 0.0 : 0.0,
      longitud: json['longitud'] != null ? double.tryParse(json['longitud']) ?? 0.0 : 0.0,
      idUsuario: json['id_usuario'] ?? 0,
      idMunicipio: json['id_municipio'] ?? 0,
      idCategoria: json['id_categoria'] ?? 0,
      idPublicoObjetivo: json['id_publico_objetivo'] ?? 0,
      statusEvent: json['status_event'] ?? 0,
      statusActive: json['status_active'] == 1,
    );
  }
}

class EventosService {
  Future<List<Evento>> cargarEventosApi() async {
  String apiUrl = 'http://216.225.205.93:3000/api/eventos/buscarEventos';

  try {
    final Map<String, dynamic> bodyData = {
      'id_categoria': 3
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(bodyData),
    );

    // Imprimir la respuesta para depuración
    //print('Respuesta del servidor: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));

      // Verificar el tipo de jsonResponse
      //print('jsonResponse: $jsonResponse');

      if (jsonResponse is Map && jsonResponse['eventos'] is List) {
        List<dynamic> eventosJson = jsonResponse['eventos'];

        List<Evento> tempEventosList = [];

        for (var eventoJson in eventosJson) {
          int id = eventoJson['id'];

          // Obtener detalles del evento individual
          try {
            Evento evento = await obtenerDetallesEvento(id);
            tempEventosList.add(evento);
          } catch (e) {
            print('Error al procesar el evento con ID $id: $e');
            // Opcional: manejar el error según sea necesario
          }
        }

        return tempEventosList;
      } else {
        throw Exception('La respuesta no contiene una lista de Eventos.');
      }
    } else {
      throw Exception('Error al cargar Eventos: ${response.statusCode}');
    }
  } catch (e) {
    print('Error en cargarEventosApi: $e');
    throw Exception('Error al realizar la solicitud: $e');
  }
}


  Future<Evento> obtenerDetallesEvento(int id) async {
  final Uri url = Uri.parse('http://216.225.205.93:3000/api/eventos/$id');

  try {
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));

      // Verifica si 'rta' es verdadero y si 'eventos' no es null
      if (jsonResponse['rta'] == true) {
        var eventoJson = jsonResponse['evento'];
        //print('Respuesta del servidor: ${eventoJson}');

        // Asegúrate de que 'eventos' sea un mapa
        if (eventoJson != null && eventoJson is Map<String, dynamic>) {
          return Evento.fromJson(eventoJson);
        } else {
          throw Exception('La respuesta del servidor no contiene un evento válido.');
        }
      } else {
        throw Exception('Error al obtener detalles del evento. es null');
      }
    } else {
      throw Exception('Error al obtener detalles del evento: ${response.statusCode}');
    }
  } catch (e) {
    print('Error en obtenerDetallesEvento: $e');
    throw Exception('Error al realizar la solicitud: $e');
  }
}

}
