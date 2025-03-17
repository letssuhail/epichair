import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../consts/const.dart';

const String apiUrl = 'https://epichair.vercel.app/api/service';
// const token = userToken;

class ApiService {
  // Helper function to get the token from SharedPreferences

  // GET request - Fetch all services
  Future<List<dynamic>?> getServices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if token exists
    String? token = prefs.getString('userToken');
    // log(token.toString());
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        // print('Failed to fetch services: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // print('Error fetching services: $e');
      return null;
    }
  }

  // POST request - Create a new service
  Future<bool> createService(String name, String description) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if token exists
    String? token = prefs.getString('userToken');
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'name': name,
          'description': description,
        }),
      );
      if (response.statusCode == 201) {
        // print('Service created successfully');
        return true;
      } else {
        // print('Failed to create service: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // print('Error creating service: $e');
      return false;
    }
  }

  // PUT request - Update a service
  Future<bool> updateService(String id, String name, String description) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if token exists
    String? token = prefs.getString('userToken');
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          '_id': id,
          'name': name,
          'description': description,
        }),
      );
      if (response.statusCode == 200) {
        // print('Service updated successfully');
        return true;
      } else {
        // print('Failed to update service: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // print('Error updating service: $e');
      return false;
    }
  }

  // DELETE request - Delete a service
  Future<bool> deleteService(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if token exists
    String? token = prefs.getString('userToken');
    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          '_id': id,
        }),
      );
      if (response.statusCode == 200) {
        // print('Service deleted successfully');
        return true;
      } else {
        // print('Failed to delete service: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // print('Error deleting service: $e');
      return false;
    }
  }
}
