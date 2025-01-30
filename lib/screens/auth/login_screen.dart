import 'package:flutter/material.dart';



class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Welcome Back", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text("Enter your credential for login", style: TextStyle(fontSize: 14, color: Colors.grey)),
              SizedBox(height: 20),
              TextField(
                  decoration: InputDecoration(
                      hintText: "Username",
                      prefixIcon: Icon(Icons.person),
                      filled: true,
                      fillColor: Colors.red.shade50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none))),
              SizedBox(height: 10),
              TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: Icon(Icons.lock),
                      filled: true,
                      fillColor: Colors.red.shade50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none))),

              SizedBox(height: 20),
              ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.red, 
    minimumSize: Size(double.infinity, 50),
    textStyle: TextStyle(color: Colors.white), // Corrected this line
  ),
  child: Text(
    "Login Now",
    style: TextStyle(color: Colors.white), // Ensure text color is white
  ),
),

                
              SizedBox(height: 10),
              TextButton(onPressed: () {}, child: Text("Forgot password?", style: TextStyle(color: Colors.red))),
              Spacer(),
              GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                  child: Text("Don't have an account? Sign Up", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder for SignUpPage
class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Sign Up Page"),
      ),
    );
  }
}
