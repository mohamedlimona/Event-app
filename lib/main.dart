import 'package:eventful_app/pages/edit_event_screen.dart';
import 'package:eventful_app/pages/home.dart';
import 'package:eventful_app/pages/login.dart';
import 'package:eventful_app/pages/register.dart';
import 'package:eventful_app/pages/user_events_screen.dart';
import 'package:eventful_app/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './pages/splash_screen.dart';
import './providers/products.dart';
import './pages/eventt_detail_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Events>(
          update: (ctx, auth, previouseventss) => Events(
            auth.token,
            auth.userId,
            previouseventss == null ? [] : previouseventss.items,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primaryColor: Color(0xff023429),
          ),
          home: auth.isAuth
              ? HomePage()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : LoginPage()),
          routes: {
            HomePage.routeName: (context) => HomePage(),
            LoginPage.routeName: (context) => LoginPage(),
            RegisterPage.routeName: (context) => RegisterPage(),
            UsereventsScreen.routeName: (ctx) => UsereventsScreen(),
            EditEventScreen.routeName: (ctx) => EditEventScreen(),
            eventDetailScreen.routeName:(ctx)=>eventDetailScreen()
          },
        ),
      ),
    );
  }
}
