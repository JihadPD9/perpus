import 'package:flutter/material.dart';

import 'collection_page.dart';
import 'explore/explore_page.dart';
import 'profile_about_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _selectedTab;

  static const _titles = ['Jelajahi', 'Koleksi Saya', 'Profil & Tentang'];
  static const _pages = [ExplorePage(), CollectionPage(), ProfileAboutPage()];

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedTab])),
      body: IndexedStack(index: _selectedTab, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTab,
        onDestinationSelected: (index) => setState(() => _selectedTab = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Eksplorasi',
          ),
          NavigationDestination(
            icon: Icon(Icons.collections_bookmark_outlined),
            selectedIcon: Icon(Icons.collections_bookmark),
            label: 'Koleksi',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
