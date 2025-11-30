import 'package:flutter/material.dart';

import '../utils/auth_service.dart';
import '../utils/list_service.dart';

class EditListScreen extends StatelessWidget {
  const EditListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF050F0B),
      body: Center(
        child: Text(
          'Edit List Screen (placeholder)',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
