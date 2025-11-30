import 'package:flutter/material.dart';

/// Temporary auth "API" stub.
/// Later you will replace this with real HTTP calls to your backend.
class AuthService {
  static bool _isLoggedIn = true; // flip this for manual testing
  static final String _firstName = 'Ryan'; // change this when api is implemented to display username

  static Future<bool> checkLoginStatus() async {
    // Simulate a small network delay.
    await Future.delayed(const Duration(milliseconds: 300));
    return _isLoggedIn;
  }

  static String? get firstName => _isLoggedIn ? _firstName : null;

  // These will eventually call your real backend.
  static Future<void> logInMock() async {
    _isLoggedIn = true;
  }

  static Future<void> logOutMock() async {
    _isLoggedIn = false;
  }
}

enum _AuthStatus { unknown, loggedOut, loggedIn }

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  _AuthStatus _status = _AuthStatus.unknown;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final isLoggedIn = await AuthService.checkLoginStatus();
    setState(() {
      _status = isLoggedIn ? _AuthStatus.loggedIn : _AuthStatus.loggedOut;
    });
  }

  Future<void> _handleLogout(BuildContext context) async {
    await AuthService.logOutMock();
    setState(() {
      _status = _AuthStatus.loggedOut;
    });
    // Make sure we're on the homepage route in a clean stack
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    if (_status == _AuthStatus.unknown) {
      // Simple loading state while "API" is checking
      return const Scaffold(
        backgroundColor: Color(0xFF050F0B),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF00C676)),
        ),
      );
    }

    if (_status == _AuthStatus.loggedIn) {
      return _LoggedInHome(
        onLogout: () => _handleLogout(context),
      );
    }

    // Logged out
    return const _LoggedOutHome();
  }
}

// ---------------------------------------------------------------------------
// LOGGED OUT HOME
// ---------------------------------------------------------------------------

class _LoggedOutHome extends StatelessWidget {
  const _LoggedOutHome();

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
                    Row(
                      children: [
                        Image.asset(
                          'images/SharedCartLogo.png',
                          height: 32,
                          width: 32,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.shopping_cart,
                                color: Colors.white, size: 28);
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
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signIn');
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentYellow,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
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

              // ---------- HERO ----------
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Shop Together, Stay Organized',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Create shared shopping lists with your family and roommates. Add items, edit in real-time, and never forget what you need.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 22, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/signUp');
                          },
                          child: const Text('Get Started Free'),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white30),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 22, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/signIn');
                          },
                          child: const Text('Sign In'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: const [
                        Expanded(
                          child:
                          _StatCard(label: 'LISTS CREATED', value: '6+'),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _StatCard(label: 'ITEMS ADDED', value: '24'),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child:
                          _StatCard(label: 'GROUPS SYNCING', value: '9'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ---------- WHY SHAREDCART ----------
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  children: [
                    Text(
                      'Why SharedCart?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'A calm, modern workspace for households to stay in sync without juggling texts or sticky notes.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const _FeatureCard(
                      icon: Icons.description_outlined,
                      title: 'Create & Share Lists',
                      description:
                      'Create shopping lists and share them with your family or roommates instantly.',
                    ),
                    const SizedBox(height: 12),
                    const _FeatureCard(
                      icon: Icons.bolt_outlined,
                      title: 'Real-Time Updates',
                      description:
                      'See changes as they happen. Add, edit, or remove items in real-time.',
                    ),
                    const SizedBox(height: 12),
                    const _FeatureCard(
                      icon: Icons.check_circle_outline,
                      title: 'Mark as Purchased',
                      description:
                      'Check off items as you buy them so everyone can see what\'s been purchased.',
                    ),
                    const SizedBox(height: 12),
                    const _FeatureCard(
                      icon: Icons.group_outlined,
                      title: 'Multiple Lists',
                      description:
                      'Create different lists for groceries, household items, or anything you need.',
                    ),
                  ],
                ),
              ),

              // ---------- HOW IT WORKS ----------
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  children: [
                    Text(
                      'How It Works',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Three simple steps to keep every grocery run coordinated and stress-free.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const _StepCard(
                      stepNumber: 1,
                      title: 'Create an Account',
                      description:
                      'Sign up for free and start creating your first shopping list.',
                    ),
                    const SizedBox(height: 12),
                    const _StepCard(
                      stepNumber: 2,
                      title: 'Create or Join a List',
                      description:
                      'Create a new list or join an existing one using a share code.',
                    ),
                    const SizedBox(height: 12),
                    const _StepCard(
                      stepNumber: 3,
                      title: 'Start Shopping',
                      description:
                      'Add items, mark them as purchased, and keep everyone in sync.',
                    ),
                  ],
                ),
              ),

              // ---------- BOTTOM CTA ----------
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
                  decoration: BoxDecoration(
                    color: cardBackground,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Ready to leave scattered notes behind?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Spin up your first list in seconds, invite the people you shop with, and watch everyone stay in sync.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/signUp');
                            },
                            child: const Text('Create a Free Account'),
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white30),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/signIn');
                            },
                            child: const Text('I already have an account'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

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
}

