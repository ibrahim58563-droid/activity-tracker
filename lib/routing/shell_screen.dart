import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/widgets/bottom_nav_bar.dart';
import '../core/widgets/mashrabiya_background.dart';

/// Shell that wraps child routes with mashrabiya background + bottom nav.
class ShellScreen extends StatelessWidget {
  final Widget child;
  const ShellScreen({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/students')) return 1;
    return 1; // Default to students for MVP
  }

  @override
  Widget build(BuildContext context) {
    return MashrabiyaBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: child,
        extendBody: true,
        bottomNavigationBar: GlassBottomNavBar(
          currentIndex: _currentIndex(context),
          onTap: (index) {
            switch (index) {
              case 1:
                context.go('/students');
                break;
              default:
                // Other tabs are placeholders in MVP
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Coming soon insha\'Allah'),
                    duration: Duration(seconds: 1),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
