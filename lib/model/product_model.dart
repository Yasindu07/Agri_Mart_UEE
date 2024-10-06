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
      title: map['title'] ?? 'No Title', // Provide a default value
      category: map['category'] ?? 'Uncategorized',
      quantity: map['quantity'] ?? 0.0,
      description: map['description'] ?? 'No Description',
      location: map['location'] ?? 'Unknown Location',
      pricePerKg: map['pricePerKg'] ?? 0.0,
      imageUrls: List<String>.from(map['imageUrls'] ?? []), // Handle null
      userId: map['userId'] ?? 'Unknown User', // Handle null
    );
  }
}
