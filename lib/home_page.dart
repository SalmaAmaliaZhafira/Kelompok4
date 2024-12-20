import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Daftar kategori
  final List<String> categories = ['Flower Board', 'Fresh Flowers'];

  // Daftar produk
  final List<Map<String, dynamic>> products = [
    {
      'name': 'Greeting Flower Board',
      'image': 'https://i.pinimg.com/474x/54/45/3b/54453b2c60a56da7c49208e156b86f05.jpg',
      'description':
          'Specially designed congratulatory flower boards for various events, such as weddings, congratulations, and condolences. Made of high quality materials and decorated with selected fresh flowers.',
      'price': 150000,
      'stock': 10,
      'category': 'Flower Board',
    },
    {
      'name': 'Papan Bunga Pernikahan',
      'image': 'https://i.pinimg.com/236x/74/54/b7/7454b758eeb6a73cff6191b3239f7fca.jpg',
      'description':
          'Wedding flower board with elegant design, perfect to beautify your special event.',
      'price': 200000,
      'stock': 5,
      'category': 'Flower Board',
    },
    {
      'name': 'Bunga Rose',
      'image': 'https://i.pinimg.com/736x/b3/7f/06/b37f065e4cc8ba2778b22c238471435a.jpg',
      'description':
          'Fresh roses are bright red, perfect for a romantic gift or elegant decoration.',
      'price': 50000,
      'stock': 15,
      'category': 'Fresh Flowers',
    },
    {
      'name': 'Bunga Lily',
      'image': 'https://i.pinimg.com/736x/b6/79/c4/b679c4fc12111c788bd394c088fcd692.jpg',
      'description':
          'Fresh lilies that provide a soft fragrance and an elegant appearance.',
      'price': 60000,
      'stock': 8,
      'category': 'Fresh Flowers',
    },
  ];

  // Kategori yang dipilih
  String selectedCategory = 'Flower Board';

  // Variabel pencarian
  String searchQuery = '';

  // Daftar keranjang belanja
  List<Map<String, dynamic>> cart = [];

  // Fungsi untuk menambahkan produk ke keranjang
  void addToCart(Map<String, dynamic> product) {
    setState(() {
      cart.add(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product['name']} successfully added to cart!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Menyaring produk berdasarkan kategori dan pencarian
    final filteredProducts = products
        .where((product) =>
            product['category'] == selectedCategory &&
            product['name']!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Flower Shop'),
        backgroundColor: Colors.pinkAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigasi ke halaman keranjang belanja
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(
                    cart: cart,
                    onRemoveFromCart: (product) {
                      setState(() {
                        cart.remove(product);
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Bagian kategori
          Container(
            color: Colors.pinkAccent,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: categories.map((category) {
                return ChoiceChip(
                  label: Text(category),
                  selected: selectedCategory == category,
                  onSelected: (selected) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  selectedColor: Colors.white,
                  backgroundColor: Colors.pinkAccent,
                  labelStyle: TextStyle(
                    color: selectedCategory == category
                        ? Colors.pinkAccent
                        : Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
          // Kolom pencarian
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search product...',
                prefixIcon: Icon(Icons.search, color: Colors.pinkAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          // Daftar produk
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(
                    child: Text(
                      'Product not found',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              product['image']!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            product['name']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.pinkAccent,
                            ),
                          ),
                          subtitle: Text(
                              'Rp${product['price']} - Stok: ${product['stock']}'),
                          onTap: () {
                            // Navigasi ke halaman detail produk
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailPage(
                                  product: product,
                                  onAddToCart: addToCart,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;
  final Function(Map<String, dynamic>) onAddToCart;

  ProductDetailPage({required this.product, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                product['image']!,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Text(
              product['name'],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent,
              ),
            ),
            SizedBox(height: 8),
            Text(
              product['description'],
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 16),
            Text(
              'Price: Rp${product['price']}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Stock available: ${product['stock']}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                onAddToCart(product);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Center(
                child: Text(
                  'Add to cart',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final List<Map<String, dynamic>> cart;
  final Function(Map<String, dynamic>) onRemoveFromCart;

  CartPage({required this.cart, required this.onRemoveFromCart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: cart.isEmpty
          ? Center(
              child: Text('Your cart is empty'),
            )
          : ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];
                return ListTile(
                  leading: Image.network(item['image']!),
                  title: Text(item['name']),
                  subtitle: Text('Rp${item['price']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      onRemoveFromCart(item);
                    },
                  ),
                );
              },
            ),
    );
  }
}
