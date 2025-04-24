import 'package:flutter/material.dart';
import 'add_dependents_screen.dart';
import 'edit_dependent_screen.dart';

class DependentsScreen extends StatefulWidget {
  @override
  _DependentsScreenState createState() => _DependentsScreenState();
}

class _DependentsScreenState extends State<DependentsScreen> {
  final List<Map<String, dynamic>> dependents = [
    {
      'name': 'Me',
      'relation': 'Primary Account',
      'icon': Icons.person,
      'image': 'assets/images/feed/profile.jpg',
      'selected': false,
    },
    {
      'name': 'Dad',
      'relation': 'Family',
      'icon': Icons.family_restroom,
      'image': 'assets/images/feed/profile.jpg',
      'selected': false,
    },
    {
      'name': 'Boyfriend',
      'relation': 'Love',
      'icon': Icons.favorite,
      'image': 'assets/images/feed/profile.jpg',
      'selected': false,
    },
  ];

  bool _showSearchBar = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Search bar - simplified for sliding panel
          if (_showSearchBar)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF1B0331)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Color(0xFF1B0331)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Color(0xFF1B0331)),
                  ),
                ),
              ),
            ),
          
          // Search toggle and count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shopping For: ${dependents.where((d) => d['selected']).length} People',
                  style: TextStyle(color: Color(0xFF1B0331), fontSize: 16),
                ),
                IconButton(
                  icon: Icon(_showSearchBar ? Icons.close : Icons.search, color: Color(0xFF1B0331)),
                  onPressed: () {
                    setState(() {
                      _showSearchBar = !_showSearchBar;
                    });
                  },
                ),
              ],
            ),
          ),
          
          // List of dependents
          Expanded(
            child: ListView.builder(
              itemCount: dependents.length,
              itemBuilder: (context, index) {
                final dependent = dependents[index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  shadowColor: Colors.grey.withOpacity(0.5),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(dependent['image']),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dependent['name'],
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1B0331)),
                              ),
                              Row(
                                children: [
                                  Icon(dependent['icon'], size: 16, color: Color(0xFF1B0331)),
                                  const SizedBox(width: 6),
                                  Text(
                                    dependent['relation'],
                                    style: TextStyle(color: Color(0xFF1B0331)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: dependent['selected'],
                          onChanged: (value) {
                            setState(() {
                              dependents[index]['selected'] = value;
                            });
                          },
                          activeColor: Color(0xFF1B0331),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Apply button at bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1B0331),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Apply',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
