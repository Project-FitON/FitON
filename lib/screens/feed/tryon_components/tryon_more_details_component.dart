import 'package:flutter/material.dart';
import '../tryon_screen.dart'; // Import the TryOnScreen file

class RightBottomButtons extends StatelessWidget {
  final TryOnScreenState tryOnScreenState; // Add a reference to TryOnScreenState

  const RightBottomButtons({super.key, required this.tryOnScreenState});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min, // Prevent unnecessary space
        children: [
          // Green Tick Button with expanded touch area and custom animation
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Handle the tap event for Green Tick Button
                print('Green Tick Button Pressed');
              },
              borderRadius: BorderRadius.circular(12), // Rounded corners for ripple effect
              highlightColor: Colors.white.withOpacity(0.3), // Highlight color on touch
              splashColor: Colors.white.withOpacity(0.5), // Ripple effect color
              child: SizedBox(
                width: 30,
                height: 30,
                child: Image.asset(
                  'assets/images/feed/size-cha.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(height: 10), // Spacing between buttons

          // Three Dots Button with expanded touch area and custom animation
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (BuildContext context) {
                    return Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.settings, color: const Color.fromARGB(200, 255, 255, 255)),
                            title: Text('FitON Settings'),
                            onTap: () {
                              Navigator.pop(context);
                              print('FitON Settings selected');
                              // Handle FitON Settings action
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.delete, color: Colors.red),
                            title: Text('Delete FitON'),
                            onTap: () async {
                              Navigator.pop(context);
                              print('Delete FitON selected');
                              // Call the delete method directly
                              await tryOnScreenState.deleteCurrentImage();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              borderRadius: BorderRadius.circular(12), // Rounded corners for ripple effect
              highlightColor: Colors.white.withOpacity(0.3), // Highlight color on touch
              splashColor: Colors.white.withOpacity(0.5), // Ripple effect color
              child: SizedBox(
                width: 30,
                height: 30,
                child: Image.asset(
                  'assets/images/feed/more.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}