class CartFavoriteManager {
  CartFavoriteManager._privateConstructor();
  static final CartFavoriteManager instance =
      CartFavoriteManager._privateConstructor();

  List<Map<String, String>> cartItems = [];
  List<Map<String, String>> favoriteItems = [];

  void addToCart(Map<String, String> item) {
    cartItems.add(item);
  }

  void addToFavorite(Map<String, String> item) {
    favoriteItems.add(item);
  }

  void removeFromCart(int index) {
    cartItems.removeAt(index);
  }

  void removeFromFavorite(int index) {
    favoriteItems.removeAt(index);
  }
}
