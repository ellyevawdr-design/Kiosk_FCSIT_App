import 'package:flutter/material.dart';
import '../models/cart_model.dart';

class OrderTrackingPage extends StatefulWidget {
  final String orderNo;
  final bool isPaid;

  const OrderTrackingPage({
    super.key,
    required this.orderNo,
    required this.isPaid,
  });

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  // UPDATED STEPS
  final List<String> steps = ["Menu", "Cart", "Checkout"];
  int currentStep = 0;

  final cart = CartModel.instance;

  @override
  void initState() {
    super.initState();
    _simulateOrderProgress();
  }

  void _simulateOrderProgress() async {
    setState(() => currentStep = 1);

    for (int i = currentStep; i < steps.length; i++) {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      setState(() {
        currentStep = i;
      });
    }
  }

  Color _circleColor(int stepIndex) {
    if (stepIndex < currentStep) return Colors.green;
    if (stepIndex == currentStep) return Colors.blue;
    return Colors.grey;
  }

  Color _lineColor(int stepIndex) {
    if (stepIndex < currentStep) return Colors.green;
    return Colors.grey;
  }

  String getImageForItem(String name) {
    switch (name) {
      case "Beef Sandwich":
        return "assets/images/beef_sandwich.png";
      case "Ham Sandwich":
        return "assets/images/ham_sandwich.png";
      case "Cheese Sandwich":
        return "assets/images/cheese_sandwich.png";
      default:
        return "assets/images/default_food.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Track Order")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order No: ${widget.orderNo}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 24),

            // Progress bar
            Row(
              children: List.generate(steps.length * 2 - 1, (index) {
                if (index.isEven) {
                  int stepIndex = index ~/ 2;
                  return Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: _circleColor(stepIndex),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            stepIndex < currentStep ? Icons.check : null,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        steps[stepIndex],
                        style: TextStyle(
                          color: _circleColor(stepIndex),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  );
                } else {
                  int lineIndex = (index - 1) ~/ 2;
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: 4,
                      color: _lineColor(lineIndex),
                    ),
                  );
                }
              }),
            ),

            const SizedBox(height: 24),

            const Text(
              "Items:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text("Quantity: ${item.quantity}"),
                    trailing: SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.asset(
                        getImageForItem(item.name),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            ListTile(
              leading: const Icon(Icons.restaurant, size: 32),
              title: const Text(
                "Cutlery",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle:
                  Text(cart.cutleryAdded ? "Requested" : "Not Requested"),
            ),

            const Divider(height: 32, thickness: 1),

            ListTile(
              title: const Text(
                "Payment Status",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(widget.isPaid ? "Paid" : "Cash on Delivery"),
              trailing: Icon(
                widget.isPaid ? Icons.check_circle : Icons.money,
                color: widget.isPaid ? Colors.green : Colors.orange,
              ),
            ),

            const SizedBox(height: 16),

            // Final step button
            if (currentStep == steps.length - 1)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(
                        context, (route) => route.isFirst);
                  },
                  child: const Text("Order Completed"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
