import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../models/auth_user.dart';

class AuthLoginScreen extends StatefulWidget {
  const AuthLoginScreen({
    super.key,
    this.initialUserType,
  });

  final UserType? initialUserType;

  @override
  State<AuthLoginScreen> createState() => _AuthLoginScreenState();
}

class _AuthLoginScreenState extends State<AuthLoginScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  UserType _selectedUserType = UserType.client;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    if (widget.initialUserType != null) {
      _selectedUserType = widget.initialUserType!;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5E50A1),
              Color(0xFF4F4391),
              Color(0xFF403676),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                
                // Logo/Title
                const Text(
                  'EWAJI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Beauty at your fingertips',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // User type selection
                _buildUserTypeSelector(),
                
                const SizedBox(height: 24),
                
                // Login/Register tabs
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        // Tab bar
                        TabBar(
                          controller: _tabController,
                          indicatorColor: const Color(0xFF5E50A1),
                          labelColor: const Color(0xFF5E50A1),
                          unselectedLabelColor: Colors.grey,
                          tabs: const [
                            Tab(text: 'Sign In'),
                            Tab(text: 'Sign Up'),
                          ],
                        ),
                        
                        // Tab views
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _buildSignInForm(),
                              _buildSignUpForm(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedUserType = UserType.client),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedUserType == UserType.client
                      ? Colors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  'Client',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _selectedUserType == UserType.client
                        ? const Color(0xFF5E50A1)
                        : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedUserType = UserType.provider),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedUserType == UserType.provider
                      ? Colors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  'Provider',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _selectedUserType == UserType.provider
                        ? const Color(0xFF5E50A1)
                        : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInForm() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          
          // Email field
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Password field
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Sign in button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _signInWithEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E50A1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Phone sign in button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _showPhoneSignIn,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF5E50A1)),
                foregroundColor: const Color(0xFF5E50A1),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone),
                  SizedBox(width: 8),
                  Text('Sign in with Phone'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Social sign in buttons
          _buildSocialSignInButtons(),
          
          const Spacer(),
          
          // Forgot password
          TextButton(
            onPressed: _showForgotPassword,
            child: const Text(
              'Forgot Password?',
              style: TextStyle(color: Color(0xFF5E50A1)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          
          // Email field
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Password field
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Sign up button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _signUpWithEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E50A1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Social sign in buttons
          _buildSocialSignInButtons(),
          
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildSocialSignInButtons() {
    return Column(
      children: [
        // Google sign in
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _signInWithGoogle,
            icon: const Icon(Icons.g_mobiledata, color: Colors.red),
            label: const Text('Continue with Google'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Apple sign in (iOS only)
        if (Theme.of(context).platform == TargetPlatform.iOS)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _signInWithApple,
              icon: const Icon(Icons.apple, color: Colors.black),
              label: const Text('Continue with Apple'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _signInWithEmail() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    context.read<AuthBloc>().add(AuthEmailSignInRequested(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      userType: _selectedUserType,
    ));
  }

  void _signUpWithEmail() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    context.read<AuthBloc>().add(AuthEmailSignUpRequested(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      userType: _selectedUserType,
    ));
  }

  void _signInWithGoogle() {
    context.read<AuthBloc>().add(AuthGoogleSignInRequested(
      userType: _selectedUserType,
    ));
  }

  void _signInWithApple() {
    context.read<AuthBloc>().add(AuthAppleSignInRequested(
      userType: _selectedUserType,
    ));
  }

  void _showPhoneSignIn() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Phone Sign In'),
        content: TextField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            prefixText: '+1 ',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_phoneController.text.isNotEmpty) {
                context.read<AuthBloc>().add(AuthPhoneSignInRequested(
                  phoneNumber: '+1${_phoneController.text.trim()}',
                  userType: _selectedUserType,
                ));
                Navigator.pop(context);
              }
            },
            child: const Text('Send Code'),
          ),
        ],
      ),
    );
  }

  void _showForgotPassword() {
    final emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (emailController.text.isNotEmpty) {
                context.read<AuthBloc>().add(AuthPasswordResetRequested(
                  email: emailController.text.trim(),
                ));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password reset email sent!'),
                  ),
                );
              }
            },
            child: const Text('Send Reset Email'),
          ),
        ],
      ),
    );
  }
}
