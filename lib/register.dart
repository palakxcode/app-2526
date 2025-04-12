import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _inviteCodeController = TextEditingController();

  final auth = AuthService();

  String _selectedRole = 'Member'; // Default role
  String? _selectedDepartment; // Department (nullable)

  final List<String> departments = [
    'Technical',
    'Management',
    'Social Media & Content',
  ];

  Future<void> registerUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();
    final inputCode = _inviteCodeController.text.trim();

    final doc = await FirebaseFirestore.instance
        .collection('config')
        .doc('register')
        .get();

    final expectedCode = doc.data()?['inviteCode'];

    if (inputCode != expectedCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid invite code.'),
          backgroundColor: Color(0xFFFFB5CC), // Pastel pink
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Validate department if required
    if ((_selectedRole == 'Member' || _selectedRole == 'Core') &&
        _selectedDepartment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a department.'),
          backgroundColor: Color(0xFFFFB5CC), // Pastel pink
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    String? result = await auth.signup(email: email, password: password);

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
          backgroundColor: Color(0xFFFFB5CC), // Pastel pink
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      await auth.storeUserData(
        email: email,
        name: name,
        role: _selectedRole,
        department: _selectedDepartment, // can be null for Board
      );

      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
      _inviteCodeController.clear();

      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pastel theme colors
    final pastelPink = Color(0xFFFFD1DC);
    final pastelBlue = Color(0xFFB5DEFF);
    final pastelMint = Color(0xFFAFE1AF);
    final pastelLavender = Color(0xFFE6E6FA);
    final pastelPeach = Color(0xFFFFDAB9);
    final pastelYellow = Color(0xFFFFFACD);

    return Scaffold(
      backgroundColor: pastelLavender,
      appBar: AppBar(
        title: Text(
          'Register',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: pastelBlue,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [pastelLavender, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ListView(
                children: [
                  Icon(
                    Icons.app_registration,
                    size: 70,
                    color: pastelPink,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Colors.black54),
                      prefixIcon: Icon(Icons.person, color: pastelBlue),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: pastelBlue, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: pastelMint, width: 2),
                      ),
                      filled: true,
                      fillColor: pastelBlue.withOpacity(0.1),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.black54),
                      prefixIcon: Icon(Icons.email, color: pastelPink),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: pastelPink, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: pastelMint, width: 2),
                      ),
                      filled: true,
                      fillColor: pastelPink.withOpacity(0.1),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.black54),
                      prefixIcon: Icon(Icons.lock, color: pastelMint),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: pastelMint, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: pastelBlue, width: 2),
                      ),
                      filled: true,
                      fillColor: pastelMint.withOpacity(0.1),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _inviteCodeController,
                    decoration: InputDecoration(
                      labelText: 'Invite Code',
                      labelStyle: TextStyle(color: Colors.black54),
                      prefixIcon: Icon(Icons.vpn_key, color: pastelYellow),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: pastelYellow, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: pastelMint, width: 2),
                      ),
                      filled: true,
                      fillColor: pastelYellow.withOpacity(0.1),
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: pastelPeach, width: 1.5),
                      color: pastelPeach.withOpacity(0.1),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedRole,
                      decoration: InputDecoration(
                        labelText: 'Select Role',
                        labelStyle: TextStyle(color: Colors.black54),
                        prefixIcon: Icon(Icons.badge, color: pastelPeach),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      dropdownColor: Colors.white,
                      items: ['Member', 'Board', 'Core'].map((role) {
                        return DropdownMenuItem(value: role, child: Text(role));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value!;
                          _selectedDepartment =
                              null; // reset dept when role changes
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  // Conditionally show department dropdown
                  if (_selectedRole == 'Member' || _selectedRole == 'Core')
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: pastelLavender, width: 1.5),
                        color: pastelLavender.withOpacity(0.1),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _selectedDepartment,
                        decoration: InputDecoration(
                          labelText: 'Select Department',
                          labelStyle: TextStyle(color: Colors.black54),
                          prefixIcon:
                              Icon(Icons.business, color: pastelLavender),
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        dropdownColor: Colors.white,
                        items: departments.map((dept) {
                          return DropdownMenuItem(
                              value: dept, child: Text(dept));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDepartment = value;
                          });
                        },
                      ),
                    ),
                  SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: registerUser,
                      child: Text(
                        'REGISTER',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        backgroundColor: pastelMint,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text(
                      "Already have an account? Login here",
                      style: TextStyle(
                        color: Colors.black87,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: pastelPeach,
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
}
