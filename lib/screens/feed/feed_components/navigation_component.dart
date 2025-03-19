import 'package:flutter/material.dart';
import 'package:fiton/services/navigation_service.dart';

class NavigationComponent extends StatefulWidget {
  const NavigationComponent({Key? key}) : super(key: key);

  @override
  _NavigationComponentState createState() => _NavigationComponentState();
}

class _NavigationComponentState extends State<NavigationComponent> {
  String? selectedButton;
  bool _isTapped = false;

  void _handleTap(String buttonName, BuildContext context) {
    setState(() {
      selectedButton = buttonName;
      _isTapped = true;
    });

    // After 300ms, revert back to normal
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isTapped = false;
        });
      }
    });

    // Use safer navigation approach
    try {
      String route = '';
      switch (buttonName) {
        case 'Feed':
          route = NavigationService.feedRoute;
          break;
        case 'Cart':
          route = NavigationService.cartRoute;
          break;
        case 'Fashee':
          route = NavigationService.fasheeRoute;
          break;
        case 'Profile':
          route = NavigationService.profileRoute;
          break;
        default:
          return;
      }

      // Use Navigator.pushReplacementNamed instead of NavigationService
      Navigator.pushReplacementNamed(context, route).catchError((error) {
        print('Navigation error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error navigating to $buttonName: $error'),
            backgroundColor: Colors.red,
          ),
        );
      });
    } catch (e) {
      print('Navigation error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error navigating to $buttonName: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';
    
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
            icon: Icons.home_outlined,
            label: 'Feed',
            buttonName: 'Feed',
            isSelected: currentRoute == NavigationService.feedRoute,
            context: context,
          ),
          _buildNavItem(
            icon: Icons.shopping_cart_outlined,
            label: 'Cart',
            buttonName: 'Cart',
            isSelected: currentRoute == NavigationService.cartRoute,
            context: context,
          ),
          _buildAddButton(context),
          _buildNavItem(
            icon: Icons.message_outlined,
            label: 'Fashee',
            buttonName: 'Fashee',
            isSelected: currentRoute == NavigationService.fasheeRoute,
            context: context,
          ),
          _buildNavItem(
            icon: Icons.person_outline,
            label: 'Profile',
            buttonName: 'Profile',
            isSelected: currentRoute == NavigationService.profileRoute,
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required String buttonName,
    required bool isSelected,
    required BuildContext context,
  }) {
    final color = isSelected ? Colors.purple[900] : Colors.white;
    
    return InkWell(
      onTap: () => _handleTap(buttonName, context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedOpacity(
            opacity: _isTapped && selectedButton == buttonName ? 0.3 : 1.0,
            duration: Duration(milliseconds: 200),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
          const SizedBox(height: 1),
          AnimatedOpacity(
            opacity: _isTapped && selectedButton == buttonName ? 0.3 : 1.0,
            duration: Duration(milliseconds: 200),
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontFamily: 'Inter',
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return InkWell(
      onTap: () => _handleTap('Add', context),
      child: AnimatedOpacity(
        opacity: _isTapped && selectedButton == 'Add' ? 0.3 : 1.0,
        duration: Duration(milliseconds: 200),
        child: Icon(
          Icons.add_circle_outline,
          color: Colors.white,
          size: 48,
        ),
      ),
    );
  }
}
