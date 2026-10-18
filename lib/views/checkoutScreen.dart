import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/order_provider.dart';
import 'orderSuccessScreen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedPayment = 'Credit Card';
  final TextEditingController _addressController = TextEditingController();
  bool isProcessing = false;
  final currencyFormatter = NumberFormat.currency(symbol: '\$');

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    if (user != null) {
      _addressController.text = user.address;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.black87,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isProcessing
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.green[700]),
                  const SizedBox(height: 20),
                  const Text(
                    'Securing your order...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shipping Address Card
                  const Text(
                    'Shipping Address',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                user?.name ?? 'Customer Name',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _addressController,
                            maxLines: 2,
                            decoration: const InputDecoration(
                              hintText: 'Enter delivery address',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Payment Method Card
                  const Text(
                    'Payment Method',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: RadioGroup<String>(
                      groupValue: selectedPayment,
                      onChanged: (val) => setState(
                        () => selectedPayment = val ?? selectedPayment,
                      ),
                      child: Column(
                        children: [
                          RadioListTile<String>(
                            title: const Row(
                              children: [
                                Icon(Icons.credit_card, color: Colors.blue),
                                SizedBox(width: 10),
                                Text('Credit / Debit Card'),
                              ],
                            ),
                            value: 'Credit Card',
                          ),
                          const Divider(height: 1),
                          RadioListTile<String>(
                            title: const Row(
                              children: [
                                Icon(
                                  Icons.account_balance,
                                  color: Colors.purple,
                                ),
                                SizedBox(width: 10),
                                Text('Direct Bank Transfer'),
                              ],
                            ),
                            value: 'Bank Transfer',
                          ),
                          const Divider(height: 1),
                          RadioListTile<String>(
                            title: const Row(
                              children: [
                                Icon(
                                  Icons.local_shipping,
                                  color: Colors.orange,
                                ),
                                SizedBox(width: 10),
                                Text('Cash on Delivery'),
                              ],
                            ),
                            value: 'Cash on Delivery',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Order Summary Card
                  const Text(
                    'Order Summary',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Items (${cartProvider.totalItemCount}):'),
                              Text(
                                currencyFormatter.format(cartProvider.subtotal),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Tax:'),
                              Text(currencyFormatter.format(cartProvider.tax)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Shipping:'),
                              Text(
                                cartProvider.shippingFee == 0
                                    ? 'FREE'
                                    : currencyFormatter.format(
                                        cartProvider.shippingFee,
                                      ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total to Pay:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                currencyFormatter.format(
                                  cartProvider.grandTotal,
                                ),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[800],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Pay & Confirm CTA
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_addressController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a delivery address'),
                            ),
                          );
                          return;
                        }

                        final orderProvider = context.read<OrderProvider>();
                        final navigator = Navigator.of(context);
                        final addressText = _addressController.text;

                        setState(() => isProcessing = true);
                        await Future.delayed(const Duration(seconds: 2));

                        final order = await orderProvider.placeOrder(
                          cartItems: cartProvider.items,
                          totalAmount: cartProvider.grandTotal,
                          shippingAddress: addressText,
                          paymentMethod: selectedPayment,
                        );

                        cartProvider.clearCart();

                        if (!mounted) return;
                        setState(() => isProcessing = false);
                        navigator.pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (ctx) => OrderSuccessScreen(order: order),
                          ),
                          (route) => route.isFirst,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Pay ${currencyFormatter.format(cartProvider.grandTotal)}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
