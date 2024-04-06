import 'package:flutter/material.dart';
import 'package:ing_mobile/features/activities/test_page.dart';
import 'package:ing_mobile/features/home_page/home_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with TickerProviderStateMixin {

  int _selectedIndex = 0;

  List<Widget> widgetOptions = [];

  AnimationController? animationController;

  @override
  void initState() {

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    setState(() {
      widgetOptions = <Widget>[
        HomePage(animationController: animationController),
        const TestPage(),
        const TestPage(),
        const TestPage(),
      ];
    });
    
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white, // Repository.navbarColor(context),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedLabelStyle: const TextStyle(fontSize: 20, color: Color(0xFF000089)),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF000089), // Repository.selectedItemColor(context),
        unselectedItemColor: Colors.grey.withOpacity(0.7),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(IconData(0xe935, fontFamily: 'IconlyBold')), // Icon(IconlyBold.Home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconData(0xe923, fontFamily: 'IconlyBold')), // Icon(IconlyBold.Chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconData(0xe94b, fontFamily: 'IconlyBold')), // Icon(IconlyBold.Profile),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
