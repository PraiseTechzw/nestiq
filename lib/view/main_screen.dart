import 'package:flutter/material.dart';
import 'package:nestiq/view/explore_screen.dart';
import 'package:nestiq/view/message.dart';
import 'package:nestiq/view/profile_page.dart';
import 'package:nestiq/view/wishlists.dart';

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  int selectedIndex = 0;
  late final List<Widget> pages;

  @override
  void initState() {
    pages = [
      const ExploreScreen(),
      const Wishlists(),
      const MessagesScreen(),
      const ProfilePage(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[selectedIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconSize: 30,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            currentIndex: selectedIndex,
            onTap: (index) => setState(() => selectedIndex = index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home, size: 32),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                activeIcon: Icon(Icons.favorite, size: 32),
                label: "Wishlists",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline),
                activeIcon: Icon(Icons.chat_bubble, size: 32),
                label: "Messages",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person, size: 32),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
