import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/permit_model.dart';

class PermitRepository {
  final String baseUrl;

  PermitRepository({required this.baseUrl});

  Future<List<Permit>> fetchPermits() async {
    final response = await http.get(Uri.parse('$baseUrl/perizinan'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => Permit.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch permits');
    }
  }

  Future<Permit> createPermit(Permit permit) async {
    final response = await http.post(
      Uri.parse('$baseUrl/perizinan'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(permit.toJson()),
    );
    if (response.statusCode == 201) {
      return Permit.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create permit');
    }
  }

  Future<void> approvePermit(int id) async {
    final response =
        await http.put(Uri.parse('$baseUrl/perizinan/$id/approve'));
    if (response.statusCode != 200) {
      throw Exception('Failed to approve permit');
    }
  }

  Future<void> rejectPermit(int id) async {
    final response = await http.put(Uri.parse('$baseUrl/perizinan/$id/reject'));
    if (response.statusCode != 200) {
      throw Exception('Failed to reject permit');
    }
  }
}
