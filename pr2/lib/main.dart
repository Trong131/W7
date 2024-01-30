import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen(this.product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiet san pham'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Brand: ${product.brands_filter_facet}'),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Price: ${product.price}'),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Info: ${product.product_additional_info}'),
          ),
          Image.network(product.search_image)
        ],
      ),
    );
  }
}

// Thiết kế Model
class Product {
  String search_image;
  String styleid;
  String brands_filter_facet;
  String price;
  String product_additional_info;

  Product(
      {required this.search_image,
        required this.styleid,
        required this.brands_filter_facet,
        required this.price,
        required this.product_additional_info});
}

//Activity;
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

//Lấy dữ liệu từ server về
class _ProductListScreenState extends State<ProductListScreen> {
  late List<Product> products;

  // Hàm khởi tạo
  @override
  void initState() {
    super.initState();
    products = [];
    fetchProducts(); // Hàm lấy dữ liệu từ server
  }

  // Hàm đọc dữ liệu từ Server
  Future<void> fetchProducts() async {
    final response =
    await http.get(Uri.parse("http://192.168.1.8/sever/get.php"));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        products = convertMapToList(data);
      });
    } else {
      throw Exception("Khong doc duoc du lieu");
    }
  }

  // Hàm convert Map thành list
  List<Product> convertMapToList(Map<String, dynamic> data) {
    List<Product> productList = [];
    data.forEach((key, value) {
      for (int i = 0; i < value.length; i++) {
        Product product = Product(
            search_image: value[i]['search_image'] ?? '',
            styleid: value[i]['styleid'] ?? 0,
            brands_filter_facet: value[i]['brands_filter_facet'] ?? '',
            price: value[i]['price'] ?? 0,
            product_additional_info: value[i]['product_additional_info'] ?? '');

        productList.add(product);
      }
    });
    return productList;
  }

  // Tạo Layout như XML
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Danh sách sản phẩm")),
      body: products != null
          ? ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(products[index].brands_filter_facet),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price: ${products[index].price}'),
                  Text(
                      'Product_additional_info: ${products[index].product_additional_info}'),
                ],
              ),
              leading: Image.network(
                products[index].search_image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(products[index])));
              },
            );
          })
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

//Android Manifest

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Danh sach san pham',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomeScreen()
      // ProductListScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trang chu"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductListScreen()),
            );
          },
          child: Text('Go to ProductListScreen'),
        ),
      ),
    );
  }
}