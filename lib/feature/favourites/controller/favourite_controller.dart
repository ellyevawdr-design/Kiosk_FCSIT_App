// lib/feature/favourites/controller/favourite_controller.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/favourite_repository.dart';
import '../../menu/models/menu_model.dart';
import '../../../utils/util.dart';

final favouriteControllerProvider =
    AsyncNotifierProvider<FavouriteController, List<MenuModel>>(
      FavouriteController.new,
    );

class FavouriteController extends AsyncNotifier<List<MenuModel>> {
  late FakeFavouriteRepository _favouriteRepository;

  @override
  Future<List<MenuModel>> build() async {
    _favouriteRepository = ref.watch(favouriteRepositoryProvider);
    return await _favouriteRepository.getMenuItems();
  }

  Future<void> addMenuToFavourite(MenuModel menu, BuildContext context) async {
    state = const AsyncLoading();
    try {
      await _favouriteRepository.addMenuItem(menu);
      state = AsyncValue.data([...state.value!, menu]);
      showSnackBar(context, "Menu Item Added To Favourites");
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteMenuItem(int index, BuildContext context) async {
    state = const AsyncValue.loading();
    try {
      await _favouriteRepository.deleteMenuItem(index);
      final updatedMenuItems = List<MenuModel>.from(state.value!);
      updatedMenuItems.removeAt(index);
      state = AsyncValue.data(updatedMenuItems);
      showSnackBar(context, "Deleted $index from Favourites");
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
