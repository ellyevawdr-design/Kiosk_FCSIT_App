import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  static const Color primaryBlue = Color(0xFF007BFF);

  final List<String> _imagesToPrecache = [
    'assets/images/coke.jpg',
    'assets/images/soup.jpg',
    'assets/images/cake.jpg',
  ];

  bool _imagesPrecached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_imagesPrecached) {
      for (var img in _imagesToPrecache) {
        precacheImage(AssetImage(img), context);
      }
      _imagesPrecached = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 330,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(120),
                      bottomRight: Radius.circular(120),
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 30,
                  right: 30,
                  child: SizedBox(
                    height: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        _FoodImage('assets/images/coke.jpg'),
                        _FoodImage('assets/images/soup.jpg'),
                        _FoodImage('assets/images/cake.jpg'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35),
            const Text(
              "Tap To Order",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.0),
              child: Text(
                "Order your favorite meal for self–service or self–pickup",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: ElevatedButton(
                onPressed: () {
                  print('Button pressed, going to /home');
                  Routemaster.of(context).push('/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Tap To Order",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _FoodImage extends StatelessWidget {
  final String assetPath;
  const _FoodImage(this.assetPath);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      child: Image.asset(assetPath, fit: BoxFit.contain, cacheWidth: 180),
    );
  }
}
