import 'package:flutter/material.dart';
import 'package:vanillacontacts_course/courses/value_notifier.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      //! Define "/new-contact" as a new route
      //! Upon floating action button press, send user to NewContactView
      routes: {
        '/new-contact': (context) => const NewContactView(),
      },
    );
  }
}
