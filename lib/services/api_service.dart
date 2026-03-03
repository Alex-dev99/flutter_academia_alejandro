import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;

class ApiService {
  // Para Android emulator usa 10.0.2.2, para dispositivo físico o iOS usa localhost
  // Si estás en PC desktop, usa 127.0.0.1
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2/trabajo-Final/Alejandro-proyecto-web/backend/api';
    } else if (Platform.isIOS) {
      return 'http://127.0.0.1/trabajo-Final/Alejandro-proyecto-web/backend/api';
    } else {
      // Windows, Linux, macOS
      return 'http://127.0.0.1/trabajo-Final/Alejandro-proyecto-web/backend/api';
    }
  }

  // Login de alumno
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

  // Login de profesor
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
}
