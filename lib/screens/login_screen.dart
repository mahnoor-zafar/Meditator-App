import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth package
import 'package:flutter/material.dart';
import 'package:meditator_app/screens/home_screen.dart';
import 'package:meditator_app/screens/signup_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>(); // Form key for validation
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // Light yellow background
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey, // Attach the form key
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login to Meditopia",
                    style: TextStyle(
                      fontFamily: 'Ephesis',  // Use the font family name, not the file name
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,  // Set text color to black
                    ),
                  ),
                  SizedBox(height: 40),

                  // Email Field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",  // Label text
                        hintText: "Enter your email",  // Hint text when the field is empty
                        filled: true,  // Fill the background with a color
                        fillColor: Colors.white,  // Background color of the input field
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),  // Rounded corners
                        ),
                        // Border for the enabled state (when the input field is not focused)
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),  // Rounded corners for enabled state
                          borderSide: BorderSide(color: Colors.black, width: 1.0),
                        ),
                        // Border for the focused state (when the input field is focused)
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),  // Rounded corners for focused state
                          borderSide: BorderSide(color: Colors.grey, width: 2.0),
                        ),
                        // Prefix icon (email icon)
                        prefixIcon: Icon(Icons.email, color: Colors.black),
                      ),
                      keyboardType: TextInputType.emailAddress,  // Specify email input type
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is required";  // Error message if email is empty
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return "Enter a valid email address";  // Error message if email is invalid
                        }
                        return null;
                      },
                    ),
                  ),

                  SizedBox(height: 20),

                  // Password Field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,  // This ensures the password is obscured (hidden)
                      decoration: InputDecoration(
                        labelText: "Password",  // Label text
                        hintText: "Enter your password",  // Hint text shown when field is empty
                        filled: true,  // Fill the background with color
                        fillColor: Colors.white,  // Background color of the input field
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),  // Rounded corners
                        ),
                        // Border for the enabled state (when the input field is not focused)
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),  // Rounded corners for enabled state
                          borderSide: BorderSide(color: Colors.black, width: 1.0),
                        ),
                        // Border for the focused state (when the input field is focused)
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),  // Rounded corners for focused state
                          borderSide: BorderSide(color: Colors.grey, width: 2.0),
                        ),
                        // Prefix icon (lock icon)
                        prefixIcon: Icon(Icons.lock, color: Colors.black),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";  // Error message if password is empty
                        } else if (value.length < 6) {
                          return "Password must be at least 6 characters long";  // Error message if password is too short
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),

                  // Login Button
                  _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding:
                      EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: Text(
                      "Login",
                      style: GoogleFonts.redHatDisplay(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Navigate to SignUp
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: Text(
                      "Don't have an account? Sign up",
                      style: GoogleFonts.redHatDisplay(  // Use the Red Hat Display font
                        fontSize: 18,                    // Set font size
                        fontWeight: FontWeight.w400,     // Set font weight
                        color: Colors.black,             // Set font color
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Login function
  Future<void> _login() async {
    // Validate the form inputs
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Firebase Authentication
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Navigate to Home Screen on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (e.code == 'user-not-found') {
        _showErrorDialog("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        _showErrorDialog("Incorrect password provided.");
      } else {
        _showErrorDialog("Login failed: ${e.message}");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog("An unexpected error occurred: ${e.toString()}");
    }
  }

  // Error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
