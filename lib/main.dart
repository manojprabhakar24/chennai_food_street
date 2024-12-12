import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'screens/main_screen.dart';
import 'provider/menu.dart';


void main() {
  runApp(RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MenuProvider()),
      ],
      child: MaterialApp(
        title: 'Chennai Food Street',
      theme: ThemeData(
      fontFamily: "Biofit",
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
      scaffoldBackgroundColor: backgroundColor,
      useMaterial3: true,
    ),
        debugShowCheckedModeBanner: false,
        home: RestaurantHomepage(),
      ),
    );
  }
}
