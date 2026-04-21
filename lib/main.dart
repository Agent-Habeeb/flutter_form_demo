import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Form Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      home: const FormScreen(),
    );
  }
}

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _rememberMe = false;
  String _gender = 'Male';
  String? _country;
  double _age = 18;
  DateTime? _selectedDate;

  final List<String> _countries = ['Egypt', 'Jordan', 'Palestine', 'USA', 'UK', 'Canada'];

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a date')),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OutputScreen(
            username: _usernameController.text,
            password: _passwordController.text,
            email: _emailController.text,
            rememberMe: _rememberMe,
            gender: _gender,
            country: _country!,
            age: _age.toInt(),
            selectedDate: _selectedDate!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFD),
      appBar: AppBar(
        title: const Text('Flutter Form Demo'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username', hintText: 'Please enter your username'),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter your username' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password', hintText: 'Please enter your password'),
                  validator: (value) => value == null || value.length < 6 ? 'Password must be at least 6 characters' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email', hintText: 'Please enter your email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter your email';
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (val) => setState(() => _rememberMe = val!),
                    ),
                    const Text('Remember me'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Gender: '),
                    Radio<String>(
                      value: 'Male',
                      groupValue: _gender,
                      onChanged: (val) => setState(() => _gender = val!),
                    ),
                    const Text('Male'),
                    Radio<String>(
                      value: 'Female',
                      groupValue: _gender,
                      onChanged: (val) => setState(() => _gender = val!),
                    ),
                    const Text('Female'),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Country', hintText: 'Please select a country'),
                  value: _country,
                  items: _countries.map((String country) {
                    return DropdownMenuItem<String>(
                      value: country,
                      child: Text(country),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _country = val),
                  validator: (value) => value == null ? 'Please select a country' : null,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Text('Age: '),
                    Expanded(
                      child: Slider(
                        value: _age,
                        min: 18,
                        max: 100,
                        divisions: 82,
                        label: _age.round().toString(),
                        onChanged: (val) => setState(() => _age = val),
                      ),
                    ),
                    Text(_age.round().toString()),
                  ],
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Select Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      _selectedDate == null
                          ? 'No date selected'
                          : '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: const Text('Submit'),
                  ),
                ),
                const SizedBox(height: 60),
                const Divider(),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Created by Habeeb Bisharat',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OutputScreen extends StatelessWidget {
  final String username;
  final String password;
  final String email;
  final bool rememberMe;
  final String gender;
  final String country;
  final int age;
  final DateTime selectedDate;

  const OutputScreen({
    super.key,
    required this.username,
    required this.password,
    required this.email,
    required this.rememberMe,
    required this.gender,
    required this.country,
    required this.age,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFD),
      appBar: AppBar(
        title: const Text('Form Output'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              Text('Username: $username', style: const TextStyle(fontSize: 16)),
              Text('Password: $password', style: const TextStyle(fontSize: 16)),
              Text('Email: $email', style: const TextStyle(fontSize: 16)),
              Text('Remember Me: $rememberMe', style: const TextStyle(fontSize: 16)),
              Text('Gender: $gender', style: const TextStyle(fontSize: 16)),
              Text('Country: $country', style: const TextStyle(fontSize: 16)),
              Text('Age: $age', style: const TextStyle(fontSize: 16)),
              Text(
                  'Selected Date: ${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 16)
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Go Back'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}