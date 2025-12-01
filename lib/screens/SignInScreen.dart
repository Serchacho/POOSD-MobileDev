import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameEmailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    final payload = {
      'usernameOrEmail': _usernameEmailController.text.trim(),
      'password': _passwordController.text,
    };

    // Placeholder for your future API call.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sign-in API not connected yet'),
      ),
    );

    debugPrint('Sign in payload: $payload');
  }

  @override
  Widget build(BuildContext context) {
    final Color background = const Color(0xFF050F0B);
    final Color cardBackground = const Color(0xFF101F18);
    final Color accentGreen = const Color(0xFF00C676);
    final Color accentYellow = const Color(0xFFF0C800);
    final Color textPrimary = Colors.white.withOpacity(0.95);
    final Color textSecondary = Colors.white70;

    return Scaffold(
      backgroundColor: background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF041810),
              Color(0xFF020908),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              // ---------- HEADER ----------
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo + title (tappable -> home)
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/home');
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'images/SharedCartLogo.png',
                            height: 32,
                            width: 32,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                                size: 28,
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'SharedCart',
                            style: TextStyle(
                              color: textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // "Sign In" top button
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signIn');
                      },
                      icon: const Icon(
                        Icons.person_outline,
                        size: 18,
                        color: Colors.white70,
                      ),
                      label: Text(
                        'Sign In',
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    const SizedBox(width: 6),

                    // "Get Started" button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentYellow,
                        foregroundColor: Colors.black,
                        // Slightly smaller padding to prevent overflow on narrow screens
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/signUp');
                      },
                      child: const Text('Get Started'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ---------- SIGN-IN CARD ----------
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 24),
                    decoration: BoxDecoration(
                      color: cardBackground,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Welcome Back',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sign in to access your shopping lists',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Username / Email
                          _buildField(
                            controller: _usernameEmailController,
                            hint: 'Username or Email',
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 12),

                          // Password
                          _buildField(
                            controller: _passwordController,
                            hint: 'Password',
                            icon: Icons.lock_outline,
                            obscureText: true,
                          ),

                          const SizedBox(height: 12),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/forgotPassword');
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Center green Sign In button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentGreen,
                                foregroundColor: Colors.white,
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              onPressed: _handleSignIn,
                              child: const Text(
                                'Sign In',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              color: textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signUp');
                            },
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                color: accentGreen,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ---------- FOOTER ----------
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  children: [
                    Text(
                      '© 2025 SharedCart. All rights reserved.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final Color fieldBackground = const Color(0xFF151F1A);
    final Color textPrimary = Colors.white.withOpacity(0.95);
    final Color textSecondary = Colors.white70;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: textPrimary, fontSize: 14),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Required';
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: textSecondary),
        hintText: hint,
        hintStyle: TextStyle(color: textSecondary),
        filled: true,
        fillColor: fieldBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
