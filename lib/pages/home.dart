import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:eventful_app/pages/favorite.dart';
import 'package:eventful_app/pages/profile.dart';
import 'package:eventful_app/pages/timeLine.dart';
import 'package:eventful_app/widgets/app_drawer.dart';
import '../pages/edit_event_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/homePage';

  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController;
  var _isInit = true;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
      drawer: AppDrawer(),
      body: PageView(
        children: <Widget>[
          Timeline(),
          FavoritePage(),
          ProfilePage(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(EditEventScreen.routeName);
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xff023429),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        opacity: .2,
        currentIndex: pageIndex,
        onTap: onTap,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        elevation: 8,
        fabLocation: BubbleBottomBarFabLocation.end, //new
        hasNotch: true, //new
        hasInk: true, //new, gives a cute ink effect
        inkColor: Colors.black12, //optional, uses theme color if not specified
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Colors.deepPurple,
              icon: Icon(
                Icons.dashboard,
                color: Colors.deepPurple,
              ),
              activeIcon: Icon(
                Icons.dashboard,
                color: Colors.deepPurple,
              ),
              title: Text("Home")),
          BubbleBottomBarItem(
              backgroundColor: Colors.red,
              icon: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              activeIcon: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              title: Text("Favourite")),
          BubbleBottomBarItem(
              backgroundColor: Colors.green,
              icon: Icon(
                Icons.account_circle,
                color: Colors.green,
              ),
              activeIcon: Icon(
                Icons.account_circle,
                color: Colors.green,
              ),
              title: Text("Profile"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildAuthScreen();
  }
}
