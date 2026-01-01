// lib/feature/favourites/repository/favourite_repository.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/menu/models/menu_model.dart';

final favouriteRepositoryProvider = Provider<FakeFavouriteRepository>(
  (_) => FakeFavouriteRepository(),
);

class FakeFavouriteRepository {
  // In-memory list for offline testing
  final List<MenuModel> _favouriteItems = [];

  // Get current favourites
  Future<List<MenuModel>> getMenuItems() async {
    return _favouriteItems;
  }

  // Add a menu item to favourites
  Future<void> addMenuItem(MenuModel menu) async {
    _favouriteItems.add(menu);
  }

  // Delete a menu item from favourites by index
  Future<void> deleteMenuItem(int index) async {
    if (index >= 0 && index < _favouriteItems.length) {
      _favouriteItems.removeAt(index);
    }
  }
}
