import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../services/api_service.dart';
import '../services/favourite_service.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final String restaurantId;
  const RestaurantDetailScreen({required this.restaurantId, super.key});

  @override
  State<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  final ApiService _api = ApiService();
  final FavouriteService _favService = FavouriteService();
  Restaurant? _restaurant;
  bool _loading = true;
  bool _isFav = false;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    final r = await _api.fetchRestaurantDetail(widget.restaurantId);
    setState(() {
      _restaurant = r;
      _isFav = _favService.isFavourite(r.id);
      _loading = false;
    });
  }

  void _toggleFav() async {
    if (_restaurant == null) return;
    final r = _restaurant!;
    if (_isFav) {
      await _favService.remove(r.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berhasil menghapus dari favorite'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      await _favService.add(r);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berhasil menambahkan favorite'),
          backgroundColor: Colors.green,
        ),
      );
    }
    setState(() => _isFav = !_isFav);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Detail'),
        actions: [
          IconButton(
            icon: Icon(_isFav ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFav,
          )
        ],
      ),
      body: _loading || _restaurant == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    'https://restaurant-api.dicoding.dev/images/small/${_restaurant!.pictureId}',
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _restaurant!.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(_restaurant!.city),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 20),
                      Text(' ${_restaurant!.rating}'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(_restaurant!.description),
                ],
              ),
            ),
    );
  }
}
