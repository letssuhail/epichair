import 'dart:convert';
import 'dart:developer';

import 'package:epic/user/models/offer_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OfferService {
  Future<List<Offer>> getOffers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');

    try {
      final response = await http.get(
        Uri.parse('https://epichair.vercel.app/api/admin/offer'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      log('response offer: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> offerList = data['offer'];
        log('data offer: $offerList');
        return offerList.map((item) => Offer.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e, st) {
      log('Error fetching offers: $e\n$st');
      return [];
    }
  }
}
