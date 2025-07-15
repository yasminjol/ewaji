import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../models/auth_user.dart';

class PinLockScreen extends StatefulWidget {
  const PinLockScreen({
    super.key,
    required this.user,
    this.onFallbackToBiometric,
  });

  final AuthUser user;
  final VoidCallback? onFallbackToBiometric;

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  String _enteredPin = '';
  final int _pinLength = 4;
  bool _isError = false;

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
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                const SizedBox(height: 48),
                
                // User avatar
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  backgroundImage: widget.user.photoURL != null
                      ? NetworkImage(widget.user.photoURL!)
                      : null,
                  child: widget.user.photoURL == null
                      ? const Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        )
                      : null,
                ),
                
                const SizedBox(height: 16),
                
                // User name
                Text(
                  widget.user.displayName ?? widget.user.email,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 48),
                
                // PIN instruction
                Text(
                  _isError ? 'Incorrect PIN. Try again.' : 'Enter your PIN',
                  style: TextStyle(
                    color: _isError ? Colors.red[300] : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // PIN dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pinLength, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index < _enteredPin.length
                            ? Colors.white
                            : Colors.white.withOpacity(0.3),
                        border: Border.all(
                          color: _isError ? Colors.red : Colors.white,
                          width: 2,
                        ),
                      ),
                    );
                  }),
                ),
                
                const Spacer(),
                
                // PIN keypad
                _buildPinKeypad(),
                
                const SizedBox(height: 32),
                
                // Fallback options
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (widget.onFallbackToBiometric != null)
                      TextButton.icon(
                        onPressed: widget.onFallbackToBiometric,
                        icon: const Icon(
                          Icons.fingerprint,
                          color: Colors.white70,
                        ),
                        label: const Text(
                          'Use Biometric',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    
                    TextButton.icon(
                      onPressed: _signOut,
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white70,
                      ),
                      label: const Text(
                        'Sign Out',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPinKeypad() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Column(
        children: [
          // Numbers 1-3
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadButton('1'),
              _buildKeypadButton('2'),
              _buildKeypadButton('3'),
            ],
          ),
          const SizedBox(height: 16),
          
          // Numbers 4-6
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadButton('4'),
              _buildKeypadButton('5'),
              _buildKeypadButton('6'),
            ],
          ),
          const SizedBox(height: 16),
          
          // Numbers 7-9
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadButton('7'),
              _buildKeypadButton('8'),
              _buildKeypadButton('9'),
            ],
          ),
          const SizedBox(height: 16),
          
          // 0 and backspace
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 80), // Empty space
              _buildKeypadButton('0'),
              _buildKeypadButton(
                'backspace',
                icon: Icons.backspace_outlined,
                onPressed: _removeDigit,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadButton(
    String value, {
    IconData? icon,
    VoidCallback? onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed ?? () => _addDigit(value),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.1),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: icon != null
              ? Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                )
              : Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }

  void _addDigit(String digit) {
    if (_enteredPin.length < _pinLength) {
      setState(() {
        _enteredPin += digit;
        _isError = false;
      });

      // Auto-submit when PIN is complete
      if (_enteredPin.length == _pinLength) {
        _submitPin();
      }
    }
  }

  void _removeDigit() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        _isError = false;
      });
    }
  }

  void _submitPin() {
    context.read<AuthBloc>().add(AuthPinUnlockRequested(pin: _enteredPin));
    
    // Reset PIN after a delay to show error if authentication fails
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _enteredPin = '';
          _isError = true;
        });
      }
    });
  }

  void _signOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(const AuthSignOutRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
