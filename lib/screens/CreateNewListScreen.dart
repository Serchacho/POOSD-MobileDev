import 'package:flutter/material.dart';
// import 'HomePageScreen.dart'; // for AuthService + consistent header

import '../utils/auth_service.dart';
import '../utils/list_service.dart';

class CreateNewListScreen extends StatefulWidget {
  const CreateNewListScreen({super.key});

  @override
  State<CreateNewListScreen> createState() => _CreateNewListScreenState();
}

class _CreateNewListScreenState extends State<CreateNewListScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleLogout(BuildContext context) async {
    await AuthService.logout();
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final Color background = const Color(0xFF050F0B);
    final Color cardBackground = const Color(0xFF101F18);
    final Color fieldBackground = const Color(0xFF151F1A);
    final Color accentGreen = const Color(0xFF00C676);

    final Color textPrimary = Colors.white.withOpacity(0.95);
    final Color textSecondary = Colors.white70;

    final String greetingName = AuthService.firstName ?? 'Ryan';

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
                    Row(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(20),
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
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEA4335),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () => _handleLogout(context),
                          child: const Text('Log Out'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
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
                          icon: const Icon(
                            Icons.list,
                            size: 18,
                            color: Colors.white,
                          ),
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

              // ---------- BACK TO LISTS ----------
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    foregroundColor: textSecondary,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/myLists');
                  },
                  icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                  label: const Text('Back to Lists'),
                ),
              ),

              const SizedBox(height: 12),

              // ---------- MAIN CARD ----------
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 28),
                    decoration: BoxDecoration(
                      color: cardBackground,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'New Shopping List',
                            style: TextStyle(
                              color: textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            'Give your list a name, add an optional description, and invite your roommates or family.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // LIST NAME
                        Text(
                          'LIST NAME',
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 12,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: fieldBackground,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            controller: _nameController,
                            style: TextStyle(
                              color: textPrimary,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              hintText: 'e.g., Weekly Groceries',
                              hintStyle: TextStyle(
                                color: textSecondary,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // DESCRIPTION
                        Text(
                          'DESCRIPTION',
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 12,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: fieldBackground,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: TextField(
                            controller: _descriptionController,
                            style: TextStyle(
                              color: textPrimary,
                              fontSize: 14,
                            ),
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText:
                              'Add context for everyone joining this list (optional)',
                              hintStyle: TextStyle(
                                color: textSecondary,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 26),

                        // BUTTON ROW
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: textSecondary.withOpacity(0.6),
                                ),
                                foregroundColor: textPrimary,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 22, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                              ),
                              onPressed: () {
                                // no functionality yet
                              },
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentGreen,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                              ),
                              onPressed: () {
                                // TODO: hook up create-list API later
                              },
                              child: const Text('Create List'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

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
