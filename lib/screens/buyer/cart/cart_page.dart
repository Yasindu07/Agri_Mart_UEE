import 'package:agro_mart/model/cart_model.dart';
import 'package:agro_mart/screens/buyer/cart/productList_cartPage.dart';
import 'package:agro_mart/screens/buyer/order_process.dart';
import 'package:agro_mart/services/cart_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agro_mart/model/product_model.dart';

class CartPage extends StatefulWidget {
  final Product product;
  final String userId;

  const CartPage({
    Key? key,
    required this.product,
    required this.userId,
  }) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cartService = CartService();
  int _quantity = 1;
  double _totalPrice = 0.0;
  List<CartItem> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _totalPrice = widget.product.pricePerKg * _quantity;
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    try {
      final items = await _cartService.getCartItems();
      setState(() {
        _cartItems = items;
      });
    } catch (e) {
      print('Failed to load cart items: $e'); // Debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load cart items: $e')),
      );
    }
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
      _totalPrice = widget.product.pricePerKg * _quantity;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        _totalPrice = widget.product.pricePerKg * _quantity;
      });
    }
  }

  Future<void> _addToCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You need to be logged in to add items to your cart.'),
        ),
      );
      return;
    }

    try {
      // Safely handle null values in product details
      final cartItem = CartItem(
        productId: widget.product.id ?? 'unknown', // Provide a default value
        title: widget.product.title ??
            'Unknown Title', // Default value if title is null
        pricePerKg: widget.product.pricePerKg,
        quantity: _quantity,
        totalPrice: _totalPrice,
        imageUrl: widget.product.imageUrls.isNotEmpty
            ? widget.product.imageUrls[0]
            : 'https://via.placeholder.com/150', // Default image if no image available
        farmerId: widget.product.userId ??
            'unknown', // Default value if farmerId is null
      );

      await _cartService.addToCart(cartItem);
      Fluttertoast.showToast(
        msg: "Product Added Successfully.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      await _fetchCartItems(); // Refresh cart items after adding
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to add to cart: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> _deleteCartItem(String productId) async {
    try {
      await _cartService.deleteCartItem(productId);
      setState(() {
        _cartItems.removeWhere((item) => item.productId == productId);
      });
      Fluttertoast.showToast(
        msg: "Item removed from cart",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to remove item: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  double _calculateTotalCartPrice() {
    double total = 0.0;
    for (var item in _cartItems) {
      total += item.totalPrice;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.06,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.02),
            Row(
              children: [
                Container(
                  width: screenWidth * 0.3,
                  height: screenHeight * 0.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(widget.product.imageUrls.isNotEmpty
                          ? widget.product.imageUrls[0]
                          : 'https://via.placeholder.com/150'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.05),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.title,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        '${widget.product.pricePerKg.toStringAsFixed(2)} Rs / Kg',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quantity:',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: _decrementQuantity,
                    ),
                    Text(
                      _quantity.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _incrementQuantity,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              'Total Price: ${_totalPrice.toStringAsFixed(2)} Rs',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _addToCart(); // Add parentheses to invoke the function
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartDisplayPage(),
                    ),
                  );
                },
                child: Text(
                  'Add To Cart',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.2,
                    vertical: screenHeight * 0.013,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            // Text(
            //   'Cart Items:',
            //   style: GoogleFonts.poppins(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.black,
            //   ),
            // ),
            SizedBox(height: screenHeight * 0.02),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: _cartItems.length,
            //     itemBuilder: (context, index) {
            //       final item = _cartItems[index];
            //       return ListTile(
            //         leading: Image.network(
            //           item.imageUrl.isNotEmpty
            //               ? item.imageUrl
            //               : 'https://via.placeholder.com/150',
            //           width: 50,
            //           height: 50,
            //           fit: BoxFit.cover,
            //         ),
            //         title: Text(item.title, style: GoogleFonts.poppins()),
            //         subtitle: Text(
            //             '${item.quantity} x ${item.pricePerKg.toStringAsFixed(2)} Rs / Kg'),
            //         trailing: Row(
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             Text('${item.totalPrice.toStringAsFixed(2)} Rs'),
            //             IconButton(
            //               icon: Icon(Icons.delete),
            //               onPressed: () => _deleteCartItem(item.productId),
            //               color: Colors.red,
            //             ),
            //           ],
            //         ),
            //       );
            //     },
            //   ),
            // ),
            SizedBox(height: screenHeight * 0.03),
            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: Center(
            //     child: ElevatedButton(
            //       onPressed: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => OrderProcessPage(
            //               cartItems: _cartItems,
            //               totalAmount: _calculateTotalCartPrice(),
            //             ),
            //           ),
            //         );
            //       },
            //       child: Text(
            //         'Checkout: ${_calculateTotalCartPrice().toStringAsFixed(2)} Rs',
            //         style: GoogleFonts.poppins(
            //           fontSize: 20,
            //           fontWeight: FontWeight.w600,
            //           color: Colors.white,
            //         ),
            //       ),
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Theme.of(context).colorScheme.primary,
            //         padding: EdgeInsets.symmetric(
            //           horizontal: screenWidth * 0.2,
            //           vertical: screenHeight * 0.013,
            //         ),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
