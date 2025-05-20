import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant.dart';

class ApiService {
  static const _base = 'https://restaurant-api.dicoding.dev';

  Future<List<Restaurant>> fetchRestaurants() async {
    final res = await http.get(Uri.parse('$_base/list'));
    final body = json.decode(res.body);
    final list = body['restaurants'] as List;
    return list.map((e) => Restaurant.fromJson(e)).toList();
  }

  Future<Restaurant> fetchRestaurantDetail(String id) async {
    final res = await http.get(Uri.parse('$_base/detail/$id'));
    final body = json.decode(res.body)['restaurant'];
    return Restaurant.fromJson(body);
  }
}
