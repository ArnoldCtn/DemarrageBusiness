import 'package:flutter/material.dart';
import 'package:demarrage_business/features/home/presentation/pages/home_page.dart';
import 'package:demarrage_business/features/profile/presentation/pages/profile_page.dart';

class MainAppContainer extends StatefulWidget {
  const MainAppContainer({super.key});
  @override
  State<MainAppContainer> createState() => _MainAppContainerState();
}

class _MainAppContainerState extends State<MainAppContainer> {
  int _index = 0;
  final List<Widget> _pages = [const HomePage(), const ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"), 
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil")
        ],
      ),
    );
  }
}
