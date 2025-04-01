class Product {
  int id;
  String name;
  String description;
  int price;
  int quantity;
  String image;
  int categoryID;

  Product({
    this.id = 0,
    this.name = '',
    this.description = '',
    this.price = 0,
    this.quantity = 0,
    this.image = '',
    this.categoryID = 0,
  });

  // To parse from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? 0,
      quantity: json['quantity'] ?? 0,
      image: json['image'] ?? '',
      categoryID: json['categoryID'] ?? 0,
    );
  }

  // To convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'image': image,
      'categoryID': categoryID,
    };
  }
}