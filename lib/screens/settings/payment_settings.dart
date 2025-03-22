import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PaymentSettingsScreen extends StatefulWidget {
  const PaymentSettingsScreen({Key? key}) : super(key: key);

  @override
  State<PaymentSettingsScreen> createState() => _PaymentSettingsScreenState();
}

class _PaymentSettingsScreenState extends State<PaymentSettingsScreen> {
  int selectedCardIndex = 0; // Default selected card (Google Pay)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header with curved background
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 44, left: 16, right: 16, bottom: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF2B0B56), // Dark purple background
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                // Back button
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'PAYMENT METHODS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                // Credit card icon
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D2B58), // Lighter purple
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.credit_card,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Pay with section
                const Text(
                  'Pay with',
                  style: TextStyle(
                    color: Color(0xFF1F1F1F),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),

                // Google Pay
                PaymentMethodCard(
                  icon: const Icon(
                    Icons.g_mobiledata,
                    color: Colors.blue,
                    size: 28,
                  ),
                  iconBackgroundColor: Colors.white,
                  title: 'Google Pay',
                  titleColor: const Color(0xFF1F1F1F),
                  subtitle: 'Connected',
                  subtitleColor: const Color(0xFF707070),
                  isSelected: selectedCardIndex == 0,
                  selectedBorderColor: const Color(0xFF2B0B56),
                  onTap: () {
                    setState(() {
                      selectedCardIndex = 0;
                    });
                  },
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B0B56),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Default',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),

                // PayPal
                PaymentMethodCard(
                  icon: const Icon(
                    Icons.paypal_outlined,
                    color: Color(0xFF003087),
                    size: 24,
                  ),
                  iconBackgroundColor: Colors.white,
                  title: 'Paypal',
                  titleColor: const Color(0xFF1F1F1F),
                  subtitle: 'Not Connected',
                  subtitleColor: const Color(0xFF707070),
                  isSelected: selectedCardIndex == 1,
                  selectedBorderColor: const Color(0xFF2B0B56),
                  onTap: () {
                    setState(() {
                      selectedCardIndex = 1;
                    });
                  },
                ),

                const SizedBox(height: 24),

                // Buy now, Pay Later section
                const Text(
                  'Buy now, Pay Later',
                  style: TextStyle(
                    color: Color(0xFF1F1F1F),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),

                // KoKo
                PaymentMethodCard(
                  icon: const Center(
                    child: Text(
                      'K',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  iconBackgroundColor: const Color(0xFF2B0B56),
                  title: 'Pay Later with KoKo',
                  titleColor: const Color(0xFF1F1F1F),
                  subtitle: 'Setted Up',
                  subtitleColor: const Color(0xFF707070),
                  isSelected: selectedCardIndex == 2,
                  selectedBorderColor: const Color(0xFF2B0B56),
                  onTap: () {
                    setState(() {
                      selectedCardIndex = 2;
                    });
                  },
                ),

                const SizedBox(height: 24),

                // Credit/Debit Cards section
                const Text(
                  'Credit/Debit Cards',
                  style: TextStyle(
                    color: Color(0xFF1F1F1F),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),

                // Visa Card
                PaymentMethodCard(
                  icon: const Icon(
                    Icons.credit_card,
                    color: Color(0xFF1A1F71),
                    size: 24,
                  ),
                  iconBackgroundColor: Colors.white,
                  title: '•••• 4582',
                  titleColor: const Color(0xFF1F1F1F),
                  subtitle: 'Expires 08/25',
                  subtitleColor: const Color(0xFF707070),
                  isSelected: selectedCardIndex == 3,
                  selectedBorderColor: const Color(0xFF2B0B56),
                  onTap: () {
                    setState(() {
                      selectedCardIndex = 3;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // Add new payment method button
                GestureDetector(
                  onTap: () {
                    _showAddCardModal(context);
                  },
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFE0E0E0),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.add,
                          color: Color(0xFF707070),
                          size: 24,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Add',
                          style: TextStyle(
                            color: Color(0xFF707070),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCardModal(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => const AddCardModal(),
    );
  }
}

class AddCardModal extends StatefulWidget {
  const AddCardModal({Key? key}) : super(key: key);

  @override
  State<AddCardModal> createState() => _AddCardModalState();
}

class _AddCardModalState extends State<AddCardModal> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _saveCard = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency, // This ensures TextField has a Material ancestor
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, (1 - _animation.value) * 100),
            child: Opacity(
              opacity: _animation.value,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Modal drag handle
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      alignment: Alignment.center,
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Title
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Add Card',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                            color: Color(0xFF2B0B56)
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Card Preview
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: 180,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2B0B56),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Card elements
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Icon(Icons.wifi, color: Colors.white, size: 22),
                                    Icon(Icons.credit_card, color: Colors.white, size: 22),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                const Text(
                                  '• • • •  • • • •  • • • •  4242',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'CARD HOLDER',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 10,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'JOHN DOE',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'EXPIRES',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 10,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '12/25',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Form Fields
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Card Number Field
                            Row(
                              children: const [
                                Icon(Icons.credit_card, size: 20, color: Color(0xFF2B0B56)),
                                SizedBox(width: 8),
                                Text(
                                  'Card Number',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF2B0B56),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              height: 56,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const TextField(
                                decoration: InputDecoration(
                                  hintText: '1234 5678 9012 3456',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Card Holder Name
                            Row(
                              children: const [
                                Icon(Icons.person_outline, size: 20, color: Color(0xFF2B0B56)),
                                SizedBox(width: 8),
                                Text(
                                  'Card Holder Name',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                      color: Color(0xFF2B0B56),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              height: 56,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const TextField(
                                decoration: InputDecoration(
                                  hintText: 'Enter card holder name',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Expiry Date and CVV
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: const [
                                          Icon(Icons.calendar_today, size: 20, color: Color(0xFF2B0B56)),
                                          SizedBox(width: 8),
                                          Text(
                                            'Expiry Date',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                                color: Color(0xFF2B0B56),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        height: 56,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const TextField(
                                          decoration: InputDecoration(
                                            hintText: 'MM/YY',
                                            hintStyle: TextStyle(color: Colors.grey),
                                            border: InputBorder.none,
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: const [
                                          Icon(Icons.lock_outline, size: 20, color: Color(0xFF2B0B56)),
                                          SizedBox(width: 8),
                                          Text(
                                            'CVV',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                                color: Color(0xFF2B0B56)
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        height: 56,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const TextField(
                                          decoration: InputDecoration(
                                            hintText: '123',
                                            hintStyle: TextStyle(color: Colors.grey),
                                            border: InputBorder.none,
                                          ),
                                          keyboardType: TextInputType.number,
                                          obscureText: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Save Card Option
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _saveCard = !_saveCard;
                                    });
                                  },
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: _saveCard ? const Color(0xFF2B0B56) : Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: _saveCard ? const Color(0xFF2B0B56) : Colors.grey.shade300,
                                      ),
                                    ),
                                    child: _saveCard
                                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Save card for future payments',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                      color: Color(0xFF2B0B56)
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Add Card Button
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2B0B56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: const Size(double.infinity, 56),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Add Card',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PaymentMethodCard extends StatelessWidget {
  final Widget icon;
  final Color iconBackgroundColor;
  final String title;
  final Color titleColor;
  final String subtitle;
  final Color subtitleColor;
  final bool isSelected;
  final Color selectedBorderColor;
  final VoidCallback? onTap;
  final Widget? trailing;

  const PaymentMethodCard({
    Key? key,
    required this.icon,
    required this.iconBackgroundColor,
    required this.title,
    required this.titleColor,
    required this.subtitle,
    required this.subtitleColor,
    required this.isSelected,
    required this.selectedBorderColor,
    this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? selectedBorderColor : const Color(0xFFE0E0E0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          children: [
            // Payment method icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: iconBackgroundColor == Colors.white
                    ? Border.all(color: const Color(0xFFE0E0E0), width: 1)
                    : null,
              ),
              child: Center(child: icon),
            ),
            const SizedBox(width: 16),

            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Optional trailing widget
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}