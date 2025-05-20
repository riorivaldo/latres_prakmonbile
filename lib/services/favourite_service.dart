import 'package:hive/hive.dart';
import '../models/restaurant.dart';

class FavouriteService {
  final Box<Restaurant> _box = Hive.box<Restaurant>('favourites');

  List<Restaurant> getAll() => _box.values.toList();

  bool isFavourite(String id) => _box.containsKey(id);

  Future<void> add(Restaurant r) async {
    await _box.put(r.id, r);
  }

  Future<void> remove(String id) async {
    await _box.delete(id);
  }
}
