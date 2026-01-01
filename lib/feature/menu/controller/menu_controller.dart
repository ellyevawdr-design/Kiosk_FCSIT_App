// lib/feature/menu/controller/menu_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:networkclan_kiosk_fcsit_app/fakedata/fakedata.dart';
import '../models/menu_model.dart';
import '../repository/menurepository.dart';

final menuControllerProvider =
    AsyncNotifierProvider<MenuController, List<MenuModel>>(MenuController.new);

// For getting all menus
final getMenusProvider = StreamProvider<List<MenuModel>>(
  (ref) => ref.watch(menuControllerProvider.notifier).getMenuItems(),
);

// For getting menus by category
final getMenuByIdProvider = StreamProvider.family<List<MenuModel>, String>(
  (ref, String categoryId) => ref
      .watch(menuControllerProvider.notifier)
      .getMenuItemsByCategory(categoryId),
);

class MenuController extends AsyncNotifier<List<MenuModel>> {
  late FakeMenuRepository _menuRepository;

  @override
  List<MenuModel> build() {
    _menuRepository = ref.watch(menuRepositoryProvider);
    // Initial offline data
    return FakeData.menu;
  }

  Stream<List<MenuModel>> getMenuItems() {
    return _menuRepository.getMenus();
  }

  Stream<List<MenuModel>> getMenuItemsByCategory(String categoryId) {
    return _menuRepository.getMenuById(categoryId);
  }
}
