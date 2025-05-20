import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/restaurant_list_screen.dart';
import 'screens/favourite_screen.dart';
import 'screens/restaurant_detail_screen.dart';
import 'models/restaurant.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register Hive Adapter untuk Restaurant
  Hive.registerAdapter(RestaurantAdapter());
  await Hive.openBox<Restaurant>('favourites');

  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>('users');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const RestaurantListScreen(),
        '/favorites': (context) => const FavouriteScreen(),
      },
      // Route dinamis untuk halaman detail
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final restaurantId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => RestaurantDetailScreen(restaurantId: restaurantId),
          );
        }
        return null;
      },
    );
  }
}
