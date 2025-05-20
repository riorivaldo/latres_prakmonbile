import 'package:flutter/material.dart';
import '../services/favourite_service.dart';
import '../models/restaurant.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});
  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final FavouriteService _favService = FavouriteService();
  late List<Restaurant> _list;

  @override
  void initState() {
    super.initState();
    _list = _favService.getAll();
  }

  void _remove(String id) async {
    await _favService.remove(id);
    setState(() {
      _list = _favService.getAll();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Berhasil menghapus favorite'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favourite Page')),
      body: _list.isEmpty
          ? const Center(child: Text('Belum ada favourite'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _list.length,
              itemBuilder: (ctx, i) {
                final r = _list[i];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    leading: Image.network(
                      'https://restaurant-api.dicoding.dev/images/small/${r.pictureId}',
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(r.name),
                    subtitle: Text('${r.city} · Rating: ${r.rating}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _remove(r.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