// ---------------------------------------------------------------------------
// LOGGED IN HOME
// ---------------------------------------------------------------------------

class _LoggedInHome extends StatelessWidget {
  final VoidCallback onLogout;

  const _LoggedInHome({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final Color background = const Color(0xFF050F0B);
    final Color cardBackground = const Color(0xFF101F18);
    final Color accentGreen = const Color(0xFF00C676);
    final Color accentRed = const Color(0xFFEA4335);

    final Color textPrimary = Colors.white.withOpacity(0.95);
    final Color textSecondary = Colors.white70;

    final String greetingName = AuthService.firstName ?? 'there';

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: logo, title, Log Out on the far right
                    Row(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'images/SharedCartLogo.png',
                              height: 32,
                              width: 32,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.shopping_cart,
                                    color: Colors.white, size: 28);
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
                        const Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentRed,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: onLogout,
                          child: const Text('Log Out'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Second row: greeting on left, My Lists on right
                    Row(
                      children: [
                        Text(
                          'Hello, $greetingName!',
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/myLists');
                          },
                          icon: const Icon(Icons.list,
                              size: 18, color: Colors.white),
                          label: const Text(
                            'My Lists',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ---------- HERO ----------
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Shop Together, Stay Organized',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Create shared shopping lists with your family and roommates. Add items, edit in real-time, and never forget what you need.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/myLists');
                      },
                      child: const Text('View My Lists'),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: const [
                        Expanded(
                          child:
                          _StatCard(label: 'LISTS CREATED', value: '6+'),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _StatCard(label: 'ITEMS ADDED', value: '24'),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child:
                          _StatCard(label: 'GROUPS SYNCING', value: '9'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ---------- WHY SHAREDCART ----------
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  children: [
                    Text(
                      'Why SharedCart?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'A calm, modern workspace for households to stay in sync without juggling texts or sticky notes.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const _FeatureCard(
                      icon: Icons.description_outlined,
                      title: 'Create & Share Lists',
                      description:
                      'Create shopping lists and share them with your family or roommates instantly.',
                    ),
                    const SizedBox(height: 12),
                    const _FeatureCard(
                      icon: Icons.bolt_outlined,
                      title: 'Real-Time Updates',
                      description:
                      'See changes as they happen. Add, edit, or remove items in real-time.',
                    ),
                    const SizedBox(height: 12),
                    const _FeatureCard(
                      icon: Icons.check_circle_outline,
                      title: 'Mark as Purchased',
                      description:
                      'Check off items as you buy them so everyone can see what\'s been purchased.',
                    ),
                    const SizedBox(height: 12),
                    const _FeatureCard(
                      icon: Icons.group_outlined,
                      title: 'Multiple Lists',
                      description:
                      'Create different lists for groceries, household items, or anything you need.',
                    ),
                  ],
                ),
              ),

              // ---------- HOW IT WORKS (added for logged-in) ----------
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  children: [
                    Text(
                      'How It Works',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Three simple steps to keep every grocery run coordinated and stress-free.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const _StepCard(
                      stepNumber: 1,
                      title: 'Create an Account',
                      description:
                      'Sign up for free and start creating your first shopping list.',
                    ),
                    const SizedBox(height: 12),
                    const _StepCard(
                      stepNumber: 2,
                      title: 'Create or Join a List',
                      description:
                      'Create a new list or join an existing one using a share code.',
                    ),
                    const SizedBox(height: 12),
                    const _StepCard(
                      stepNumber: 3,
                      title: 'Start Shopping',
                      description:
                      'Add items, mark them as purchased, and keep everyone in sync.',
                    ),
                  ],
                ),
              ),

              // ---------- BOTTOM CTA ----------
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
                  decoration: BoxDecoration(
                    color: cardBackground,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Ready to leave scattered notes behind?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Spin up your first list in seconds, invite the people you shop with, and watch everyone stay in sync.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/myLists');
                        },
                        child: const Text('Open My Lists'),
                      ),
                    ],
                  ),
                ),
              ),

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
}


// ---------------------------------------------------------------------------
// SHARED HELPER WIDGETS
// ---------------------------------------------------------------------------

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final Color cardBackground = const Color(0xFF101F18);
    final Color textPrimary = Colors.white.withOpacity(0.95);
    final Color textSecondary = Colors.white70;

    return SizedBox(
      height: 80,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textSecondary,
                fontSize: 10.5,
                letterSpacing: 0.8,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              value,
              style: TextStyle(
                color: textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final Color cardBackground = const Color(0xFF101F18);
    final Color textPrimary = Colors.white.withOpacity(0.95);
    final Color textSecondary = Colors.white70;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF0C2A1F),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: textPrimary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String description;

  const _StepCard({
    required this.stepNumber,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final Color cardBackground = const Color(0xFF101F18);
    final Color textPrimary = Colors.white.withOpacity(0.95);
    final Color textSecondary = Colors.white70;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFFF0C800),
            child: Text(
              '$stepNumber',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
