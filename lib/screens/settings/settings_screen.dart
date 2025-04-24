import 'package:fiton/screens/settings/payment_settings.dart';
import 'package:flutter/material.dart';

import 'addressbook.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive calculations
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 360;
    final bool isLargeScreen = screenSize.width > 600;

    // Define the theme colors
    final Color purpleColor = const Color(0xFF21004D);

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              // Top bar with curved bottom
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: screenSize.height * 0.02,
                  horizontal: screenSize.width * 0.04,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF21004D),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Row(
                  children: [
                    // Active back button
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'SETTINGS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(50),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.nightlight_round,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              // Main content - List of settings cards
              Expanded(
                child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth * 0.04,
                          vertical: constraints.maxHeight * 0.02,
                        ),
                        child: Column(
                          children: [
                            // Account section
                            _buildSettingsButton(
                              context: context,
                              title: 'Account',
                              icon: Icons.person_outline,
                              isSmallScreen: isSmallScreen,
                              isLargeScreen: isLargeScreen,
                              trailingWidget: isSmallScreen
                                  ? const Icon(Icons.chevron_right, color: Colors.grey)
                                  : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: purpleColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.image_outlined, size: isSmallScreen ? 14 : 16),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Change\nPicture',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: isSmallScreen ? 8 : 10 ,
                                            color: Color(0xFF21004D))
                                        ,
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: isSmallScreen ? 10 : 20),
                                  Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: purpleColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.phone_outlined, size: isSmallScreen ? 14 : 16),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Change\nNumber',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: isSmallScreen ? 8 : 10,color: Color(0xFF21004D),),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: isSmallScreen ? 4 : 8),
                                  const Icon(Icons.chevron_right, color: Colors.grey),
                                ],
                              ),
                              onTap: () {
                                // Handle account tap
                              },
                            ),

                            // Address Book
                            _buildSettingsButton(
                              context: context,
                              title: 'Address Book',
                              subtitle: 'Home, Office & More',
                              icon: Icons.location_on_outlined,
                              isSmallScreen: isSmallScreen,
                              isLargeScreen: isLargeScreen,
                              onTap: ()  {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddressBookScreen(),
                                  ),
                                );
                              },
                            ),

                            // Payment Methods
                            _buildSettingsButton(
                              context: context,
                              title: 'Payment Methods',
                              icon: Icons.credit_card_outlined,
                              isSmallScreen: isSmallScreen,
                              isLargeScreen: isLargeScreen,
                              trailingWidget: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: isSmallScreen ? 4 : 6,
                                        vertical: isSmallScreen ? 2 : 3
                                    ),
                                    decoration: BoxDecoration(
                                      color: purpleColor,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                        'VISA',
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 8 : 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        )
                                    ),
                                  ),
                                  SizedBox(width: isSmallScreen ? 4 : 6),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: isSmallScreen ? 4 : 6,
                                        vertical: isSmallScreen ? 2 : 3
                                    ),
                                    decoration: BoxDecoration(
                                      color: purpleColor,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                        'G Pay',
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 8 : 10,
                                          color: Colors.white,
                                        )
                                    ),
                                  ),
                                  SizedBox(width: isSmallScreen ? 4 : 6),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: isSmallScreen ? 1 : 2,
                                        vertical: isSmallScreen ? 2 : 3
                                    ),
                                    decoration: BoxDecoration(
                                      color: purpleColor,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Icon(Icons.paypal, size: isSmallScreen ? 12 : 14, color: Colors.white),
                                  ),
                                  SizedBox(width: isSmallScreen ? 4 : 8),
                                  Icon(Icons.chevron_right, color: purpleColor, size: isSmallScreen ? 18 : 24),
                                ],
                              ),
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentSettingsScreen(),
                                  ),
                                );
                              },
                            ),

                            // Notifications
                            _buildSettingsButton(
                              context: context,
                              title: 'Notifications',
                              subtitle: 'Orders & Promotions',
                              icon: Icons.notifications_outlined,
                              isSmallScreen: isSmallScreen,
                              isLargeScreen: isLargeScreen,
                              onTap: () {
                                // Handle notifications tap
                              },
                            ),

                            // TryOn Settings
                            _buildSettingsButton(
                              context: context,
                              title: 'TryOn Settings',
                              subtitle: 'Manage Images & History',
                              icon: Icons.checkroom_outlined,
                              isSmallScreen: isSmallScreen,
                              isLargeScreen: isLargeScreen,
                              onTap: () {
                                // Handle try on settings tap
                              },
                            ),

                            // Subscription Plan
                            _buildSettingsButton(
                              context: context,
                              title: 'Subscription Plan',
                              subtitle: 'Free Plan',
                              icon: Icons.crop,
                              isSmallScreen: isSmallScreen,
                              isLargeScreen: isLargeScreen,
                              onTap: () {
                                // Handle subscription plan tap
                              },
                            ),

                            // Legal
                            _buildSettingsButton(
                              context: context,
                              title: 'Legal',
                              subtitle: 'Privacy & Terms',
                              icon: Icons.shield_outlined,
                              isSmallScreen: isSmallScreen,
                              isLargeScreen: isLargeScreen,
                              onTap: () {
                                // Handle legal tap
                              },
                            ),

                            // Delete Account Button
                            GestureDetector(
                              onTap: () {
                                // Handle delete account
                              },
                              child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                    top: isSmallScreen ? 16 : 24,
                                    bottom: isSmallScreen ? 8 : 12
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: isSmallScreen ? 8 : 12,
                                    horizontal: isSmallScreen ? 12 : 16
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF1F1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.delete_outlined,
                                      color: Colors.red,
                                      size: isSmallScreen ? 16 : 20,
                                    ),
                                    SizedBox(width: isSmallScreen ? 4 : 8),
                                    Text(
                                      'Delete Account',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                        fontSize: isSmallScreen ? 13 : 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Logout Button
                            GestureDetector(
                              onTap: () {
                                // Handle logout
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: isSmallScreen ? 16 : 24),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      color: Colors.black54,
                                      size: isSmallScreen ? 16 : 18,
                                    ),
                                    SizedBox(width: isSmallScreen ? 4 : 8),
                                    Text(
                                      'Logout',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                        fontSize: isSmallScreen ? 13 : 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    String? subtitle,
    Widget? trailingWidget,
    required VoidCallback onTap,
    required bool isSmallScreen,
    required bool isLargeScreen,
  }) {
    // Define the purple color that matches the app theme
    final Color purpleColor = const Color(0xFF21004D);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isLargeScreen ? 20 : 16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(18),
              blurRadius: 10,
              offset: const Offset(0, 3),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 16,
              vertical: isSmallScreen ? 12 : 16
          ),
          child: Row(
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                decoration: BoxDecoration(
                  color: purpleColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: isSmallScreen ? 16 : 20,
                ),
              ),
              SizedBox(width: isSmallScreen ? 12 : 16),

              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : (isLargeScreen ? 18 : 16),
                        fontWeight: FontWeight.w600,
                        color: purpleColor,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 10 : 12,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),

              // Trailing widget or chevron
              trailingWidget ?? Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                  size: isSmallScreen ? 18 : 24
              ),
            ],
          ),
        ),
      ),
    );
  }
}