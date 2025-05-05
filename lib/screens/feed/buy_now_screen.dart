import 'package:flutter/material.dart';
import 'package:fiton/models/cart_items_model.dart';
import 'package:fiton/models/order_model.dart'; // Import the Order model
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
// import 'package:fiton/services/paypal_service.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItems> cartItems;
  final double total;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.total,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  String? selectedPaymentId;
  List<Map<String, dynamic>> paymentMethods = [];
  bool isLoading = true;
  final TextEditingController _addressController = TextEditingController();
  String? _savedAddressId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchPaymentMethods();
  }

  Future<void> _fetchPaymentMethods() async {
    try {
      // Fetch payment methods from the payments table
      final paymentResponse = await _supabase
          .from('payments')
          .select('payment_id, method');

      setState(() {
        paymentMethods = List<Map<String, dynamic>>.from(paymentResponse);

        // Add "Cash on Delivery" with exact string
        paymentMethods.add({
          'payment_id': 'cash_on_delivery',
          'method': 'Cash on Delivery', // Exact string from the database
        });

        if (paymentMethods.isNotEmpty) {
          selectedPaymentId = paymentMethods.first['payment_id'] as String?;
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load payment methods: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveAddress() async {
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a delivery address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Save the address to the buyers table
      final response =
          await _supabase.from('buyers').insert({
            'address': _addressController.text,
          }).select();

      if (response.isNotEmpty) {
        setState(() {
          _savedAddressId = response.first['buyer_id'] as String?;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save address: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getOrderStatus(String paymentMethod) {
    // Define your logic for determining the status
    if (paymentMethod.toLowerCase() == 'cash on delivery') {
      return 'Unpaid'; // Default status for cash on delivery
    } else if (paymentMethod.toLowerCase() == 'credit card' ||
        paymentMethod.toLowerCase() == 'debit card') {
      return 'To Ship'; // Default status for card payments
    } else if (paymentMethod.toLowerCase() == 'paypal') {
      return 'Unpaid'; // Default status for PayPal
    } else {
      return 'Unpaid'; // Default status for unknown payment methods
    }
  }

  Future<void> _processPayment(String paymentMethod) async {
    if (_savedAddressId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a delivery address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (paymentMethod.toLowerCase() == 'paypal') {
      // await PayPalService.makePayment(
      //   context: context,
      //   items: widget.cartItems,
      //   total: widget.total,
      //   onSuccess: (Map params) async {
      //     // Create order after successful payment
      //     await _createOrder('PayPal', 'Paid');
      //     Navigator.pop(context);
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(
      //         content: Text('Payment successful! Order placed.'),
      //         backgroundColor: Colors.green,
      //       ),
      //     );
      //   },
      //   onError: (error) {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         content: Text('Payment failed: $error'),
      //         backgroundColor: Colors.red,
      //       ),
      //     );
      //   },
      //   onCancel: (params) {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(
      //         content: Text('Payment cancelled'),
      //         backgroundColor: Colors.orange,
      //       ),
      //     );
      //   },
      // );
    } else {
      // Handle other payment methods
      await _createOrder(paymentMethod, _getOrderStatus(paymentMethod));
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _createOrder(String paymentMethod, String status) async {
    try {
      final orderId = const Uuid().v4();
      final buyerId = _savedAddressId!;
      final shopId =
          'd58d639f-e15d-4b8c-bdfd-c9e44355a049'; // Replace with actual shop ID

      final order = Order(
        orderId: orderId,
        buyerId: buyerId,
        shopId: shopId,
        status: status,
        paymentMethod: paymentMethod,
        totalPrice: widget.total,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _supabase.from('orders').insert(order.toJson());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create order: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF2D1441),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      _buildOrderSummary(),
                      const SizedBox(height: 24),
                      _buildDeliveryAddress(),
                      const SizedBox(height: 24),
                      _buildPaymentMethods(),
                    ],
                  ),
                ),
              ),
              _buildPaymentButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF2D1441),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            const Expanded(
              child: Text(
                'CHECKOUT',
                style: TextStyle(
                  color: Colors.black, // Changed to black
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              'Total: \$${widget.total.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ), // Changed to black
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Summary',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ), // Changed to black
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children:
                widget.cartItems
                    .map(
                      (item) => ListTile(
                        leading: Image.network(
                          item.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image, color: Colors.black);
                          },
                        ),
                        title: Text(
                          item.productName,
                          style: const TextStyle(
                            color: Colors.black,
                          ), // Changed to black
                        ),
                        subtitle: Text(
                          '${item.quantity} x \$${item.productPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.black,
                          ), // Changed to black
                        ),
                        trailing: Text(
                          '\$${(item.productPrice * item.quantity).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ), // Changed to black
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivery Address',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ), // Changed to black
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _addressController,
          decoration: InputDecoration(
            hintText: 'Enter delivery address',
            hintStyle: const TextStyle(
              color: Colors.black54,
            ), // Changed hint text color
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.save,
                color: Colors.black,
              ), // Changed icon color
              onPressed: _saveAddress,
            ),
          ),
          style: const TextStyle(color: Colors.black), // Changed text color
          maxLines: 3,
        ),
        if (_savedAddressId != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Address saved!',
              style: TextStyle(
                color: Colors.green.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ), // Changed to black
        ),
        const SizedBox(height: 12),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : paymentMethods.isEmpty
            ? const Text(
              'No payment methods available.',
              style: TextStyle(color: Colors.black), // Changed to black
            )
            : Column(
              children:
                  paymentMethods
                      .map(
                        (method) => _PaymentOption(
                          method: method['method'] ?? 'No method provided',
                          isSelected: selectedPaymentId == method['payment_id'],
                          onSelect: () {
                            setState(() {
                              selectedPaymentId =
                                  method['payment_id'] as String?;
                            });
                          },
                        ),
                      )
                      .toList(),
            ),
      ],
    );
  }

  Widget _buildPaymentButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () async {
          if (_savedAddressId == null || selectedPaymentId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Please enter an address and select payment method',
                ),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          try {
            final selectedPayment = paymentMethods.firstWhere(
              (method) => method['payment_id'] == selectedPaymentId,
            );

            await _processPayment(selectedPayment['method']);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to process payment: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2D1441),
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text(
          'Place Order',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String method;
  final bool isSelected;
  final VoidCallback onSelect;

  const _PaymentOption({
    required this.method,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF2D1441) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? const Color(0xFF2D1441)
                        : const Color(0xFF2D1441).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.payment,
                color: isSelected ? Colors.white : const Color(0xFF2D1441),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                method,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: Colors.black, // Changed to black
                ),
              ),
            ),
            Radio(
              value: true,
              groupValue: isSelected,
              onChanged: (_) => onSelect(),
              activeColor: const Color(0xFF2D1441),
            ),
          ],
        ),
      ),
    );
  }
}
