import 'package:flutter/material.dart';
import 'package:infinite_list_bloc/main.dart';
import 'package:infinite_list_bloc/posts/view/post_page.dart';
import 'package:infinite_list_bloc/posts/view/post_view.dart';

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const PostPage(),
//     );
//   }
// }

class MyApp extends MaterialApp {
  const MyApp({super.key}) : super(home: const PostPage());
}
