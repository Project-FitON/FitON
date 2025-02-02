import 'package:flutter/material.dart';
import 'login_screen.dart';  

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Sign up", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text("Create your account", style: TextStyle(fontSize: 14, color: Colors.grey)),
              SizedBox(height: 20),
              TextField(decoration: InputDecoration(hintText: "Username", prefixIcon: Icon(Icons.person), filled: true, fillColor: Colors.red.shade50, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none))),
              SizedBox(height: 10),
              TextField(decoration: InputDecoration(hintText: "Email", prefixIcon: Icon(Icons.email), filled: true, fillColor: Colors.red.shade50, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none))),
              SizedBox(height: 10),
              TextField(obscureText: true, decoration: InputDecoration(hintText: "Password", prefixIcon: Icon(Icons.lock), filled: true, fillColor: Colors.red.shade50, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none))),
              SizedBox(height: 10),
              TextField(obscureText: true, decoration: InputDecoration(hintText: "Confirm Password", prefixIcon: Icon(Icons.lock), filled: true, fillColor: Colors.red.shade50, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none))),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  "Sign up",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              Text("Or"),
              SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.login, color: Colors.red),
                label: Text(
                  "Login with Google",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text("Already have an account? Login", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
