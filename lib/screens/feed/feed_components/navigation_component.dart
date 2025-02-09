import 'package:flutter/material.dart';

class NavigationComponent extends StatefulWidget {
  const NavigationComponent({Key? key}) : super(key: key);

  @override
  _NavigationComponentState createState() => _NavigationComponentState();
}

class _NavigationComponentState extends State<NavigationComponent> {
  String? selectedButton;
  bool _isTapped = false;

  void _handleTap(String buttonName) {
    setState(() {
      selectedButton = buttonName;
      _isTapped = true;
    });

    // After 300ms, revert back to normal
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _isTapped = false;
      });
    });
  }

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
            buttonName: 'Feed',
          ),
          _buildNavItem(
            icon: 'assets/images/feed/cart-ico.png',
            label: 'Cart',
            buttonName: 'Cart',
          ),
          _buildAddButton(),
          _buildNavItem(
            icon: 'assets/images/feed/fashee-i.png',
            label: 'Fashee',
            buttonName: 'Fashee',
          ),
          _buildNavItem(
            icon: 'assets/images/feed/profile.png',
            label: 'Profile',
            buttonName: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required String icon,
    required String label,
    required String buttonName,
  }) {
    return InkWell(
      onTap: () => _handleTap(buttonName),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedOpacity(
            opacity: _isTapped && selectedButton == buttonName ? 0.3 : 1.0,
            duration: Duration(milliseconds: 200),
            child: Image.asset(
              icon,
              width: 30,
              height: 30,
            ),
          ),
          const SizedBox(height: 1),
          AnimatedOpacity(
            opacity: _isTapped && selectedButton == buttonName ? 0.3 : 1.0,
            duration: Duration(milliseconds: 200),
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return InkWell(
      onTap: () => _handleTap('Add'),
      child: AnimatedOpacity(
        opacity: _isTapped && selectedButton == 'Add' ? 0.3 : 1.0,
        duration: Duration(milliseconds: 200),
        child: Image.asset(
          'assets/images/feed/add-icon.png',
          width: 48,
          height: 48,
        ),
      ),
    );
  }
}
