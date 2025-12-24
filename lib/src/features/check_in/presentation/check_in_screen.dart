import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CheckInScreen extends StatelessWidget {
  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Check-in')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('How are you feeling today?'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the main app (Home tab)
                context.go('/home');
              },
              child: const Text('Good! - Go to App'),
            ),
          ],
        ),
      ),
    );
  }
}
