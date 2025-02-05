import 'package:flutter/material.dart';

class NavigationComponent extends StatelessWidget {
  const NavigationComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Color(0xFF010101).withOpacity(0.65),
        border: Border(
          top: BorderSide(
            color: Colors.white,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            icon: 'assets/images/feed/feed-ico.png',
            label: 'Feed',
          ),
          _buildNavItem(
            icon: 'assets/images/feed/cart-ico.png',
            label: 'Cart',
          ),
          _buildAddButton(),
          _buildNavItem(
            icon: 'assets/images/feed/fashee-i.png',
            label: 'Fashee',
          ),
          _buildNavItem(
            icon: 'assets/images/feed/profile.png',
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({required String icon, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          icon,
          width: 30,
          height: 30,
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return Image.asset('assets/images/feed/add-icon.png',width: 48,height: 48,);
  }
}

