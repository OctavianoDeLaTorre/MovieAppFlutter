import 'package:flutter/material.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/screens/details_screen.dart';
import 'package:peliculas/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(AppState());
}


class AppState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => MoviesProvider(), lazy: false,),
      ],
      child: MyApp(),
    );
  }
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(color: Colors.pink)
      ),
      title: 'Peliculas',
      initialRoute: 'home',
      routes: {
        'home' : ( _ ) => HomeScreen(),
        'details': ( _ ) => DetailsScreen(),
      },
    );
  }

}
