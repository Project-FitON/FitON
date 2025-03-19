import 'package:flutter/material.dart';
import 'package:fiton/screens/fashee/fashee_chat_screen.dart';
import '../feed/feed_components/navigation_component.dart';

class FasheeScreen extends StatefulWidget {
  const FasheeScreen({Key? key}) : super(key: key);

  @override
  State<FasheeScreen> createState() => _FasheeScreenState();
}

class _FasheeScreenState extends State<FasheeScreen> {
  final TextEditingController _textController = TextEditingController();
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    // Set loading to false after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Main content with bottom padding for navigation
            Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(bottom: 60),
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color.fromARGB(255, 180, 201, 237),
                        const Color.fromARGB(255, 255, 255, 255),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          // Transparent AppBar for height
                          AppBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            toolbarHeight: 80,
                          ),
                          
                          // Header Content
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 60),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // Menu action
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.menu,
                                          color: Colors.grey[800],
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  "Hey, Nimasha",
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Got any fashion questions?",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Fashion AI Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                width: double.infinity,
                                height: 200,
                                color: Colors.purple.shade100,
                                child: Center(
                                  child: Icon(
                                    Icons.auto_awesome,
                                    size: 80,
                                    color: Colors.purple.shade800,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              "How can I assist with your fashion needs today?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Text Field
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _textController,
                                      decoration: InputDecoration(
                                        hintText: "Type your fashion question...",
                                        hintStyle: TextStyle(color: Colors.grey[400]),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.send_rounded,
                                      color: Colors.purple[700],
                                    ),
                                    onPressed: () {
                                      if (_textController.text.isNotEmpty) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChatScreen(),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              "Quick Prompts",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              alignment: WrapAlignment.center,
                              children: [
                                _buildPromptButton(
                                  "What should I wear to a wedding?",
                                  Icons.celebration,
                                ),
                                _buildPromptButton(
                                  "Help me style these jeans",
                                  Icons.shopping_bag,
                                ),
                                _buildPromptButton(
                                  "Business casual outfit ideas",
                                  Icons.business,
                                ),
                                _buildPromptButton(
                                  "Colors that match with blue",
                                  Icons.palette,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Navigation component at the bottom
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: NavigationComponent(),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error building FasheeScreen: $e');
      return Scaffold(
        body: Center(
          child: Text('Error loading Fashee: $e'),
        ),
      );
    }
  }

  Widget _buildPromptButton(String text, IconData icon) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      child: ElevatedButton.icon(
        onPressed: () {
          _textController.text = text;
        },
        icon: Icon(icon, color: Colors.purple[700]),
        label: Text(
          text,
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}