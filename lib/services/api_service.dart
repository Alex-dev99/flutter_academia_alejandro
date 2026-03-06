import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;

class ApiService {
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2/proyectoFinal/Alejandro-proyecto-web/backend/api';
    } else if (Platform.isIOS) {
      return 'http://127.0.0.1/proyectoFinal/Alejandro-proyecto-web/backend/api';
    } else {
      return 'http://127.0.0.1/proyectoFinal/Alejandro-proyecto-web/backend/api';
    }
  }

  static Future<Map<String, dynamic>> loginAlumno({
    required String emailONombre,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/alumnos_login.php'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': emailONombre,
          'password': password,
        }),
      );

      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && responseData['success'] == true) {
        return {
          'success': true,
          'usuario': responseData['usuario'],
          'message': responseData['message'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Error en la autenticación',
          'type': responseData['type'] ?? 'unknown_error',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
        'type': 'connection_error',
      };
    }
  }

  static Future<Map<String, dynamic>> loginProfesor({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/profesores_login.php'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && responseData['success'] == true) {
        return {
          'success': true,
          'usuario': responseData['usuario'],
          'message': responseData['message'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Error en la autenticación',
          'type': responseData['type'] ?? 'unknown_error',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
        'type': 'connection_error',
      };
    }
  }

  static Future<Map<String, dynamic>> getProfesorHorarios(int idProfesor) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profesores_horarios.php?id_profesor=$idProfesor'),
      );

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && responseData['success'] == true) {
        return {
          'success': true,
          'horarios': responseData['horarios'] ?? [],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Error al obtener horarios',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> getProfesorAlumnos(int idProfesor) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profesores_alumnos.php?id_profesor=$idProfesor'),
      );

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && responseData['success'] == true) {
        return {
          'success': true,
          'alumnos': responseData['alumnos'] ?? [],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Error al obtener alumnos',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> getAulas() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/aulas.php'),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData is List) {
        return {
          'success': true,
          'aulas': responseData,
        };
      } else {
        return {
          'success': false,
          'message': 'Error al obtener aulas',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> getAlumnoHorarios(int idAlumno) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/alumnos_horarios.php?id_alumno=$idAlumno'),
      );

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && responseData['success'] == true) {
        return {
          'success': true,
          'horarios': responseData['horarios'] ?? [],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Error al obtener horarios',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> getAlumnoRecibos(int idAlumno) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/alumnos_recibos.php?id_alumno=$idAlumno'),
      );

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && responseData['success'] == true) {
        return {
          'success': true,
          'recibos': responseData['recibos'] ?? [],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Error al obtener recibos',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> marcarReciboPagado(int idRecibo) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/marcar_recibo_pagado.php'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id_recibo': idRecibo,
        }),
      );

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && responseData['success'] == true) {
        return {
          'success': true,
          'message': responseData['message'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Error al marcar recibo',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }
}
