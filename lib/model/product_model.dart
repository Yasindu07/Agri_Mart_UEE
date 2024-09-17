class Product {
  String id;
  String title;
  String category;
  double quantity;
  String description;
  String location;
  double pricePerKg;
  List<String> imageUrls;
  String userId; // Add this field

  Product({
    required this.id,
    required this.title,
    required this.category,
    required this.quantity,
    required this.description,
    required this.location,
    required this.pricePerKg,
    required this.imageUrls,
    required this.userId, // Include this in constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'quantity': quantity,
      'description': description,
      'location': location,
      'pricePerKg': pricePerKg,
      'imageUrls': imageUrls,
      'userId': userId, // Add this field
    };
  }

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      title: map['title'],
      category: map['category'],
      quantity: map['quantity'],
      description: map['description'],
      location: map['location'],
      pricePerKg: map['pricePerKg'],
      imageUrls: List<String>.from(map['imageUrls']),
      userId: map['userId'], // Add this field
    );
  }
}
