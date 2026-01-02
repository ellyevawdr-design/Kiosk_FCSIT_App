class CartItem {
  final String name;
  final double price;
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    this.quantity = 1,
  });
}

class CartModel {
  static final CartModel instance = CartModel._internal();
  CartModel._internal();

  final List<CartItem> items = [];
  bool cutleryAdded = false;
  String paymentMethod = "";

  double get total =>
      items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  void addItem(CartItem item) {
    final index = items.indexWhere((i) => i.name == item.name);
    if (index >= 0) {
      items[index].quantity += 1;
    } else {
      items.add(item);
    }
  }

  void removeItem(CartItem item) {
    items.remove(item);
  }

  void clear() {
    items.clear();
    cutleryAdded = false;
    paymentMethod = "";
  }
}
