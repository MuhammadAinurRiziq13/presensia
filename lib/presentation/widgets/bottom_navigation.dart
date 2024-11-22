import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int currentIndex;

  const BottomNavigationWidget({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      elevation: 10.0,
      notchMargin: 8.0,
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildBottomNavItem(context, Icons.home, 'Home', 0, '/home'),
          _buildBottomNavItem(context, Icons.history, 'History', 1, '/history'),
          const SizedBox(width: 40), // Space for FAB (if needed in layout)
          _buildBottomNavItem(context, Icons.mail, 'Permit', 3, '/permit'),
          _buildBottomNavItem(context, Icons.person, 'Profile', 4, '/profile'),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
    String route,
  ) {
    return GestureDetector(
      onTap: () => GoRouter.of(context).go(route),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            icon,
            color: currentIndex == index ? Colors.blue : Colors.grey,
            size: 30.0,
          ),
          const SizedBox(height: 4.0),
          Text(
            label,
            style: TextStyle(
              color: currentIndex == index ? Colors.blue : Colors.grey,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}
