import 'package:flutter/material.dart';
import '../feed/nav_screen.dart';
import 'add_dependents_screen.dart';
import 'edit_dependent_screen.dart';

class DependentsScreen extends StatefulWidget {
  const DependentsScreen({super.key});

  @override
  _DependentsScreenState createState() => _DependentsScreenState();
}

class _DependentsScreenState extends State<DependentsScreen> {
  final List<Map<String, dynamic>> dependents = [
    {
      'name': 'Me',
      'relation': 'Primary Account',
      'icon': Icons.person,
      'image': 'assets/images/me.jpg',
      'selected': false,
    },
    {
      'name': 'Dad',
      'relation': 'Family',
      'icon': Icons.family_restroom,
      'image': 'assets/images/dad.jpg',
      'selected': false,
    },
    {
      'name': 'Boyfriend',
      'relation': 'Love',
      'icon': Icons.favorite,
      'image': 'assets/images/boyfriend.jpg',
      'selected': false,
    },
  ];

  bool _showSearchBar = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF1B0331),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        title: _showSearchBar
            ? TextField(
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
        )
            : const Text('MY PEOPLE', style: TextStyle(color: Colors.white)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(_showSearchBar ? Icons.close : Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                _showSearchBar = !_showSearchBar;
              });
            },
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.account_circle, color: Colors.white, size: 28),
          )
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: Padding(
            padding: EdgeInsets.only(bottom: 12.0),
            child: Text(
              'Shopping For: 2 People',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: dependents.length,
          itemBuilder: (context, index) {
            final dependent = dependents[index];
            return Card(
              color: Colors.white, // Ensure list view items are white
              margin: const EdgeInsets.only(bottom: 16.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4, // Added shadow effect
              shadowColor: Colors.grey.withOpacity(0.5), // Soft shadow color
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
                    IconButton(
                      icon: Icon(Icons.edit, color: Color(0xFF1B0331)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditDependentScreen(),
                          ),
                        ).then((_) => setState(() {})); // Enables returning back
                      },
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF1B0331),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddDependentScreen(),
            ),
          ).then((_) => setState(() {})); // Enables returning back
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
        bottomNavigationBar: NavScreen(),
    );
  }
}
