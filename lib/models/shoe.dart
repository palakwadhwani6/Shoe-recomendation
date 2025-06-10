class Shoe {
  final int id;
  final String name;
  final String brand;
  final double price;

  Shoe({required this.id, required this.name, required this.brand, required this.price});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'price': price,
    };
  }

  factory Shoe.fromMap(Map<String, dynamic> map) {
    return Shoe(
      id: map['id'],
      name: map['name'],
      brand: map['brand'],
      price: map['price'],
    );
  }
}
