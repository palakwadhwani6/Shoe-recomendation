class CartItem {
  final String image;
  final String description;
  final String colors;
  final String price;

  CartItem({
    required this.image,
    required this.description,
    required this.colors,
    required this.price,
});
}
class Cart {
  static final List<CartItem> items = [];

  static void addItem(CartItem item) {
    items.add(item);
  }

  static void removeItem(int index) {
    if (index >= 0 && index < items.length) {
      items.removeAt(index);
    }
  }

  static void clearCard() {
    items.clear();
  }

  static int get itemCount => items.length;

  static List <CartItem> get allItem => List.unmodifiable(items);
}